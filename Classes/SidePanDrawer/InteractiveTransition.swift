//
//  InteractiveTransition.swift
//  MoeUI
//
//  Created by Zed on 2019/8/1.
//

import UIKit


public class InteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    // MARK: Object Life Cycle
    public weak var sidePageVC: UIViewController?
    public weak var sideMainVC: UIViewController?
    public var enableEdgePan: Bool = false
    public var didPanClosure: ((_ panDirection: PanDirection) -> Void)?
    
    private var percent: CGFloat = 0
    private var remindCount: CGFloat = 0
    private var percentChangePerUpdate: CGFloat = 0.0
    private var waitToBeFinished: Bool = false

    /// 最小位移距离
    private var atLeastDistanceOfPan: CGFloat = 20.0
    private var finishLimitPercent: CGFloat = 0.97
    private var cancelLimitPercent: CGFloat = 0.03

    /// 是否正在进行交互操作
    var isInteracting: Bool = false

    private var transitionType: TransitionType
    var configuration: Configuration

    public init(transitionType: TransitionType, configuration: Configuration) {
        self.transitionType = transitionType
        self.configuration = configuration
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(sidePanDrawerDidTapAction(notification:)), name: .SidePanDrawerDidTapMaskView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sidePanDrawerDidPanAction(notification:)), name: .SidePanDrawerDidPanMaskView, object: nil)
    }

    deinit {
        MLog("InteractiveTransition deinit")
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Public Method
    public func addPanGesture(for viewController: UIViewController) {
        sideMainVC = viewController
        guard sideMainVC?.view != nil else { return }

        if enableEdgePan == true {
            let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanAction(edgePan:)))
            edgePan.edges = [.left, .right]
            edgePan.delegate = self
            sideMainVC!.view.addGestureRecognizer(edgePan)
        } else {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
            pan.delegate = self
            sideMainVC!.view.addGestureRecognizer(pan)
        }
    }

    // MARK: Event Response
    // MARK: -- Notification Event
    @objc public func sidePanDrawerDidTapAction(notification: Notification) {
        if transitionType == .present { return }
        sidePageVC?.dismiss(animated: true, completion: nil)
    }

    @objc private func sidePanDrawerDidPanAction(notification: Notification) {
        if transitionType == .present { return }
        if let pan = notification.object as? UIPanGestureRecognizer { handle(pan: pan) }
    }

    // MARK: -- Gesture Recognizer Event
    @objc private func panAction(pan: UIPanGestureRecognizer) {
        if transitionType == .dismiss { return }
        handle(pan: pan)
    }

    @objc private func edgePanAction(edgePan: UIScreenEdgePanGestureRecognizer) {

    }

    // MARK: Private Method
    private func handle(pan: UIPanGestureRecognizer) {
        guard pan.view != nil else { return }
        let x = pan.translation(in: pan.view!).x
        percent = x / pan.view!.frame.width

        if configuration.panDirection == .fromRight && transitionType == .present
            || configuration.panDirection == .fromLeft && transitionType == .dismiss
        { percent *= -1.0 }

        switch pan.state {
        case .changed:
            // 交互中, 更新交互状态
            if isInteracting == true { updateInteracting() }
            else {
                // 结束交互, 执行消失操作
                if transitionType == .dismiss { interactingDismiss(translationX: x) }
                    // 开始交互, 执行呈现操作
                else {
                    if fabs(x) > atLeastDistanceOfPan { interactingPresent(translationX: x) }
                }
            }
        case .cancelled, .ended:
            endInteracting()
        default:
            MLog("Panning but not handle")
        }
    }

    // MARK: -- Interacting
    private func updateInteracting() {
        percent = fmax(percent, cancelLimitPercent)
        percent = fmin(percent, finishLimitPercent)
        update(percent)
    }

    private func endInteracting() {
        isInteracting = false
        let isTransitionFinish = percent > configuration.criticalPercent
        beginTransitionEndAnimation(isTransitionFinish: isTransitionFinish)
    }

    // MARK: -- Translate Interaction
    private func interactingPresent(translationX: CGFloat) {
        if translationX >= 0.0 { configuration.panDirection = .fromLeft }
        else { configuration.panDirection = .fromRight }

        if translationX < 0.0 && configuration.panDirection == .fromLeft ||
            translationX > 0.0 && configuration.panDirection == .fromRight
        { return }

        self.isInteracting = true
        didPanClosure?(configuration.panDirection)
    }

    private func interactingDismiss(translationX: CGFloat) {
        if translationX > 0 && configuration.panDirection == .fromLeft
            || translationX < 0 && configuration.panDirection == .fromRight
        { return }

        isInteracting = true
        sidePageVC?.dismiss(animated: true, completion: nil)
    }

    // MARK: -- Transition Animation
    /// 开始执行结束动画, 完成剩余的转场交互过程及动画效果
    private func beginTransitionEndAnimation(isTransitionFinish: Bool) {
        if isTransitionFinish == true && percent >= 1.0 {
            finish()
            return
        }
        if isTransitionFinish == false && percent <= 0.0 {
            cancel()
            return
        }
        waitToBeFinished = isTransitionFinish
        let remindDuration: CGFloat = isTransitionFinish == true
            ? duration * (1 - percent) : duration * percent
        remindCount = 60 * remindDuration
        percentChangePerUpdate = isTransitionFinish ?
            (1 - percent) / remindCount : percent / remindCount
        startDisplayLink()
    }

    // MARK: -- Display Link
    private var link: CADisplayLink?

    private func startDisplayLink() {
        guard link == nil else { return }
        link = CADisplayLink(target: self, selector: #selector(displayLinkAction))
        link?.add(to: RunLoop.current, forMode: .commonModes)
    }

    private func stopDisplayLink() {
        link?.invalidate()
        link = nil
    }

    /// 定时器事件, 负责执行`平划手势释放时`至`转场交互结束`的转场交互进度更新及动画展示
    @objc private func displayLinkAction() {
        if percent >= finishLimitPercent && waitToBeFinished == true {
            stopDisplayLink()
            finish()
        } else if percent <= cancelLimitPercent && waitToBeFinished == false {
            stopDisplayLink()
            cancel()
        } else {
            if waitToBeFinished == true { percent += percentChangePerUpdate }
            else { percent -= percentChangePerUpdate }

            var currentPercent = fmax(percent, cancelLimitPercent)
            currentPercent = fmin(currentPercent, finishLimitPercent)
            update(currentPercent)
        }
    }
}

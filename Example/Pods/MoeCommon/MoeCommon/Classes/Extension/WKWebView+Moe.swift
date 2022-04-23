//
//  WKWebView+Moe.swift
//  MoeCommon
//
//  Created by Zed on 2020/12/25.
//

import WebKit


public extension TypeWrapperProtocol where WrappedType: WKWebView {
    /// 向WebView所加载页面注入JS方法，请在WebView完成Web页面的加载后执行本方法
    /// - Parameters:
    ///   - name:               JS方法的名称
    ///   - namesourceCode:     JS方法的源代码
    ///   - completionHandler:  注入结束的回调闭包
    func injectJSMethod(name: String, sourceCode: String, completionHandler: ((Any?, Error?) -> Void)?) {
        self.wrappedValue.evaluateJavaScript(sourceCode) { (result, error) in
            if let e = error {
                print("【WebView】注入方法：\(name), 出现错误：\(e)")
            } else {
                print("【WebView】注入方法：\(name), 处理结果：\(String(describing: result))")
            }
            completionHandler?(result, error)
        }
    }
    
    /// 向WebView所加载页面执行JS方法，请在WebView完成Web页面的加载后执行本方法
    /// - Parameters:
    ///   - name:               JS方法的名称，不需要携带括号`()`
    ///   - compeltionHandler:  执行结束的回调闭包
    func executeJSMethod(name: String, completionHandler: ((Any?, Error?) -> Void)?) {
        self.wrappedValue.evaluateJavaScript("\(name)()") { (result, error) in
            if let e = error {
                print("【WebView】执行方法：\(name), 出现错误：\(e)")
            } else {
                print("【WebView】执行方法：\(name), 处理结果：\(String(describing: result))")
            }
            completionHandler?(result, error)
        }
    }
    
    /// 禁用WebView的捏合手势
    func disableZoom() {
        let name = "moe_disableZoom"
        let code = """
        function \(name)(argument) {
            var script = document.createElement('meta');
            script.name = 'viewport';
            script.content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no";
            document.getElementsByTagName('head')[0].appendChild(script);
        }
        """
        let webView = self.wrappedValue
        injectJSMethod(name: name, sourceCode: code) { [weak webView] (result, error) in
            guard let strongWebView = webView else { return }
            strongWebView.moe.executeJSMethod(name: name, completionHandler: nil)
        }
    }
    
    /// iOS内联播放支持
    func supportInnerPlay() {
        let name = "moe_innerPlay"
        let code = """
        function \(name)() {
            var objs = document.querySelectorAll("video");
            for(var i = 0; i < objs.length; i++) {
                objs[i].setAttribute("width", "100%");
                objs[i].setAttribute("object-fit", "cover");
                objs[i].removeAttribute("height");
                objs[i].removeAttribute("wmode");
                objs[i].removeAttribute("play");
                objs[i].removeAttribute("loop");
                objs[i].removeAttribute("menu");
                objs[i].removeAttribute("allowscriptaccess");
                objs[i].removeAttribute("allowfullscreen");
                objs[i].setAttribute("controls", true);
                // objs[i].setAttribute("autoplay", false);
                objs[i].setAttribute("playsinline", "playsinline");
                objs[i].setAttribute("webkit-playsinline", "webkit-playsinline");
                objs[i].className = "__web-inspector-hide-shortcut__";
            }
        }
        """
        let webView = self.wrappedValue
        injectJSMethod(name: name, sourceCode: code) { [weak webView] (result, error) in
            guard let strongWebView = webView else { return }
            strongWebView.moe.executeJSMethod(name: name, completionHandler: nil)
        }
    }
    
    /// 获取Web页面中的所有图片（<img>标签元素的'src'属性值）
    /// - Parameter completionHanlder: 获取结束后执行的回调闭包
    func getImagesURL(completionHanlder: @escaping ((Array<String>) -> Void)) {
        let name = "moe_getImages"
        let code = """
        function \(name)() {
            var objs = document.getElementsByTagName("img"), imgUrlStr = "";
            for(let i = 0; i < objs.length; i++) {
                if(i === 0) {
                    imgUrlStr = objs[i].src;
                } else {
                    imgUrlStr += "#" + objs[i].src;
                }
                objs[i].onclick= function() {
                document.location="moemoetech://clickImage.moe/"+this.src;
                };
            }
            return imgUrlStr;
        }
        """
        let webView = self.wrappedValue
        injectJSMethod(name: name, sourceCode: code) { [weak webView] (result, error) in
            guard let strongWebView = webView else { return }
            strongWebView.moe.executeJSMethod(name: name) { (result, error) in
                guard var urlStrings = result as? String else { return }
                if urlStrings.hasPrefix("#"), let us = urlStrings.moe.subString(start: 1) { urlStrings = us }
                let urls = urlStrings.components(separatedBy: "#")
                completionHanlder(urls)
            }
        }
    }
}



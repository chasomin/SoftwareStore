//
//  WebViewController.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/7/24.
//

import UIKit
import WebKit
import SnapKit
import StoreKit

class WebViewController: UIViewController {
    let url: URLRequest
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        print("===", url)
        
        
//        let test = URL(string: "https://www.apple.com")
        
        webView.load(url)
    }
    
    //FIXME: 0x105054e18 - [pageProxyID=6, webPageID=7, PID=7289] WebPageProxy::didFailProvisionalLoadForFrame: frameID=1, isMainFrame=1, domain=WebKitErrorDomain, code=102, isMainFrame=1, willInternallyHandleFailure=0 뷰 안뜸
    
    
    init(url: URLRequest) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

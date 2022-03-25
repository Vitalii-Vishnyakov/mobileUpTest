//
//  LogInViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import UIKit
import WebKit
class LogInViewController: UIViewController , WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    

    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.getRequest { rezult in
            switch rezult {
                
            case .success(let request):
                self.webView.load(request)
                self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
            case .failure(_):
                print("error")
            }
        
        
    }
    
    
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url){
            
            
           
            guard let url = webView.url?.absoluteURL else {
                return
            }
            
            NetworkManager.encodeData(url: url) { response in
                for item in response.response.items {
                    print ( item.date)
                }
            }
            
        }
    }
    
    
    
}

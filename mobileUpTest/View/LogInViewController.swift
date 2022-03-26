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
    

    public var viewModel : ViewModelProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.networkManager.getRequest { rezult in
            switch rezult {
                
            case .success(let request):
                self.webView.load(request)
                self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
            case .failure(_):
                print("error")
            }
        
        
    }
    
        
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView.removeObserver(self, forKeyPath: "URL")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url){
            guard let url = webView.url?.absoluteURL  else {
                return
            }
            
            if "\(url)".contains("access_token="){
            
                viewModel.setToken(from: "\(url)"){ [weak self] result in
                    switch result{
                    case .success(_):
                        print("set New token")
                        
                        self?.dismiss(animated: true, completion: nil)
                    case .failure(_):
                        print("cantSet")
                    }
                    
                }
            }
        }
    }
    
    
    
}

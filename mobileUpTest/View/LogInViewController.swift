//
//  LogInViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import UIKit
import WebKit
class LogInViewController: UIViewController  {
    
    @IBOutlet weak var webView: WKWebView!
    
    var logged = false
    public var viewModel : ViewModelProtocol!
    var completion : ((Bool) -> Void )!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getRequest { [unowned self] rezult in
            switch rezult {
            case .success(let request):
                print(request)
                self.webView.load(request)
                self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
            case .failure(_):
                print("Creshed Link")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView.removeObserver(self, forKeyPath: "URL")
        if !logged{
            completion(false)}
    }
}

extension LogInViewController : WKNavigationDelegate{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url){
            guard let url = webView.url?.absoluteURL  else {
                self.completion(false)
                return
            }
            if "\(url)".contains("access_token="){
                viewModel.setToken(from: "\(url)"){ [weak self] isTokenSeted in
                    if isTokenSeted{
                        self?.logged = true
                        self?.completion(true)
                        self?.dismiss(animated: true, completion: nil)}
                    else {
                        self?.completion(false)
                    }
                }
            }
        }
    }
}

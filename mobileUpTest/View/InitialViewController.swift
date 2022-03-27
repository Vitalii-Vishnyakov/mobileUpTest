//
//  InitialViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    var viewModel : ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.setTitle(NSLocalizedString("enter_button", comment: ""), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.isTokenValid{
            loadPhotoCollectionView()
        }
    }
    
    
    @IBAction func pressEnterButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            let logInViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
            
            logInViewController.viewModel = viewModel
            logInViewController.completion = { [weak self] isLogged in
                if isLogged{
                    self?.loadPhotoCollectionView()
                    
                }else{
                    self?.showAlert(title : NSLocalizedString("dont_reg", comment: ""))
                }
                
            }
            present(logInViewController, animated: true, completion: nil)
        }
        else{
            showAlert(title : NSLocalizedString("no_connection", comment: ""))
        }
    }
    func loadPhotoCollectionView( ){
        if Reachability.isConnectedToNetwork(){
            let photoCollectionViewController = PhotoCollectionViewController(nibName: "PhotoCollectionViewController", bundle: nil)
            photoCollectionViewController.viewModel = viewModel
            navigationController?.pushViewController(photoCollectionViewController, animated: false)
            
        }else {
            showAlert(title : NSLocalizedString("no_connection", comment: ""))
        }
    }
    
    func showAlert(title : String){
        let alert  = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated : true , completion : nil)
    }
    
    
}

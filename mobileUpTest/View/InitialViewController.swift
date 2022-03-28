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
                    showAlert(title:"dont_reg", target: self)
                }
            }
            present(logInViewController, animated: true, completion: nil)
        }
        else{
            showAlert(title:"no_connection", target: self)
        }
    }
    func loadPhotoCollectionView( ){
        if Reachability.isConnectedToNetwork(){
            let photoCollectionViewController = PhotoCollectionViewController(nibName: "PhotoCollectionViewController", bundle: nil)
            photoCollectionViewController.viewModel = viewModel
            navigationController?.pushViewController(photoCollectionViewController, animated: false)
        }else {
            showAlert(title:"no_connection", target: self)
        }
    }
}

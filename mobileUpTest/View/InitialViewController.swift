//
//  InitialViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import UIKit

class InitialViewController: UIViewController {
    
    var viewModel : ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
      
        if viewModel.isTokenValid{
            let photoCollectionViewController = PhotoCollectionViewController(nibName: "PhotoCollectionViewController", bundle: nil)
            photoCollectionViewController.viewModel = viewModel
            navigationController?.pushViewController(photoCollectionViewController, animated: false)

        }
    }
    
    
    
    @IBAction func pressEnterButton(_ sender: Any) {
        
            let logInViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
            logInViewController.modalPresentationStyle = .fullScreen
            logInViewController.viewModel = viewModel
            present(logInViewController, animated: true, completion: nil)  
    }
    
    
}

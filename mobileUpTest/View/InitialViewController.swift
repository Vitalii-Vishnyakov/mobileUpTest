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
        if viewModel.isTokenValid{
            let photoCollectionViewController = PhotoCollectionViewController(nibName: "PhotoCollectionViewController", bundle: nil)
            
           
            navigationController?.pushViewController(photoCollectionViewController, animated: false)
            //photoCollectionViewController.modalPresentationStyle = .fullScreen
            //present(photoCollectionViewController, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func pressEnterButton(_ sender: Any) {
        
            let logInViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
            logInViewController.modalPresentationStyle = .fullScreen
            logInViewController.viewModel = viewModel
            present(logInViewController, animated: true, completion: nil)  
    }
    
    
}

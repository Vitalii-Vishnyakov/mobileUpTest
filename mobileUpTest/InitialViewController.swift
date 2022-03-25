//
//  InitialViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    @IBAction func pressEnterButton(_ sender: Any) {
        let logInViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
        logInViewController.modalPresentationStyle = .fullScreen
        present(logInViewController, animated: true, completion: nil)
        
    }
    

}

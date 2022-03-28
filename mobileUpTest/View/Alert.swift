//
//  Alert.swift
//  mobileUpTest
//
//  Created by Виталий on 28.03.2022.
//

import Foundation
import UIKit
func showAlert(title : String, target : UIViewController?){
    guard target != nil else {
        return
    }
    let alert  = UIAlertController(title: NSLocalizedString(title, comment: ""), message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    target!.present(alert, animated : true , completion : nil)
}

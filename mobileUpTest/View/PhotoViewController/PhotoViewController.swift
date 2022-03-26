//
//  PhotoViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    
 
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
       
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    

}

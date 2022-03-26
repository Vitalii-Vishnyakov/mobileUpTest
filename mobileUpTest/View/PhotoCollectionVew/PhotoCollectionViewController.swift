//
//  PhotoCollectionViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar( )
        self.collectionView!.register(UINib(nibName: "PhotoItemCollectionViewCell", bundle: nil),forCellWithReuseIdentifier:  reuseIdentifier)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setUpNavigationBar( ){
        navigationItem.title = "Mobile Up Gallery"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont (name: "SFProDisplay-Semibold", size: 18)!]
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(exitAction))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.width = 53
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 18)!], for: .normal)
    }
    @objc func exitAction ( ){
        navigationController?.popViewController(animated: true)
    }
    
}


extension PhotoCollectionViewController : UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoItemCollectionViewCell
        cell.imageView.image = UIImage(systemName: "plus")
    
        
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize( width: UIScreen.main.bounds.width / 2 - 0.5, height: UIScreen.main.bounds.width / 2)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }
    
    
}

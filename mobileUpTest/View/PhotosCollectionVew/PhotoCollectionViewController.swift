//
//  PhotoCollectionViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    
    public var viewModel : ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpNavigationBar( )
        self.collectionView!.register(UINib(nibName: "PhotoItemCollectionViewCell", bundle: nil),forCellWithReuseIdentifier:  reuseIdentifier)
        viewModel.networkManager.encodeData(with: viewModel.token) { response in
            self.viewModel.images = response.response.items
            self.collectionView.reloadData()
        }
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
        viewModel.logout { [weak self] result in
            switch result {
                
            case .success(_):
                self?.viewModel.networkManager.imageCash.removeAllObjects()
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(_):
                print("error")
            }
        }
    }
    
}


extension PhotoCollectionViewController : UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModel.images.count)
        return viewModel.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoItemCollectionViewCell
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        viewModel.networkManager.loadImagesWithCach(urlStr: viewModel.images[indexPath.row].sizes.last!.url) { image in
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
            cell.imageView.image = image
            
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController(nibName: "PhotoViewController", bundle: nil)
        photoViewController.viewModel = viewModel
        photoViewController.indexPath = indexPath.row
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .done, target: nil , action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.pushViewController(photoViewController, animated: true)
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize( width: UIScreen.main.bounds.width / 2 - 1, height: UIScreen.main.bounds.width / 2)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 2
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 2
    }
    
    
}

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
    
        let imageData = try! Data(contentsOf: URL(string: viewModel.images[indexPath.row].sizes.last!.url)!)
        DispatchQueue.main.async {
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.image = UIImage(data: imageData)
        }
            
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newvc = PhotoViewController(nibName: "PhotoViewController", bundle: nil)
        let imageData = try! Data(contentsOf: URL(string: viewModel.images[indexPath.row].sizes.last!.url)!)
        DispatchQueue.main.async {
            newvc.imageView.contentMode = .scaleAspectFill
            newvc.imageView.image = UIImage(data: imageData)
        }
        navigationController?.pushViewController(newvc, animated: true)
       
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

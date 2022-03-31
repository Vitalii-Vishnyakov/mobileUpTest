//
//  PhotoCollectionViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//
import UIKit

private let reuseIdentifier = "Cell"

final class PhotoCollectionViewController: UICollectionViewController {
    public var viewModel : ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar( )
        self.collectionView!.register(UINib(nibName: "PhotoItemCollectionViewCell", bundle: nil),forCellWithReuseIdentifier:  reuseIdentifier)
        viewModel.loadFromNet() { [weak self] result in
            switch result{
            case .success( _ ):
                self?.collectionView.reloadData()
            case .failure(let error):
                if error == .faildToDecodeData{
                    showAlert(title:"failed_to_decode", target: self)
                    self?.viewModel.images = [Item]()
                }
                else {
                    showAlert(title:"failed_to_load_data", target: self)
                    self?.viewModel.images =  [Item]()
                }
            }
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setUpNavigationBar( ){
        navigationItem.title = "Mobile Up Gallery"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont (name: "SFProDisplay-Semibold", size: 18)!]
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: NSLocalizedString("exit", comment: ""), style: .plain, target: self, action: #selector(exitAction))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.width = 53
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 18)!], for: .normal)
    }
    @objc func exitAction ( ){
        navigationController?.popViewController(animated: true)
        viewModel.logout { [weak self] isLoggedOut in
            if isLoggedOut{
                self?.navigationController?.popViewController(animated: true)
            }else{
                showAlert(title: "logout_failed", target: self)
            }
        }
    }
    
}


extension PhotoCollectionViewController : UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoItemCollectionViewCell
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        viewModel.loadImagesWithCach(at: indexPath.row) { [weak self] image in
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
            if image == nil {
                showAlert(title:"broken_image", target: self)
            }else{
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController(nibName: "PhotoViewController", bundle: nil)
        photoViewController.viewModel = viewModel
        viewModel.indexPath = indexPath.row
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .done, target: nil , action: nil)
        navigationController?.navigationBar.tintColor = .label
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

//
//  PhotoViewController.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//

import UIKit
private let reuseIdentifier = "photoCell"
class PhotoViewController: UIViewController{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel : ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil),forCellWithReuseIdentifier:  reuseIdentifier)
        setUpNavigationBar( )
        imageView.contentMode = .scaleAspectFill
        loadMainImage(new : viewModel.indexPath)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.scrollToItem(at: IndexPath(item: viewModel.indexPath , section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func sharingAction ( ){
        guard let image = viewModel.currenImage else {
            return
        }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = {[weak self] _ , isDone , _ , _ in
            if isDone {
                showAlert(title:"saved_or_send", target: self)
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    @objc func exitAction ( ){
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpNavigationBar( ){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Vector"), style: .plain, target: self, action: #selector(sharingAction))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont (name: "SFProDisplay-Semibold", size: 18)!]
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.width = 53
    }
    
    func loadMainImage ( new indexPath : Int){
        viewModel.indexPath = indexPath
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        viewModel.networkManager.loadImagesWithCach(urlStr: viewModel.images[indexPath].sizes.last!.url, completion: {[weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            self?.imageView.image = image
            self?.viewModel.currenImage = image
        })
        viewModel.setUpTitle { date in
            navigationItem.title =  date
        }
    }
}

extension PhotoViewController :  UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        viewModel.networkManager.loadImagesWithCach(urlStr: viewModel.images[indexPath.row].sizes.last!.url) {[weak self] image in
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.scrollView.setZoomScale(0.0, animated: true)
        loadMainImage(new: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize( width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
}

extension PhotoViewController : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

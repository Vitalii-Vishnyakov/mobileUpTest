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
    var indexPath : Int = 0
    
    var currenImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil),forCellWithReuseIdentifier:  reuseIdentifier)
        setUpNavigationBar( )
        imageView.contentMode = .scaleAspectFill
        
        
        loadMainImage(new : indexPath)
        
        scrollView.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.scrollToItem(at: IndexPath(item: indexPath , section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func sharingAction ( ){
        let shareController = UIActivityViewController(activityItems: [self.currenImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _ , isDone , _ , _ in
            if isDone {
                print("done")
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    @objc func exitAction ( ){
        navigationController?.popViewController(animated: true)
    }
   
    private func setUpNavigationBar( ){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharingAction))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont (name: "SFProDisplay-Semibold", size: 18)!]
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.width = 53
    }
    private func setUpTitle (new indexPath : Int ){
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "d MMMM yyyy"
        let date = Date(timeIntervalSince1970: TimeInterval( viewModel.images[indexPath].date))
        navigationItem.title =  "\(dateFormatterPrint.string(from: date))"
    }
    func loadMainImage ( new indexPath : Int){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        viewModel.networkManager.loadImagesWithCach(urlStr: viewModel.images[indexPath].sizes.last!.url, completion: { image in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.image = image
            self.currenImage = image
            
        })
        setUpTitle ( new: indexPath)
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
         viewModel.networkManager.loadImagesWithCach(urlStr: viewModel.images[indexPath.row].sizes.last!.url) { image in
             cell.activityIndicator.stopAnimating()
             cell.activityIndicator.isHidden = true
             cell.imageView.image = image
             
         }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

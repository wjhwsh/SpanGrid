//
//  FirstViewController.swift
//  SpanGridLayoutDemo
//
//  Created by Jianhua Wang on 2/17/17.
//
//

import UIKit
import AlamofireImage

class FirstViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spanGridLayout: SpanGridCollectionViewLayout!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var photoModel: PhotoModel!
    var lastLoadingError: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spanGridLayout.delegate = self
        self.collectionView.register(UINib(nibName: "LoadingCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingView")
        PhotoService.sharedInstance.serviceClient = FlickerClient()
        self.photoModel = PhotoModel()
        loadingActivity.startAnimating()
        self.photoModel.loadingPhoto(more: false) { (error) in
            self.lastLoadingError = error
            self.loadingActivity.stopAnimating()
            self.collectionView.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is PhotoDetailViewController) {
            let detailVC = segue.destination as! PhotoDetailViewController
            detailVC.photoModel = self.photoModel
        }
    }
}

extension FirstViewController : UICollectionViewDataSource {
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        configureCell(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    func configureCell(cell: PhotoCollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = self.photoModel.photos[indexPath.row]
        if let url = URL(string: photo.imageUrl) {
            cell.photoImageView.af_setImage(withURL: url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingView", for: indexPath) as! LoadingCollectionReusableView
        self.lastLoadingError = nil
        footView.loadingActivity.startAnimating()
        self.photoModel.loadingPhoto(more: true) { (error) in
            self.lastLoadingError = error
            footView.loadingActivity.stopAnimating()
            self.collectionView.reloadData()
        }
        
        return footView
    }
}

extension FirstViewController : SpanGridCollectionViewLayoutDelegate {
    func totalPhotoCountInGallery() -> Int {
        return self.photoModel.totalPhotoCount
    }
    
    func loadingError() -> Error? {
        return lastLoadingError
    }
}
/*
extension FirstViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let photoDetailVC = 
    }
}
 */


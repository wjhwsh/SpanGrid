//
//  PhotoDetailViewController.swift
//  SpanGridLayoutDemo
//
//  Created by Jianhua Wang on 2/18/17.
//
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var photoModel: PhotoDataSource?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoDetailViewController : UICollectionViewDataSource {
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoDetailCell", for: indexPath) as! PhotoDetailCollectionViewCell
        configureCell(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    func configureCell(cell: PhotoDetailCollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photo = self.photoModel?.photos[indexPath.row] {
            if let url = URL(string: photo.imageUrl) {
                cell.imageView.af_setImage(withURL: url)
            }
        }
    }
    
}




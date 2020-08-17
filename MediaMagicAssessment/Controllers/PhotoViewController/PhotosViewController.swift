//
//  PhotosViewController.swift
//  MediaMagicAssessment
//
//  Created by Subhash Kumar on 8/13/20.
//  Copyright © 2020 Subhash Kumar. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosViewController: BaseViewController {

    // MARK: Variables
       lazy var viewModel: PhotosViewModel = {
           let obj = PhotosViewModel(userService: UserService())
           self.baseVwModel = obj
           return obj
       }()
    
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewForPhotos: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupClosures()
        activityView.startAnimating()
        viewModel.fetchPhotos()
        // Do any additional setup after loading the view.
    }
    // MARK: Setup
    func setupClosures() {
        viewModel.redirectControllerClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.activityView.stopAnimating()
               self?.collectionViewForPhotos.reloadData()
//                self?.spinner.stopAnimating()
//                self?.tblView.tableFooterView?.isHidden = true
                //self?.movetoDashbaord(animation: true)
            }
        }
    }

}

extension PhotosViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrForPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        let photoObject = viewModel.arrForPhotos[indexPath.item]
        cell.imgViewForPhoto.setShowActivityIndicator(true)
        cell.imgViewForPhoto.setIndicatorStyle(.medium)
        cell.imgViewForPhoto.sd_setImage(with: URL(string: "\(Config.imageBaseUrl)\(photoObject.id ?? 0)"), placeholderImage: UIImage(named: ""))
        cell.lblForAuthor.text = photoObject.author
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 215)
    }
    
}
class PhotosCell: UICollectionViewCell {
    @IBOutlet weak var lblForAuthor:UILabel!
     @IBOutlet weak var imgViewForPhoto:UIImageView!
    
    override func awakeFromNib() {
        
    }
}

//
//  PhotosViewModel.swift
//  MediaMagicAssessment
//
//  Created by Subhash Kumar on 8/13/20.
//  Copyright © 2020 Subhash Kumar. All rights reserved.
//

import UIKit

class PhotosViewModel: BaseViewModel {

    var userService: UserServiceProtocol
    var arrForPhotos = Array<Photo>()
    
       init(userService: UserServiceProtocol) {
           self.userService = userService
       }
    
    func fetchPhotos()  {
        userService.getPhotos(with: self) { (result) in
            if result != nil{
                if let arr = result as? Array<Photo>{
                    self.arrForPhotos = arr
                }
               self.redirectControllerClosure?()
            }
        }
    }
}

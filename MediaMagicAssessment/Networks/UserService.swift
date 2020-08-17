

import Foundation
import UIKit

protocol UserServiceProtocol {
   func getPhotos(with viewModel:BaseViewModel?, completion:@escaping (Any?) -> Void)
   
}

public class UserService: APIService, UserServiceProtocol {
    
    func getPhotos(with viewModel:BaseViewModel?, completion:@escaping (Any?) -> Void){
       // viewModel?.isLoading = true
        let param = [:] as [String: Any]
       // let param = ["page":page,"limit":limit] as [String: Any]
        super.startService(with: .get, path: "", maptype: false, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                viewModel?.isLoading = false
                switch result {
                case .Success(let data):
                    if let response = data as? Array<Dictionary<String,Any>> {
                        let photos = Photo.modelsFromDictionaryArray(array: response)
                        completion(photos)
                    }
                case . Error(let message):
                    viewModel?.isSuccess = false
                    viewModel?.errorMessage = message
                    completion(nil)
                }
            }
        }
    }
}


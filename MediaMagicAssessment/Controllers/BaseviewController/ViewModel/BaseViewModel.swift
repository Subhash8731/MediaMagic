

import UIKit
//import Reachability
enum AlertType {
    case normal
    case warning
    case error
    case success
    case custom
}

class BaseViewModel: NSObject {

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?(.success)
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    
    var isSuccess:Bool? {
        didSet {
            if isSuccess ?? false {
                self.redirectControllerClosure?()
            }
        }
    }
    
    var isFailed:Bool? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
//    func checkReachability() -> Bool {
//                let reachability = try! Reachability()
//        switch reachability.connection {
//        case .wifi:
//            print("")
//            return true
//        case .cellular:
//            print("")
//            return true
//        case .unavailable:
//            print("Unreachable...")
//            return false
//        case .none:
//            print("None")
//            return false
//        }
//    }
    
    var showAlertClosure: ((_ type: AlertType)->Void)?
    var updateLoadingStatus: (()->Void)?
    var reloadListViewClosure: (()->Void)?
    var redirectControllerClosure: (()->Void)?
}

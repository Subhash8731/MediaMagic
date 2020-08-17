
import UIKit

class BaseViewController: UIViewController{

    let NAVIGATION_BACK_BUTTON = 1
    let NAVIGATION_SIGNOUT_BUTTON = 2
   
    
    var isBackButtonHidden:Bool?
    var isLogoutButtonHidden:Bool?
    
    var baseVwModel: BaseViewModel? {
        didSet {
            initBaseModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    // Cann't be override by subclass
    final func initBaseModel() {
        // Native binding
        baseVwModel?.showAlertClosure = { [weak self] (_ type:AlertType) in
            DispatchQueue.main.async {
                if type == .success, let message = self?.baseVwModel?.alertMessage  {
                    let configAlert : AlertUI = ("", message)
                    UIAlertController.showAlert(configAlert)
                } else {
                    let message = self?.baseVwModel?.errorMessage ?? "Some Error occured"
                    let configAlert : AlertUI = ("", message)
                    UIAlertController.showAlert(configAlert)
                }
            }
        }
        baseVwModel?.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                
            }
        }
    }
    
   
    
}






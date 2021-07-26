import UIKit

extension UIButton{
    
    func setButtonBorder(ofWidth width : CGFloat, color : UIColor){
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func setButtonTitle(forText text : String? = ""){
        self.setTitle(text, for: .normal)
    }
}

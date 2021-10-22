import UIKit

extension UIButton {
    
    // Set shadow and radius of Button
    func setShadowAndRadius() {
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.systemGray4.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .init(width: -5, height: 5)
        self.layer.shadowRadius = 3
    }
}

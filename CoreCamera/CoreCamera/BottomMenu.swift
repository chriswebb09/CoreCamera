import UIKit

protocol BottomMenuViewable {
    
    var bottomMenu: BottomMenu { get set }
    
    func hidePopMenu(_ view: UIView)
    func showPopMenu(_ view: UIView)
    func moreButton(tapped: Bool)
}

extension BottomMenuViewable {
    
    func hidePopMenu(_ view: UIView) {
        bottomMenu.hideFrom(view)
    }
    
    func showPopMenu(_ view: UIView){
        bottomMenu.showOn(view)
    }
    
    func menuSetup() {
        let height = UIScreen.main.bounds.height * 0.5
        let width = UIScreen.main.bounds.width
        let size = CGSize(width: width, height: height)
        let originX = UIScreen.main.bounds.width * 0.001
        let originY = UIScreen.main.bounds.height * 0.1
        let origin = CGPoint(x: originX, y: originY)
        
        
        bottomMenu.setMenu(size)
        bottomMenu.setMenu(origin)
        bottomMenu.setupMenu()
        bottomMenu.setMenu(color: .white, borderColor: .darkGray, textColor: .darkGray)
    }
}

class BottomMenu {
    
    var menu: MenuView = {
        let menuView = MenuView()
        menuView.isUserInteractionEnabled = true
        return menuView
    }()
    
    func setMenu(_ size: CGSize) {
        menu.frame.size = size
    }
    
    func setMenu(_ origin: CGPoint) {
        menu.frame.origin = origin
    }
    
    func setMenu(color: UIColor, borderColor: UIColor, textColor: UIColor) {
        menu.setMenuColor(backgroundColor: color, borderColor: borderColor, labelTextColor: textColor)
    }
    
    func setupMenu() {
        menu.isUserInteractionEnabled = true
        menu.configureView()
    }
    
    func showOn(_ view: UIView) {
        view.addSubview(menu)
        view.bringSubview(toFront: menu)
        menu.alpha = 1
    }
    
    func hideFrom(_ view: UIView) {
        view.sendSubview(toBack: menu)
        menu.alpha = 0
    }
}

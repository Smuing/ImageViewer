import UIKit

public struct ImageViewer {
    private init() {}
    
    public static func show(imagesArray: Array<String>, startIndex: Int = 0, font: UIFont? = UIFont.systemFont(ofSize: 16, weight: .medium), handler: ((Int) -> Void)? = nil) {
        var index = startIndex
        if imagesArray.count <= 0 {
            return
        }
        if index < 0 {
            index = 0
        } else if index > imagesArray.count - 1 {
            index = imagesArray.count - 1
        }
        DispatchQueue.main.async {
            if let naviCon = UIStoryboard(name: "ImageViewer", bundle: Bundle.module).instantiateViewController(withIdentifier: "ImageViewerViewController") as? ImageViewerViewController {
                naviCon.modalPresentationStyle = .overFullScreen
                naviCon.imagesArray = imagesArray
                naviCon.currentIndex = index
                naviCon.font = font ?? UIFont.systemFont(ofSize: 16, weight: .medium)
                naviCon.callBackHandler(handler)
                UIApplication.topViewController()?.present(naviCon, animated: true)
            }
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

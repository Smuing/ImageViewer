//
//  ImageViewController.swift
//  
//
//  Created by 나성민 on 12/8/23.
//

import UIKit
import SDWebImage

protocol ImageViewControllerDelegate {
    func imageViewControllerDidDisappear(_ index: Int)
}

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    private var image: UIImage?
    private var url: String?
    var index: Int = 0
    var delegate: ImageViewControllerDelegate?
    
    static func getInstance(_ image: UIImage?, _ url: String?) -> ImageViewController {
        let vc = UIStoryboard(name: "ImageViewer", bundle: Bundle.module).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        vc.image = image
        vc.url = url
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        config()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.imageViewControllerDidDisappear(self.index)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.imageView.sd_cancelCurrentImageLoad()
        self.scrollView.zoomScale = 1.0
    }
    
    func config() {
        if let image = self.image {
            self.imageView.image = image
        }
        if let url = self.url {
            self.imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholderImage"))
        }
        self.scrollView.delegate = self
        self.scrollView.zoomScale = 1.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        let newContentOffsetX = (self.scrollView.contentSize.width/2) - (self.scrollView.bounds.size.width/2)
        self.scrollView.contentOffset = CGPointMake(newContentOffsetX, 0)
        
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        if self.scrollView.zoomScale > 1.0 {
            self.scrollView.setZoomScale(1.0, animated: true)
        } else {
            self.scrollView.setZoomScale(2.0, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImageViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let scrollViewSize = scrollView.frame.size
        var contentOffset = scrollView.contentOffset
        
        if (contentSize.width < scrollViewSize.width) {
            contentOffset.x = -(scrollViewSize.width - contentSize.width) / 2.0
        }
        if (contentSize.height < scrollViewSize.height) {
            contentOffset.y = -(scrollViewSize.height - contentSize.height) / 2.0
        }
        
        scrollView.setContentOffset(contentOffset, animated: false)
    }
    
}

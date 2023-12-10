//
//  ImagePageViewController.swift
//  
//
//  Created by 나성민 on 12/8/23.
//

import UIKit

protocol ImagePageViewControllerDelegate {
    func updateCurrentIndex(_ current: Int)
    func buttonEnabled(_ isEnabled: Bool)
}

class ImagePageViewController: UIPageViewController {
    
    var currentIndex: Int = 0
    private var imagesArray: Array<String> = []
    private var imageViewCons: [UIViewController] = []
    var imagePageViewDelegate: ImagePageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        initImageViewCons()
    }
    
    func setImages(_ imagesArray: Array<String>) {
        self.imagesArray = imagesArray
    }
    
    private func initImageViewCons () {
        for (index, image) in imagesArray.enumerated() {
            let imageViewCon = ImageViewController.getInstance(image)
            imageViewCon.index = index
            imageViewCon.delegate = self
            imageViewCons.append(imageViewCon)
        }
        
        self.setViewControllers([imageViewCons[currentIndex]], direction: .forward, animated: false)
    }
    
    func moveToIndex(_ index: Int) {
        if imagesArray.count > 0, index >= 0, index < imagesArray.count {
            self.view.isUserInteractionEnabled = false;
            DispatchQueue.main.async {
                self.setViewControllers([self.imageViewCons[self.currentIndex]], direction: .forward, animated: false, completion: {
                    complete in if complete {
                        self.setViewControllers([self.imageViewCons[index]], direction: index > self.currentIndex ? .forward : .reverse, animated: true, completion: {
                            complete in if complete {
                                self.imagePageViewDelegate?.updateCurrentIndex(index)
                                self.view.isUserInteractionEnabled = true
                            }
                        })
                    }
                })
            }
        }
    }
}

extension ImagePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewConIndex = imageViewCons.firstIndex(of: viewController) else {
            return nil
        }
        let prevIndex = viewConIndex - 1

        guard prevIndex >= 0 else {
            return nil
        }

        return imageViewCons[prevIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewConIndex = imageViewCons.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewConIndex + 1

        guard nextIndex < imageViewCons.count else {
            return nil
        }

        return imageViewCons[nextIndex]
    }
}

extension ImagePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.imagePageViewDelegate?.buttonEnabled(false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.imagePageViewDelegate?.buttonEnabled(true)
        if previousViewControllers.count > 0 {
            let prevViewCon = previousViewControllers[0] as! ImageViewController
            if currentIndex == prevViewCon.index {
                return
            }
        }
        
        guard completed, let currentViewCon = pageViewController.viewControllers?.first, let index = imageViewCons.firstIndex(of: currentViewCon) else {
            return
        }
        self.imagePageViewDelegate?.updateCurrentIndex(index)
    }
}

extension ImagePageViewController: ImageViewControllerDelegate {
    func imageViewControllerDidDisappear(_ index: Int) {
        self.imagePageViewDelegate?.updateCurrentIndex(index)
        self.view.isUserInteractionEnabled = true
    }
}

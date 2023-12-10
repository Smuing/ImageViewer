//
//  ImageViewerViewController.swift
//  
//
//  Created by 나성민 on 12/8/23.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    private var imagePageViewController: ImagePageViewController!
    var imagesArray: [ImageItem] = []
    var currentIndex: Int = 0
    var font: UIFont!
    private var handler: ((Int) -> Void)?
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var prevButtonView: UIView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.numberLabel.font = font
        self.updateNumberLabel()
        
        nextButton.isExclusiveTouch = true
        prevButton.isExclusiveTouch = true
        self.updateButtonView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? ImagePageViewController {
            self.imagePageViewController = vc
            self.imagePageViewController.setImages(imagesArray)
            self.imagePageViewController.currentIndex = self.currentIndex
            self.imagePageViewController.imagePageViewDelegate = self
        }
    }
    
    private func updateNumberLabel() {
        self.numberLabel.text = "\(currentIndex+1)/\(imagesArray.count)"
    }
    
    private func updateButtonView() {
        self.prevButtonView.isHidden = false
        self.nextButtonView.isHidden = false
        if currentIndex == 0 {
            self.prevButtonView.isHidden = true
        }
        if currentIndex >= imagesArray.count - 1 {
            self.nextButtonView.isHidden = true
        }
    }
    
    func callBackHandler(_ handler: ((Int) -> Void)?) {
        self.handler = handler
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.buttonEnabled(false)
        let nextIndex = currentIndex + 1
        if nextIndex < imagesArray.count {
            self.imagePageViewController.moveToIndex(nextIndex)
        }
    }
    @IBAction func prevButtonAction(_ sender: UIButton) {
        self.buttonEnabled(false)
        let prevIndex = currentIndex - 1
        if prevIndex >= 0 {
            self.imagePageViewController.moveToIndex(prevIndex)
        }
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.handler?(self.currentIndex)
        }
    }
    
}

extension ImageViewerViewController: ImagePageViewControllerDelegate {
    func updateCurrentIndex(_ index: Int) {
        self.currentIndex = index
        self.imagePageViewController.currentIndex = index
        self.updateNumberLabel()
        self.updateButtonView()
        self.buttonEnabled(true)
    }
    
    func buttonEnabled(_ isEnabled: Bool) {
        self.nextButton.isEnabled = isEnabled
        self.prevButton.isEnabled = isEnabled
    }
}


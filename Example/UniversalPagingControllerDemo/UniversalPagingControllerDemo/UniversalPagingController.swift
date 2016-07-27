//
//  UniversalPagingController.swift
//  UniversalPagingControllerDemo
//
//  Created by Piotr Jamróz on 24.07.2016.
//  Copyright © 2016 Piotr Jamróz. All rights reserved.
//

import UIKit

class UniversalPagingController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    
    private var viewControllers: [UIViewController]!
    private var visibleViewControllerIndex = 0
    
    // MARK: - Life cycle
    class func create() -> (UniversalPagingController?) {
        let storyboard = UIStoryboard(name: String(UniversalPagingController), bundle: nil)
        let instance = storyboard.instantiateViewControllerWithIdentifier(String(UniversalPagingController))
        return instance as? UniversalPagingController
    }
    
    class func createWithViewControllers(viewControllers: [UIViewController]) -> (UniversalPagingController?) {
        let instance = create()
        if let _ = instance {
            instance!.viewControllers = viewControllers
        }
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup(childViewControllers: viewControllers)
        
        let leftEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(UniversalPagingController.userSwipedFromEdge(_:)))
        leftEdgeGestureRecognizer.edges = .Left
        leftEdgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(leftEdgeGestureRecognizer)
        
        let rightEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(UniversalPagingController.userSwipedFromEdge(_:)))
        rightEdgeGestureRecognizer.edges = .Right
        rightEdgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(rightEdgeGestureRecognizer)
        
        setupAppearance()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers[visibleViewControllerIndex].beginAppearanceTransition(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers[visibleViewControllerIndex].endAppearanceTransition()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewControllers[visibleViewControllerIndex].beginAppearanceTransition(true, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        viewControllers[visibleViewControllerIndex].endAppearanceTransition()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return false
    }
    
    // MARK: - Orientation change
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        // Code here will execute before the rotation begins.
        scrollView.scrollEnabled = false
        
        coordinator.animateAlongsideTransition({ [unowned self] (UIViewControllerTransitionCoordinatorContext) in
            // Code here to perform animations during the rotation.
            self.scrollView.setContentOffset(CGPoint(x: self.containerView.frame.size.width * CGFloat(self.visibleViewControllerIndex), y: 0), animated: false)
            
        }) { [unowned self] (UIViewControllerTransitionCoordinatorContext) in
            // Code here will execute after the rotation has finished.
            self.scrollView.scrollEnabled = true
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func userSwipedFromEdge(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.edges == UIRectEdge.Left && sender.state == .Ended {
            if visibleViewControllerIndex > 0 {
                let visibleViewControllerIndexBeforeTransition = visibleViewControllerIndex
                let visibleViewControllerIndexAfterTransition = visibleViewControllerIndex - 1
                viewControllers[visibleViewControllerIndexBeforeTransition].beginAppearanceTransition(false, animated: true)
                viewControllers[visibleViewControllerIndexAfterTransition].beginAppearanceTransition(true, animated: true)
                scrollView.setContentOffset(CGPoint(x: containerView.frame.size.width * CGFloat(visibleViewControllerIndexAfterTransition), y: 0), animated: true)
                viewControllers[visibleViewControllerIndexAfterTransition].endAppearanceTransition()
                viewControllers[visibleViewControllerIndexBeforeTransition].endAppearanceTransition()
                visibleViewControllerIndex = visibleViewControllerIndexAfterTransition
            } else {
                shake()
            }
        } else if sender.edges == UIRectEdge.Right && sender.state == .Ended {
            if visibleViewControllerIndex+1 < viewControllers.count {
                let visibleViewControllerIndexBeforeTransition = visibleViewControllerIndex
                let visibleViewControllerIndexAfterTransition = visibleViewControllerIndex + 1
                viewControllers[visibleViewControllerIndexBeforeTransition].beginAppearanceTransition(false, animated: true)
                viewControllers[visibleViewControllerIndexAfterTransition].beginAppearanceTransition(true, animated: true)
                scrollView.setContentOffset(CGPoint(x: containerView.frame.size.width * CGFloat(visibleViewControllerIndexAfterTransition), y: 0), animated: true)
                viewControllers[visibleViewControllerIndexAfterTransition].endAppearanceTransition()
                viewControllers[visibleViewControllerIndexBeforeTransition].endAppearanceTransition()
                visibleViewControllerIndex = visibleViewControllerIndexAfterTransition
            } else {
                shake()
            }
        }
    }
    
    // MARK: - Private
    private func setup(childViewControllers viewControllers: [UIViewController]) {
        for (index, viewController) in viewControllers.enumerate() {
            addChildViewController(viewController)
            scrollView.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            // constraint height and width
            let heightConstraint = NSLayoutConstraint(item: viewController.view,
                                                      attribute: .Height,
                                                      relatedBy: .Equal,
                                                      toItem: containerView,
                                                      attribute: .Height,
                                                      multiplier: 1.0,
                                                      constant: 0.0)
            
            let widthConstraint = NSLayoutConstraint(item: viewController.view,
                                                     attribute: .Width,
                                                     relatedBy: .Equal,
                                                     toItem: containerView,
                                                     attribute: .Width,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
            heightConstraint.active = true
            widthConstraint.active = true
            
            // contraint top and bottom
            let topConstraint = NSLayoutConstraint(item: viewController.view,
                                                   attribute: .Top,
                                                   relatedBy: .Equal,
                                                   toItem: scrollView,
                                                   attribute: .Top,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
            
            let bottomConstraint = NSLayoutConstraint(item: viewController.view,
                                                      attribute: .Bottom,
                                                      relatedBy: .Equal,
                                                      toItem: scrollView,
                                                      attribute: .Bottom,
                                                      multiplier: 1.0,
                                                      constant: 0.0)
            
            topConstraint.active = true
            bottomConstraint.active = true
            
            if viewControllers.count == 1 {
                let leadingConstraint = NSLayoutConstraint(item: viewController.view,
                                                           attribute: .Leading,
                                                           relatedBy: .Equal,
                                                           toItem: scrollView,
                                                           attribute: .Leading,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
                let trailingConstraint = NSLayoutConstraint(item: viewController.view,
                                                            attribute: .Trailing,
                                                            relatedBy: .Equal,
                                                            toItem: scrollView,
                                                            attribute: .Trailing,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
                
                leadingConstraint.active = true
                trailingConstraint.active = true
            } else if index == 0 {
                let leadingConstraint = NSLayoutConstraint(item: viewController.view,
                                                           attribute: .Leading,
                                                           relatedBy: .Equal,
                                                           toItem: scrollView,
                                                           attribute: .Leading,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
                leadingConstraint.active = true
            } else if index > 0 {
                let leadingConstraint = NSLayoutConstraint(item: viewController.view,
                                                           attribute: .Leading,
                                                           relatedBy: .Equal,
                                                           toItem: viewControllers[index-1].view,
                                                           attribute: .Trailing,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
                leadingConstraint.active = true
            } else if index-1 == viewControllers.count && viewControllers.count > 1 {
                let trailingConstraint = NSLayoutConstraint(item: viewController.view,
                                                            attribute: .Trailing,
                                                            relatedBy: .Equal,
                                                            toItem: scrollView,
                                                            attribute: .Trailing,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
                trailingConstraint.active = true
            }
        }
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 1
        shake.autoreverses = true
        shake.fromValue = NSValue(CGPoint: CGPoint(x: view.center.x - 6, y: view.center.y))
        shake.toValue = NSValue(CGPoint: CGPoint(x: view.center.x + 6, y: view.center.y))
        view.layer.addAnimation(shake, forKey: "position")
    }
    
    private func setupAppearance() {
    // Do any aditional ui setup
    }
}

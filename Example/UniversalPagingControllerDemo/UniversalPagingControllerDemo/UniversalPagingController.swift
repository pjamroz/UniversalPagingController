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
    private let scrollView: UIScrollView
    private let containerView: UIView
    private let viewControllers: [UIViewController]
    private var visibleViewControllerIndex = 0
    
    // MARK: - Life cycle
    init() {
        scrollView = UIScrollView()
        containerView = UIView()
        viewControllers = [UIViewController]()
        super.init(nibName: nil, bundle:nil)
    }
    
    init(viewControllers: [UIViewController]) {
        scrollView = UIScrollView()
        containerView = UIView()
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        scrollView = UIScrollView()
        containerView = UIView()
        viewControllers = [UIViewController]()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupChildViewControllers(viewControllers)
        
        let leftEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(UniversalPagingController.userSwipedFromEdge(_:)))
        leftEdgeGestureRecognizer.edges = .Left
        leftEdgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(leftEdgeGestureRecognizer)
        
        let rightEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(UniversalPagingController.userSwipedFromEdge(_:)))
        rightEdgeGestureRecognizer.edges = .Right
        rightEdgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(rightEdgeGestureRecognizer)
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
        viewControllers[visibleViewControllerIndex].beginAppearanceTransition(false, animated: true)
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
                scrollItemsForward(false)
            } else {
                //
            }
        } else if sender.edges == UIRectEdge.Right && sender.state == .Ended {
            if visibleViewControllerIndex+1 < viewControllers.count {
                scrollItemsForward(true)
            } else {
                //
            }
        }
    }
    
    // MARK: - Private
    
    private func setupAppearance() {
        view.addSubview(containerView)
        centerConstraintsForView(containerView)
        
        containerView.addSubview(scrollView)
        centerConstraintsForView(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        scrollView.scrollEnabled = false
    }
    
    private func setupChildViewControllers(viewControllers: [UIViewController]) {
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
            
            if index == 0 {
                let leadingConstraint = NSLayoutConstraint(item: viewController.view,
                                                           attribute: .Leading,
                                                           relatedBy: .Equal,
                                                           toItem: scrollView,
                                                           attribute: .Leading,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
                leadingConstraint.active = true
            } else {
                let leadingConstraint = NSLayoutConstraint(item: viewController.view,
                                                           attribute: .Leading,
                                                           relatedBy: .Equal,
                                                           toItem: viewControllers[index-1].view,
                                                           attribute: .Trailing,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
                leadingConstraint.active = true
            }
            
            if index == viewControllers.count-1 {
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
    
    private func scrollItemsForward(forward: Bool) {
        let visibleViewControllerIndexBeforeTransition = visibleViewControllerIndex
        let visibleViewControllerIndexAfterTransition = forward ? visibleViewControllerIndex + 1 : visibleViewControllerIndex - 1
        viewControllers[visibleViewControllerIndexBeforeTransition].beginAppearanceTransition(false, animated: true)
        viewControllers[visibleViewControllerIndexAfterTransition].beginAppearanceTransition(true, animated: true)
        scrollView.setContentOffset(CGPoint(x: containerView.frame.size.width * CGFloat(visibleViewControllerIndexAfterTransition), y: 0), animated: true)
        viewControllers[visibleViewControllerIndexAfterTransition].endAppearanceTransition()
        viewControllers[visibleViewControllerIndexBeforeTransition].endAppearanceTransition()
        visibleViewControllerIndex = visibleViewControllerIndexAfterTransition
    }
    
    private func centerConstraintsForView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: view,
                                               attribute: .Top,
                                               relatedBy: .Equal,
                                               toItem: view.superview,
                                               attribute: .Top,
                                               multiplier: 1.0,
                                               constant: 0.0)
        
        let bottomConstraint = NSLayoutConstraint(item: view,
                                                  attribute: .Bottom,
                                                  relatedBy: .Equal,
                                                  toItem: view.superview,
                                                  attribute: .Bottom,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        
        let leadingConstraint = NSLayoutConstraint(item: view,
                                               attribute: .Leading,
                                               relatedBy: .Equal,
                                               toItem: view.superview,
                                               attribute: .Leading,
                                               multiplier: 1.0,
                                               constant: 0.0)
        
        let trailingConstraint = NSLayoutConstraint(item: view,
                                                  attribute: .Trailing,
                                                  relatedBy: .Equal,
                                                  toItem: view.superview,
                                                  attribute: .Trailing,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        
        topConstraint.active = true
        bottomConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
    }
}

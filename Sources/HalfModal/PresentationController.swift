//
//  File.swift
//  
//
//  Created by Vong Nyuksoon on 26/08/2022.
//

import Foundation
import UIKit

// reference: https://stackoverflow.com/a/70360369/10868150
class PresentationController: UIPresentationController {
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var detent: CustomPresentationControllerDetent? = nil
    var onDismiss: (() -> Void)?
    
    private var originalY: CGFloat = 0
    // default value for Full screen modal
    private var yFac = 0.1
    private var heightFac = 0.9
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, detent: CustomPresentationControllerDetent? = nil, onDismiss: @escaping () -> Void) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        
        self.onDismiss = onDismiss
        self.detent = detent ?? .large
        
        let detent = detent
        switch detent {
        case .medium:
            yFac = 0.4
            heightFac = 0.6
        case .large:
            break
        case .none:
            break
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(
            origin: CGPoint(x: 0, y: self.containerView!.frame.height * yFac),
            size: CGSize(
                width: self.containerView!.frame.width,
                height: self.containerView!.frame.height * heightFac)
        )
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        self.containerView?.addGestureRecognizer(viewPan)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.7
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
    
    @objc func dismissController(){
        print("PRESS")
        self.presentedViewController.dismiss(animated: true, completion: nil)
        self.onDismiss?()
    }
    
    @objc private func viewPanned(_ sender: UIPanGestureRecognizer) {
        // how far the pan gesture translated
        let translate = sender.translation(in: self.presentedView)
        let velo = sender.velocity(in: self.presentedView)
        
        switch sender.state {
        case .began:
            originalY = presentedViewController.view.frame.origin.y
        case .changed:
            // move the presentedView according to pan gesture
            // prevent it move too far from bottom
            if originalY + translate.y > originalY {
                presentedViewController.view.frame.origin.y = originalY + translate.y
            }
        case .ended:
            let containerHeight = containerView!.frame.height
            let newY = presentedViewController.view.frame.origin.y
            
            /// if the presentedView move 0.75 of the container's height or user swipe bottom very fast (more than 300),
            /// dimiss the modal,
            /// else bring it back to original position
            if newY >= (containerHeight * 0.75) || velo.y > 300 {
                moveAndDismissPresentedView()
            } else {
                setBackToOriginalPosition()
            }
        default:
            break
        }
    }
    
    private func setBackToOriginalPosition() {
        // ensure no pending layout change in presentedView
        presentedViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.presentedViewController.view.frame.origin.y = self.originalY
            self.presentedViewController.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func moveAndDismissPresentedView() {
        // ensure no pending layout change in presentedView
        presentedViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.presentedViewController.view.frame.origin.y = self.presentedViewController.view.frame.origin.y +  self.presentedViewController.view.frame.height
            self.presentedViewController.view.layoutIfNeeded()
        }, completion: { _ in
            // dimiss when the view is completely move outside the screen
            self.dismissController()
        })
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

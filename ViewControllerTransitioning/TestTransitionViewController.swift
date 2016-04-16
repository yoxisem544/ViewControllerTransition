//
//  TestTransitionViewController.swift
//  ViewControllerTransitioning
//
//  Created by David on 2016/4/16.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

class TransitionDelegate: UIPercentDrivenInteractiveTransition {
	private var isPresenting = false
	var presentingDuration = 1.0
	var dismissDuration = 0.3
	private var isInteractive = false
	
	
}


extension TransitionDelegate : UIViewControllerTransitioningDelegate {
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
	
	func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return isInteractive ? self : nil
	}
	
	func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return isInteractive ? self : nil
	}
}

extension TransitionDelegate : UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		if isPresenting {
			return presentingDuration
		} else {
			return dismissDuration
		}
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		// initialize
		let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		let containerView = transitionContext.containerView()!
		
		let animationDuration = self.transitionDuration(transitionContext)
		
		// initial state
		if isPresenting {
			// take a snapshot of the detail viewcontroller so we can do whatever with it (cause it's only a view), and don't have to care about breaking constraints
			let snapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
			snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
			snapshotView.center = fromViewController.view.center
			containerView.addSubview(snapshotView)
			
			// hide the detail view until snapshot is being animated
			toViewController.view.alpha = 0.0
			containerView.addSubview(toViewController.view)
			
			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: [], animations: {
				snapshotView.transform = CGAffineTransformIdentity
				}, completion: { (finished) in
					snapshotView.removeFromSuperview()
					toViewController.view.alpha = 1.0
					transitionContext.completeTransition(finished)
			})
		} else {
			let snapshotView = fromViewController.view.resizableSnapshotViewFromRect(fromViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
			snapshotView.center = toViewController.view.center
			containerView.addSubview(snapshotView)
			
			fromViewController.view.alpha = 0.0
			
			let toViewControllerSnapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
			containerView.insertSubview(toViewControllerSnapshotView, belowSubview: snapshotView)
			
			UIView.animateWithDuration(animationDuration, animations: {
				snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
				snapshotView.alpha = 0.0
			}) { (finished) in
				toViewControllerSnapshotView.removeFromSuperview()
				snapshotView.removeFromSuperview()
				fromViewController.view.removeFromSuperview()
				transitionContext.completeTransition(finished)
			}
		}
		
		
		// animate
	}
}

class TestTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let presentationAnimator = TestTransitionPresentationAnimator()
		return presentationAnimator
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let da = TestTransitionDismissalAnimator()
		return da
	}
}

class TestTransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.5
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		let containerView = transitionContext.containerView()
		
		let animationDuration = self.transitionDuration(transitionContext)
		
		// take a snapshot of the detail viewcontroller so we can do whatever with it (cause it's only a view), and don't have to care about breaking constraints
		let snapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
		snapshotView.center = fromViewController.view.center
		containerView?.addSubview(snapshotView)
		
		// hide the detail view until snapshot is being animated
		toViewController.view.alpha = 0.0
		containerView?.addSubview(toViewController.view)
		
		UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: [], animations: { 
			snapshotView.transform = CGAffineTransformIdentity
			}, completion: { (finished) in
				snapshotView.removeFromSuperview()
				toViewController.view.alpha = 1.0
				transitionContext.completeTransition(finished)
		})
	}
}

class TestTransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.5
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		let containerView = transitionContext.containerView()
		
		let animationDuration = self.transitionDuration(transitionContext)
		
		let snapshotView = fromViewController.view.resizableSnapshotViewFromRect(fromViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		snapshotView.center = toViewController.view.center
		containerView?.addSubview(snapshotView)
		
		fromViewController.view.alpha = 0.0
		
		let toViewControllerSnapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
		containerView?.insertSubview(toViewControllerSnapshotView, belowSubview: snapshotView)
		
		UIView.animateWithDuration(animationDuration, animations: { 
			snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
			snapshotView.alpha = 0.0
			}) { (finished) in
				toViewControllerSnapshotView.removeFromSuperview()
				snapshotView.removeFromSuperview()
				fromViewController.view.removeFromSuperview()
				transitionContext.completeTransition(finished)
		}
	}
}
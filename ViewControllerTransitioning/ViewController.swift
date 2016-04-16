//
//  ViewController.swift
//  ViewControllerTransitioning
//
//  Created by David on 2016/4/16.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	let viewTransitionDelegate = TransitionDelegate()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
	}
	
	@IBAction func yo() {
		let d = DetailViewController()
		d.imageToDisplay = imageView.image
		d.transitioningDelegate = viewTransitionDelegate
		d.modalPresentationStyle = .Custom
		presentViewController(d, animated: true, completion: nil)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destinationVC = segue.destinationViewController as! DetailViewController
		destinationVC.imageToDisplay = imageView.image
		destinationVC.transitioningDelegate = viewTransitionDelegate
		destinationVC.modalPresentationStyle = .Custom
	}
}


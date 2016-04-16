//
//  DetailViewController.swift
//  ViewControllerTransitioning
//
//  Created by David on 2016/4/16.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
//	@IBOutlet weak var imageView: UIImageView!
	var imageToDisplay: UIImage?
	var imageView: UIImageView!
	@IBAction func dismissView() {
		dismissViewControllerAnimated(true, completion: nil)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
		imageView.center = view.center
		view.addSubview(imageView)
		if let image = imageToDisplay {
			imageView.image = image
		}
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yo)))
		imageView.userInteractionEnabled = true
    }
	
	func yo() {
		print("yo")
		dismissViewControllerAnimated(true, completion: nil)
	}

	

}

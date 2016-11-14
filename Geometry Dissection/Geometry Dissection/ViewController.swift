//
//  ViewController.swift
//  Geometry Dissection
//
//  Created by Hal Mueller on 11/13/16.
//  Copyright © 2016 Hal Mueller. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let scnView = self.view as! SCNView
		scnView.allowsCameraControl = true
		scnView.autoenablesDefaultLighting = true

		// Load the scene from a file
		let scene = SCNScene.primitivesSamples()
		print(scene)
		scnView.scene = scene
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


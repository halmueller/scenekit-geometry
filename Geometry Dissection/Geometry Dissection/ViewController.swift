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

	let debugOptionSets : [SCNDebugOptions] = [[],
	                                           [.showWireframe, .showBoundingBoxes],
	                                           .showWireframe, .showBoundingBoxes,
	                                           ]
	var debugOptionIndex = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		let sceneView = self.view as! SCNView
		sceneView.allowsCameraControl = true
		sceneView.autoenablesDefaultLighting = true
		sceneView.backgroundColor = UIColor.black

		//		sceneView.debugOptions =
		sceneView.debugOptions = debugOptionSets[debugOptionIndex]
		sceneView.showsStatistics = true

		let scene = SCNScene.primitivesSamples()
		print(scene)
		sceneView.scene = scene
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func cycleDebugOptions(_ sender: UITapGestureRecognizer) {
		let sceneView = self.view as! SCNView

		debugOptionIndex += 1
		if debugOptionIndex >= debugOptionSets.count {
			debugOptionIndex = 0
		}

		sceneView.debugOptions = debugOptionSets[debugOptionIndex]
	}

}


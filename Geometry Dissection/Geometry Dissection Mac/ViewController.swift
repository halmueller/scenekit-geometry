//
//  ViewController.swift
//  Geometry Dissection Mac
//
//  Created by Hal Mueller on 11/15/16.
//  Copyright © 2016 Hal Mueller. All rights reserved.
//

import Cocoa
import SceneKit

class ViewController: NSViewController {

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
		sceneView.backgroundColor = NSColor.black

		//		sceneView.debugOptions =
		sceneView.debugOptions = debugOptionSets[debugOptionIndex]
		sceneView.showsStatistics = true

		let scene = SCNScene.primitivesSamples()
		print(scene)
		sceneView.scene = scene
		
	}

	@IBAction func cycleDebugOptions(_ sender: Any) {
		let sceneView = self.view as! SCNView

		debugOptionIndex += 1
		if debugOptionIndex >= debugOptionSets.count {
			debugOptionIndex = 0
		}

		sceneView.debugOptions = debugOptionSets[debugOptionIndex]
	}

}


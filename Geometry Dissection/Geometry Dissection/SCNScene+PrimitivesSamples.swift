//
//  SCNScene+PrimitivesSamples.swift
//  Geometry Dissection
//
//  Created by Hal Mueller on 11/13/16.
//  Copyright © 2016 Hal Mueller. All rights reserved.
//

import Foundation
import SceneKit

extension SCNScene {
	class func primitivesSamples() -> SCNScene {
		let result = SCNScene()

		let rootNode = result.rootNode

		let boxGeom = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
		let boxNode = SCNNode(geometry: boxGeom)
		boxNode.name = "box"
		rootNode.addChildNode(boxNode)

		return result
	}
}

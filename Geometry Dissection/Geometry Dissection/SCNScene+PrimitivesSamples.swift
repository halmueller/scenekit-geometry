//
//  SCNScene+PrimitivesSamples.swift
//  Geometry Dissection
//
//  Created by Hal Mueller on 11/13/16.
//  Copyright © 2016 Hal Mueller. All rights reserved.
//

import Foundation
import SceneKit

#if os(iOS) || os(tvOS)
	private typealias MyColor = UIColor
	private typealias MyFont = UIFont
#elseif os(OSX)
	private typealias MyColor = NSColor
	private typealias MyFont = NSFont
#endif

extension SCNScene {
	class func primitivesSamples() -> SCNScene {
		let result = SCNScene()

		let rootNode = result.rootNode

		let colors = [MyColor.red, MyColor.blue, MyColor.green, MyColor.magenta, MyColor.yellow, MyColor.cyan]
		var materials: [SCNMaterial] = []
		for color in colors {
			let thisMaterial = SCNMaterial()
			thisMaterial.isDoubleSided = true
			thisMaterial.diffuse.contents = color
			thisMaterial.specular.contents = MyColor.white
			materials.append(thisMaterial)
		}

		let objectSize = CGFloat(0.5)
		let carouselRadius = 5 * objectSize
		let quarterObject = objectSize / 4
		let halfObject = objectSize / 2

		let carousel = SCNNode()
		carousel.name = "carousel"
		carousel.position = SCNVector3Make(0, Float(objectSize), 0)

		let capsule = SCNCapsule(capRadius: CGFloat(quarterObject), height: objectSize)
		capsule.name = "capsule"

		let standardSphere = SCNSphere(radius: halfObject)
		standardSphere.isGeodesic = false
		standardSphere.name = "standard sphere"

		let tube = SCNTube(innerRadius: quarterObject, outerRadius: halfObject, height: objectSize)
		tube.name = "tube"

		let geodesicSphere = SCNSphere(radius: objectSize/2)
		geodesicSphere.isGeodesic = true
		geodesicSphere.name = "geodesic sphere"

		let pyramid = SCNPyramid(width: objectSize/3, height: objectSize, length: objectSize/5)
		pyramid.name = "narrow pyramid"

		let pyramid2 = SCNPyramid(width: objectSize/2, height: objectSize, length: objectSize/2)
		pyramid2.name = "pyramid"

		let plane = SCNPlane(width: objectSize, height: objectSize)
		plane.name = "plane"

		let cone1 = SCNCone(topRadius: 0, bottomRadius: objectSize/4, height: objectSize)
		cone1.name = "regular cone"

		let cone2 = SCNCone(topRadius: objectSize/6, bottomRadius: objectSize/3, height: objectSize)
		cone2.name = "truncated cone"

		let sourceString = NSAttributedString(string: "hello", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
		                                                                    NSFontAttributeName: MyFont(name: "Chalkduster", size: 0.5)!])
		let text = SCNText(string: sourceString, extrusionDepth: objectSize/10)
		text.name = "hello string"

		let torus = SCNTorus(ringRadius: objectSize, pipeRadius: objectSize/8)
		torus.name = "torus"

		let cylinder = SCNCylinder(radius: objectSize/4, height: objectSize)
		cylinder.name = "cylinder"

		let chamferedBox = SCNBox(width: objectSize, height: objectSize, length: objectSize/2, chamferRadius: 0.2)
		chamferedBox.name = "chamfered box"

		let box = SCNBox(width: objectSize/2, height: objectSize, length: objectSize, chamferRadius: 0)
		box.name = "regular box"

		let geometries = [capsule, standardSphere, tube, geodesicSphere, pyramid, pyramid2, text, plane, cone1, cone2, torus, cylinder, box, chamferedBox]

		let pointCloudMaterial = SCNMaterial()
		pointCloudMaterial.isDoubleSided = true
		pointCloudMaterial.diffuse.contents = MyColor.magenta
		pointCloudMaterial.specular.contents = MyColor.white

		var index = 0
		let angleIncrement = 2.0 * M_PI/Double(geometries.count)

		for geometry in geometries {
			geometry.materials = materials
			let node = SCNNode(geometry: geometry)
			node.name = geometry.name
			let angle = CGFloat(angleIncrement * Double(index))
			let x = carouselRadius * cos(angle)
			let y = carouselRadius * sin(angle)
			node.position = SCNVector3Make(Float(x), 0, Float(y))
			node.eulerAngles.y = Float(-1.0 * angle)
			carousel.addChildNode(node)
			if let verticesNode = node.vertices() {
				carousel.addChildNode(verticesNode)
				verticesNode.geometry?.firstMaterial = pointCloudMaterial
				verticesNode.position = SCNVector3Make(Float(x), Float(objectSize * 2), Float(y))
				verticesNode.eulerAngles = node.eulerAngles
			}
			index += 1
		}

		//let finalCarousel = carousel.flattenedClone()
		let finalCarousel = carousel
		
		let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0.0, y: CGFloat(M_PI), z: 0, duration: 20.0))
		finalCarousel.runAction(rotate)
		rootNode.addChildNode(finalCarousel)

		return result
	}
}

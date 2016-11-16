//
//  SCNNode+NodeComponents.m
//  Primitives Fun
//
//  Created by Hal Mueller on 11/6/16.
//  Copyright © 2016 Hal Mueller. All rights reserved.
//

#import "SCNNode+NodeComponents.h"
#import <GLKit/GLKMath.h>

#if TARGET_OS_IPHONE
#define NSColor UIColor
#endif

@implementation SCNNode (NodeComponents)
- (nullable SCNNode *)verticesNode;
{
	// David  Rönnqvist
	// http://stackoverflow.com/questions/17250501/extracting-vertices-from-scenekit?rq=1

	SCNGeometry *geometry = self.geometry;

	// Get the vertex sources
	NSArray *vertexSources = [geometry geometrySourcesForSemantic:SCNGeometrySourceSemanticVertex];

	/* Apple Doc: "The vertex, normal, and color semantics each refer to at most one source. A geometry may have multiple sources for the SCNGeometrySourceSemanticTexcoord semantic." */
	SCNGeometrySource *vertexSource = vertexSources[0];

	NSInteger stride = vertexSource.dataStride; // in bytes
	NSInteger offset = vertexSource.dataOffset; // in bytes

	NSInteger componentsPerVector = vertexSource.componentsPerVector;
	NSInteger bytesPerVector = componentsPerVector * vertexSource.bytesPerComponent;
	NSInteger vertexCount = vertexSource.vectorCount;

	SCNVector3 vertices[vertexCount]; // A new array for vertices
	int indices[vertexCount];

	NSLog(@"%@ %zd vertices", self.name, vertexCount);

	// for each vector, read the bytes
	for (int i=0; i < vertexCount; i++) {

		// Assuming that bytes per component is 4 (a float)
		// If it was 8 then it would be a double (aka CGFloat)
		float vectorData[componentsPerVector];

		// The range of bytes for this vector
		NSRange byteRange = NSMakeRange(i*stride + offset, // Start at current stride + offset
										bytesPerVector);   // and read the length of one vector

		// Read into the vector data buffer
		[vertexSource.data getBytes:&vectorData range:byteRange];

		// At this point you can read the data from the float array
		float x = vectorData[0];
		float y = vectorData[1];
		float z = vectorData[2];

		// ... Maybe even save it as an SCNVector3 for later use ...
		vertices[i] = SCNVector3Make(x, y, z);
		indices[i] = i;

		// ... or just log it
		//NSLog(@"%f %f %f", x, y, z);
	}

	NSData *vertexData = [NSData dataWithBytes:indices length:vertexCount * sizeof(int)];
	SCNGeometryElement *vertexElement = [SCNGeometryElement geometryElementWithData:vertexData
																	  primitiveType:SCNGeometryPrimitiveTypePoint
																	 primitiveCount:vertexCount
																	  bytesPerIndex:sizeof(int)];
	SCNGeometrySource *verticesSource = [SCNGeometrySource geometrySourceWithVertices:vertices count:vertexCount];
	SCNGeometry *verticesGeometry = [SCNGeometry geometryWithSources:@[verticesSource] elements:@[vertexElement]];
	SCNNode *resultNode = [SCNNode nodeWithGeometry:verticesGeometry];
	return resultNode;
}

- (nullable SCNNode *)wireframeNode;
{
	// David  Rönnqvist
	// http://stackoverflow.com/questions/17250501/extracting-vertices-from-scenekit?rq=1

	SCNGeometry *geometry = self.geometry;

	// Get the vertex source
	NSArray *vertexSources = [geometry geometrySourcesForSemantic:SCNGeometrySourceSemanticVertex];
	/* Apple Doc: "The vertex, normal, and color semantics each refer to at most one source. A geometry may have multiple sources for the SCNGeometrySourceSemanticTexcoord semantic." */
	SCNGeometrySource *vertexSource = vertexSources[0]; // There is only one vertex source

	NSInteger vertexStride = vertexSource.dataStride; // in bytes
	NSInteger vertexOffset = vertexSource.dataOffset; // in bytes

	NSInteger vertexSourceBytesPerVector = vertexSource.componentsPerVector * vertexSource.bytesPerComponent;
	NSInteger vertexCount = vertexSource.vectorCount;

	SCNVector3 vertices[vertexCount]; // A new array for vertices
	int vertexIndices[vertexCount];

	NSLog(@"\n\n%@ %zd vertices", self.name, vertexCount);

	// for each vector, read the bytes
	for (int i=0; i < vertexCount; i++) {

		// Assuming that bytes per component is 4 (a float)
		// If it was 8 then it would be a double (aka CGFloat)
		float vectorData[vertexSource.componentsPerVector];

		// The range of bytes for this vector
		NSRange byteRange = NSMakeRange(i*vertexStride + vertexOffset, // Start at current stride + offset
										vertexSourceBytesPerVector);   // and read the length of one vector

		// Read into the vector data buffer
		[vertexSource.data getBytes:&vectorData range:byteRange];

		// At this point you can read the data from the float array
		float x = vectorData[0];
		float y = vectorData[1];
		float z = vectorData[2];

		// ... Maybe even save it as an SCNVector3 for later use ...
		vertices[i] = SCNVector3Make(x, y, z);
		vertexIndices[i] = i;

		// ... or just log it
		//NSLog(@"%f %f %f", x, y, z);
	}

	for (SCNGeometryElement *element in geometry.geometryElements) {
		NSLog(@"%@ primitiveCount %zd primitiveType %zd", element, element.primitiveCount, element.primitiveType);
		NSLog(@"%zd bytesPerIndex", element.bytesPerIndex);
		NSLog(@"data length : %zd", element.data.length);


		// The range of bytes for this vector
//		NSRange byteRange = NSMakeRange(0,
//										element.primitiveCount * element.bytesPerIndex);   // and read the length of one vector
//
//		UInt16 elementIndices[element.primitiveCount];
//		[element.data getBytes:&elementIndices range:byteRange];
//
//		NSLog(@"byteRange location %zd length %zd", byteRange.location, byteRange.length);

		// from http://stackoverflow.com/questions/29562618/scenekit-extraire-data-from-scngeometryelement
		// (assumes Triangles)
		if (element.primitiveCount == SCNGeometryPrimitiveTypeTriangles) {
			NSInteger bytesPerPrimitive = element.bytesPerIndex * 3;
			for (int indexPrimitive = 0; indexPrimitive < element.primitiveCount; indexPrimitive++) {
				UInt16 array[3];
				memset(array, 0, 3);

				NSRange elementByteRange = NSMakeRange(indexPrimitive * bytesPerPrimitive, bytesPerPrimitive);
				NSLog(@"elementByteRange location %zd length %zd", elementByteRange.location, elementByteRange.length);
				[element.data getBytes:&array range:elementByteRange];

				NSLog(@"element %zd: %zd %zd %zd", indexPrimitive, array[0], array[1], array[2]);
			}
		}

	}

	NSData *vertexData = [NSData dataWithBytes:vertexIndices length:vertexCount * sizeof(int)];
	SCNGeometryElement *vertexElement = [SCNGeometryElement geometryElementWithData:vertexData
																	  primitiveType:SCNGeometryPrimitiveTypePoint
																	 primitiveCount:vertexCount
																	  bytesPerIndex:sizeof(int)];
	SCNGeometrySource *verticesSource = [SCNGeometrySource geometrySourceWithVertices:vertices count:vertexCount];
	SCNGeometry *verticesGeometry = [SCNGeometry geometryWithSources:@[verticesSource] elements:@[vertexElement]];
	SCNNode *resultNode = [SCNNode nodeWithGeometry:verticesGeometry];
	return resultNode;
}

// from WWDC 2014 SceneKit sample code
// AAPLSlideGeometry.m
- (void)buildVisualizationsPositionsNode:(SCNNode * __strong *)verticesNode normalsNode:(SCNNode * __strong *)normalsNode
{
	// A material that will prevent the nodes from being lit
	SCNMaterial *noLightingMaterial = [SCNMaterial material];
	noLightingMaterial.lightingModelName = SCNLightingModelConstant;

	SCNMaterial *normalMaterial = [SCNMaterial material];
	normalMaterial.lightingModelName = SCNLightingModelConstant;
	normalMaterial.diffuse.contents = [NSColor redColor];

	// Create nodes to represent the vertex and normals
	SCNNode *positionVisualizationNode = [SCNNode node];
	SCNNode *normalsVisualizationNode = [SCNNode node];

	// Retrieve the vertices and normals from the model
	SCNGeometrySource *positionSource = [self.geometry geometrySourcesForSemantic:SCNGeometrySourceSemanticVertex][0];
	SCNGeometrySource *normalSource = [self.geometry geometrySourcesForSemantic:SCNGeometrySourceSemanticNormal][0];

	// Get vertex and normal bytes
	float *vertexBuffer = (float *)positionSource.data.bytes;
	float *normalBuffer = (float *)normalSource.data.bytes;

	NSInteger stride = [positionSource dataStride] / sizeof(float);
	NSInteger normalOffset = [normalSource dataOffset] / sizeof(float);

	// Iterate and create geometries to represent the positions and normals
	for (NSUInteger i = 0; i < positionSource.vectorCount; i++) {
		// One new node per normal/vertex
		SCNNode *vertexNode = [SCNNode node];
		SCNNode *normalNode = [SCNNode node];

		// Attach one sphere per vertex
		SCNSphere *sphere = [SCNSphere sphereWithRadius:0.5];
		sphere.geodesic = YES;
		sphere.segmentCount = 0; // use a small segment count for better performances
		sphere.firstMaterial = noLightingMaterial;
		vertexNode.geometry = sphere;

		// And one pyramid per normal
		SCNPyramid *pyramid = [SCNPyramid pyramidWithWidth:0.1 height:0.1 length:8];
		pyramid.firstMaterial = normalMaterial;
		normalNode.geometry = pyramid;

		// Place the position node
		vertexNode.position = SCNVector3Make(vertexBuffer[i * stride], vertexBuffer[i * stride + 1], vertexBuffer[i * stride + 2]);

		// Place the normal node
		normalNode.position = vertexNode.position;

		// Orientate the normal
		GLKVector3 up = GLKVector3Make(0, 0, 1);
		GLKVector3 normalVec = GLKVector3Make(normalBuffer[i * stride+normalOffset], normalBuffer[i * stride + 1+normalOffset], normalBuffer[i * stride + 2+normalOffset]);
		GLKVector3 axis = GLKVector3Normalize(GLKVector3CrossProduct(up, normalVec));
		float dotProduct = GLKVector3DotProduct(up, normalVec);
		normalNode.rotation = SCNVector4Make(axis.x, axis.y, axis.z, acos(dotProduct));

		// Add the nodes to their parent
		[positionVisualizationNode addChildNode:vertexNode];
		[normalsVisualizationNode addChildNode:normalNode];
	}

	// We must flush the transaction in order to make sure that the parametric geometries (sphere and pyramid)
	// are up-to-date before flattening the nodes
	[SCNTransaction flush];

	// Flatten the visualization nodes so that they can be rendered with 1 draw call
	*verticesNode = [positionVisualizationNode flattenedClone];
	*normalsNode = [normalsVisualizationNode flattenedClone];
}


@end

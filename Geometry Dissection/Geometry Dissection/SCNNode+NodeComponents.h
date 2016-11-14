//
//  SCNNode+NodeComponents.h
//  Primitives Fun
//
//  Created by Hal Mueller on 11/6/16.
//  Copyright © 2016 Hal Mueller. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface SCNNode (NodeComponents)
- (nullable SCNNode *)verticesNode;
NS_ASSUME_NONNULL_BEGIN
- (void)buildVisualizationsPositionsNode:(SCNNode * __strong *)verticesNode normalsNode:(SCNNode * __strong *)normalsNode;
NS_ASSUME_NONNULL_END

@end

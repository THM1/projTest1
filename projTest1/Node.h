//
//  Node.h
//  projTest
//
//  Created by THM on 5/17/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graphics.h"
#import "Point.h"

#define TETRA_1    0.0,    0.0,    1.0
#define TETRA_2  0.943,    0.0, -0.333
#define TETRA_3 -0.471,  0.816, -0.333
#define TETRA_4 -0.471, -0.816, -0.333

#define PI 3.14159265359

/* order of vertices when drawing a tetrahedron using GL_TRIANGLE_STRIP */
static const GLfloat tetraVertices[] = {
    TETRA_3, TETRA_2, TETRA_4, TETRA_1, TETRA_3, TETRA_2,
};

#define RED 255, 0, 0, 255

/* colour of vertices on the tetrahedron (all red) */
static const GLubyte tetraColour[] = {
    RED, RED, RED, RED, RED, RED
};

@interface Node : NSObject <Graphics, Point>{
@private
    float _point[3];
    float _transformedPoint[3];
    
    CGPoint screenLocation;
    
    float _col[4];
    float _radSize;
    
    BOOL _closestNodeToTouch;
    
    GLfloat _nodeLinkData[300];
}

-(Node *) initPoint: (float *) pt colour: (float *) col size: (float) size;
-(void) setLinks: (Node *) _nodes;
-(BOOL) detectSelectedWithZVal:(float)zVal withAngle:(float)theta andDeltaXAndDeltaY:(int *)deltaXY andPixels:(int *)pixelsXY;
-(void)setClosestTouchedNode:(BOOL)set;
-(BOOL)isClosestTouchedNode;


@end
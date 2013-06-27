//
//  Sphere.h
//  projTest1
//
//  Created by THM on 6/9/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>


#define PI 3.14159265359
// create sphere with radius one
// store points in a vertex array with position and normals to be drawn using glDrawArrays

typedef struct
{
    GLfloat pos_x, pos_y, pos_z;
    GLfloat norm_x, norm_y, norm_z;
} sphereVertex ;

@interface Sphere : NSObject{
    GLuint _numRows, _pointsPerRow;
}

-(Sphere *)initWithRows: (GLuint)nRows andPointsPerRow: (GLuint)pointsPerRow;
-(void) createSphere: (sphereVertex *)vertexArray withRows: (GLuint)nRows andPointsPerRow: (GLuint)nPoints;
-(void) calculateIndices: (GLuint *)indexArray withVertices: (sphereVertex *)vertexArray;

@end

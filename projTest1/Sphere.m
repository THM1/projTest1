//
//  Sphere.m
//  projTest1
//
//  Created by THM on 6/9/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "Sphere.h"

@implementation Sphere

-(Sphere *)initWithRows: (GLuint)nRows andPointsPerRow: (GLuint)pointsPerRow
{
    self = [super init];
    
    if(self)
        [self setRows:nRows andPointsPerRow:pointsPerRow];
    
    return self;
}


// obtain the indices for GL_TRIANGLES of a given sphere vertex array
-(void) calculateIndices: (GLuint *)indexArray withVertices: (sphereVertex *)vertexArray
{

    int index = 0;
    
    // calculate the indices of the vertices that will form the triangles of the sphere
    for(int i=0; i<(_numRows-3); i++){
        
        for(int j=0; j<_pointsPerRow-1; j++){
            
            indexArray[index++] = i*_pointsPerRow + j;
            indexArray[index++] = i*_pointsPerRow + j+1;
            indexArray[index++] = (i+1)*_pointsPerRow + j;
            
            indexArray[index++] = i*_pointsPerRow + j+1;
            indexArray[index++] = (i+1)*_pointsPerRow + j+1;
            indexArray[index++] = (i+1)*_pointsPerRow + j;
        }
        
        indexArray[index++] = i*_pointsPerRow + _pointsPerRow-1;
        indexArray[index++] = i*_pointsPerRow;
        indexArray[index++] = (i+1)*_pointsPerRow + _pointsPerRow-1;
        
        indexArray[index++] = (i+1)*_pointsPerRow;
        indexArray[index++] = (i)*_pointsPerRow;
        indexArray[index++] = (i+1)*_pointsPerRow + _pointsPerRow-1;
    }
    
    // triangles of the top and bottom point of sphere
    
    for(int i=0; i<_pointsPerRow-1; i++){
        indexArray[index++] = i;
        indexArray[index++] = i+1;
        indexArray[index++] = _pointsPerRow*(_numRows-2);
    }
    
    indexArray[index++] = _pointsPerRow-1;
    indexArray[index++] = 0;
    indexArray[index++] = _pointsPerRow*(_numRows-2);
    
    
    for(int i=0; i<_pointsPerRow-1; i++){
        indexArray[index++] = (_numRows-3)*_pointsPerRow + i;
        indexArray[index++] = (_numRows-3)*_pointsPerRow + i+1;
        indexArray[index++] = (_numRows-2)*_pointsPerRow + 1;
    }
    
    indexArray[index++] = (_numRows-3)*_pointsPerRow + _pointsPerRow-1;
    indexArray[index++] = (_numRows-3)*_pointsPerRow;
    indexArray[index++] = (_numRows-2)*_pointsPerRow + 1;
}

-(void) calculatePoints: (sphereVertex *)vertArray withRows: (GLuint)numRows andPointsPerRow: (GLuint)pointsPerRow
{
    //GLuint numRows = 16;
    //GLuint pointsPerRow = 16;
    
    //GLuint numVertices = (_numRows-2) * _pointsPerRow + 2; // top and bottom rows are two points
    
    GLfloat x, y, z;
    double r;
    
    // calculate circles of varying radii with pointsPerRow points in each circle
    // top and bottom of sphere will be only points, so go up to numRows-2
    for(int i=0; i<_numRows-2; i++){
        
        for(int j=0; j<_pointsPerRow; j++){
            
            y = 1.0f - ((float)(i+1) / (float)(_numRows-1)) * 2.0f;  // radius = 1, diameter = 2
            r = sin(acos(y));   // radius of the row
            
            x = r * sin((float)j/(float)(_pointsPerRow) * 2.0f * PI);
            z = r * cos((float)j/(float)(_pointsPerRow) * 2.0f * PI);

            // vertex (x,y,z) position
            vertArray[i*_pointsPerRow + j].pos_x = x;
            vertArray[i*_pointsPerRow + j].pos_y = y;
            vertArray[i*_pointsPerRow + j].pos_z = z;
            
            // centre of sphere C is (0,0,0) - normal vector at any point P is normalise(P-C) = normalise(P)
            // since x^2 + y^2 + z^2 = r^2 and the radius is 1, then the normal vector is already normalised
            //double modulus = sqrt(pow(x,2) + pow(y,2) + pow(z,2));
            
            // normalised normal vector at this vertex
            vertArray[i*_pointsPerRow + j].norm_x = x;
            vertArray[i*_pointsPerRow + j].norm_y = y;
            vertArray[i*_pointsPerRow + j].norm_z = z;

        }
    }
    
    // top and bottom vertices values (position and normal):
    vertArray[(_numRows-2) * _pointsPerRow].pos_x = 0.0f;
    vertArray[(_numRows-2) * _pointsPerRow].pos_y = 1.0f;
    vertArray[(_numRows-2) * _pointsPerRow].pos_z = 0.0f;
    vertArray[(_numRows-2) * _pointsPerRow].norm_x = 0.0f;
    vertArray[(_numRows-2) * _pointsPerRow].norm_y = 1.0f;
    vertArray[(_numRows-2) * _pointsPerRow].norm_z = 0.0f;
    
    vertArray[(_numRows-2) * _pointsPerRow + 1].pos_x = 0.0f;
    vertArray[(_numRows-2) * _pointsPerRow + 1].pos_y = -1.0f;
    vertArray[(_numRows-2) * _pointsPerRow + 1].pos_z = 0.0f;
    vertArray[(_numRows-2) * _pointsPerRow + 1].norm_x = 0.0f;
    vertArray[(_numRows-2) * _pointsPerRow + 1].norm_y = -1.0f;
    vertArray[(_numRows-2) * _pointsPerRow + 1].norm_z = 0.0f;
    
}

-(void) setRows: (GLuint)nRows andPointsPerRow: (GLuint)pointsPerRow
{
    _numRows = nRows;
    _pointsPerRow = pointsPerRow;
}


-(void) createSphere: (sphereVertex *)vertexArray withRows: (GLuint)nRows andPointsPerRow: (GLuint)nPoints
{
    [self calculatePoints:vertexArray withRows:nRows andPointsPerRow:nPoints];
}

@end

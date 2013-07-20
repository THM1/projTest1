//
//  Node.m
//  projTest
//
//  Created by THM on 5/17/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "Node.h"

@implementation Node

-(Node *) initPoint: (float *) pt colour: (float *) col size: (float) size{
    self = [super init];
    
    if(self){
        [self setPoint: pt];
        [self setTransformedPoint: pt];
        [self setColour: col];
        [self setSize: size];
    }
    
    return self;
}


-(void) draw: (GLuint *)vertexArray withIndices: (GLuint *)indexArray withModelView:(GLKMatrix4 *)modelView withNormal:(GLKMatrix3 *)normal withProgram:(GLuint *)program
{
    /*
    GLuint UNIFORM_MODELVIEW_MATRIX = 0, UNIFORM_NORMAL_MATRIX = 1;
    glBindVertexArrayOES(*vertexArray);
    
    glUseProgram(*program);
    
    glUniformMatrix4fv(UNIFORM_MODELVIEW_MATRIX, 1, 0, modelView->m);
    glUniformMatrix3fv(UNIFORM_NORMAL_MATRIX, 1, 0, normal->m);

    glDrawElements(GL_TRIANGLES, sizeof(indexArray)/sizeof(indexArray[0]), GL_UNSIGNED_INT, indexArray);
    */
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    //glDrawArrays(GL_LINES, 0, 36);
    //glDrawArrays(GL_POINTS, 0, 226);
}

-(void) drawLinks:(GLuint *)linkArray
{
    glDrawArrays(GL_LINES, 0, 2);
}

-(void) redraw{}

-(void) deleteObj{}

-(void) selectObj{}

-(void) setPoint: (float *) pt{
    _point[0] = pt[0];
    _point[1] = pt[1];
    _point[2] = pt[2];
}

-(void) setTransformedPoint:(float *)pt
{
    for(int i=0; i<3; i++)
        _transformedPoint[i] = pt[i];
    
    //NSLog(@"%f   %f", _transformedPoint[0], _transformedPoint[1]);
}

-(void) setSize: (float) size{
    _radSize = size;
}

-(void) setColour: (float *) colour{
    _col[0] = colour[0];
    _col[1] = colour[1];
    _col[2] = colour[2];
    _col[3] = colour[3];
}

-(void) getPoint: (float *) pt
{
    for(int i=0; i<3; i++)
        pt[i] = _point[i];
}

-(void) getTransformedPoint:(float *)pt
{
    for(int i=0; i<3; i++)
        pt[i] = _transformedPoint[i];
}

-(void) getColour:(float *)col
{
    for(int i=0; i<4; i++){
        
        //if(_closestNodeToTouch) col[i] = 1.0f - _col[i];    // alpha should always be one. selected node is different colour
        col[i] = _col[i];
    }
}

-(void) calculateModelView:(GLKMatrix4 *)modelView andNormal:(GLKMatrix3 *)normal withBase:(GLKMatrix4 *)baseModelView andProjection:(GLKMatrix4 *)projection andRotation:(float *)rotation andTranslation:(float *)translation
{    
    float transformedPoint[3];
    
    // obtain position of point after translation
    transformedPoint[0] = _point[0];// + translation[0];
    transformedPoint[1] = _point[1];// + translation[1];
    transformedPoint[2] = _point[2];// + translation[2];
    
    
    // first recalculate x and z positions when rotating around y axis (trigonometry)
    double r = sqrt(pow(transformedPoint[0],2) + pow(transformedPoint[2],2));
    double theta = atan(transformedPoint[2]/transformedPoint[0]);
    
    // add the rotation about y
    double phi = theta + rotation[0];
    if(phi > PI/2) phi -= PI;
    
    if(phi*theta < 0){      // changed quadrant - manipulate calculations for correct x,z vals
        
        // quad 1 to 2, x to -x
        if(transformedPoint[0]>0 && transformedPoint[2]>0) transformedPoint[0] = -transformedPoint[0];
        // quad 2 to 3, z to -z
        if(transformedPoint[0]<0 && transformedPoint[2]>0) transformedPoint[2] = -transformedPoint[2];
        // quad 3 to 4, -x to x
        if(transformedPoint[0]<0 && transformedPoint[2]<0) transformedPoint[0] = -transformedPoint[0];
        // quad 4 to 1, -z to z
        if(transformedPoint[0]>0 && transformedPoint[2]<0) transformedPoint[2] = -transformedPoint[2];
    }
    
    if(phi < 0){     // if phi is negative then: one of x,z is positive, one is negative
        
        if(transformedPoint[0]<0){
            transformedPoint[0] = -r*cos(phi);  // negative
            transformedPoint[2] = -r*sin(phi);  // positive
        }
        
        else{
            transformedPoint[0] = r*cos(phi);   // positive
            transformedPoint[2] = r*sin(phi);   // negative
        }
    }
    
    else{           // if phi is positive then: either both x,z positive, or both negative
        
        if(transformedPoint[0]<0) {
            transformedPoint[0] = -r*cos(phi);  // negative
            transformedPoint[2] = -r*sin(phi);  // negative
        }
        
        else{
            transformedPoint[0] = r*cos(phi);   // positive
            transformedPoint[2] = r*sin(phi);   // positive
        }
    }
    
    // now do the same for rotation about x axis - calculate y and z positions
    r = sqrt(pow(transformedPoint[1],2) + pow(transformedPoint[2],2));
    theta = atan(transformedPoint[2]/transformedPoint[1]);
    phi = theta + rotation[1];
    
    if(phi > PI/2) phi -= PI;
    
    if(phi*theta < 0){      // changed quadrant - manipulate calculations for correct x,z vals
        
        // quad 1 to 2, x to -x
        if(transformedPoint[1]>0 && transformedPoint[2]>0) transformedPoint[1] = -transformedPoint[1];
        // quad 2 to 3, z to -z
        if(transformedPoint[1]<0 && transformedPoint[2]>0) transformedPoint[2] = -transformedPoint[2];
        // quad 3 to 4, -x to x
        if(transformedPoint[1]<0 && transformedPoint[2]<0) transformedPoint[1] = -transformedPoint[1];
        // quad 4 to 1, -z to z
        if(transformedPoint[1]>0 && transformedPoint[2]<0) transformedPoint[2] = -transformedPoint[2];
    }
    
    if(phi < 0){     // if phi is negative then: one of x,z is positive, one is negative
        
        if(transformedPoint[1]<0){
            transformedPoint[1] = -r*cos(phi);  // negative
            transformedPoint[2] = -r*sin(phi);  // positive
        }
        
        else{
            transformedPoint[1] = r*cos(phi);   // positive
            transformedPoint[2] = r*sin(phi);   // negative
        }
    }
    
    else{           // if phi is positive then: either both x,z positive, or both negative
        
        if(transformedPoint[1]<0) {
            transformedPoint[1] = -r*cos(phi);  // negative
            transformedPoint[2] = -r*sin(phi);  // negative
        }
        
        else{
            transformedPoint[1] = r*cos(phi);   // positive
            transformedPoint[2] = r*sin(phi);   // positive
        }
    }
    
    for(int i=0; i<3; i++)
        transformedPoint[i] += translation[i];
    
    [self setTransformedPoint:transformedPoint];
    
    // then translate modelView matrix by the modified position of the node
    *modelView = GLKMatrix4Identity;
    *modelView = GLKMatrix4MakeTranslation(transformedPoint[0], transformedPoint[1], transformedPoint[2]);
    //*modelView = GLKMatrix4Rotate(*modelView, *rotation, -1.0f, -2.0f, -1.0f);
    *modelView = GLKMatrix4Scale(*modelView, _radSize, _radSize, _radSize);

    //*baseModelView = GLKMatrix4Rotate(*baseModelView, *rotation, 0.5f, 0.0f, 0.0f);
    
    *modelView = GLKMatrix4Multiply(*baseModelView, *modelView);
    
    *normal = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(*modelView), NULL);
    *modelView = GLKMatrix4Multiply(*projection, *modelView);
}


// function to check if the node is below a given location on the screen, and thus selected
// return false if not selected, and true if selected
-(BOOL) detectSelectedWithZVal:(float)zVal withAngle:(float)theta andDeltaXAndDeltaY:(int *)deltaXY andPixels:(int *)pixelsXY
{
    [self setClosestTouchedNode:FALSE];     // when touched, ensure closest node flag is UNSET
    
    float deltaZ = _transformedPoint[2] + zVal;         // zVal is negative, eye coords are inverted
    if(deltaZ > 0) return false;                        // Object is behind eye view, so cannot be selected
    
    if(deltaZ > -3) return true;                        // Between 0 and 3 z difference from eye to node
                                                        // means node is filling majority of screen. Return true
    float alpha = GLKMathDegreesToRadians(theta/2);
    //float alpha = atanf(screenXY[1]*cos(theta/2) / abs(zVal));  // angle between eye coords and corners of plane @ z=0
    
    // Find max x and y values that can be seen on the screen
    // (symmetrical so +/- x and +/- y are maxima and minima respectively)
    float zPlaneMaxXY[2];
    zPlaneMaxXY[0] = sin(alpha) * deltaZ * -1;                  // x direction, maximum value of x
    zPlaneMaxXY[1] = (zPlaneMaxXY[0]/pixelsXY[0]) * pixelsXY[1];  // max value of y is same proportion as in x direction so divide by aspect ratio
    
    // Is the node (centre of node) in the view? If not return false
    if(_transformedPoint[0] > zPlaneMaxXY[0] || _transformedPoint[0] < -zPlaneMaxXY[0]) return false;
    if(_transformedPoint[1] > zPlaneMaxXY[1] || _transformedPoint[1] < -zPlaneMaxXY[1]) return false;
    
    // Calculate which dx and dy areas the node is in
    int deltaXYOfNode[2];
    deltaXYOfNode[0] = (int)(_transformedPoint[0] + zPlaneMaxXY[0])/(zPlaneMaxXY[0] * 2) * pixelsXY[0];
    deltaXYOfNode[1] = (int)(pixelsXY[1] - ((_transformedPoint[1] + zPlaneMaxXY[1])/(zPlaneMaxXY[1] * 2) * pixelsXY[1]));

    // If it is within ten pixels of the touched point, in both x and y direction, return true
    // i.e. node is underneath the touched position area, and has been selected
    if(abs(deltaXYOfNode[0] - deltaXY[0])<100 && abs(deltaXYOfNode[1] - deltaXY[1])<100) return true;

    // Otherwise node is in view, but has not been selected. R  eturn false
    return false;
    
}

-(float) getSize
{
    return _radSize;
}

-(void) setLinks: (Node *) nodes
{
    for(int i=0; i<50; i++){
        float pt[3];
        //[*nodes[i] getPoint:pt];
        
        // first node in link
        _nodeLinkData[i*6] = pt[0];
        _nodeLinkData[i*6 + 1] = pt[1];
        _nodeLinkData[i*6 + 2] = pt[2];
        
        // second node in link
        _nodeLinkData[i*6 + 3] = _point[0];
        _nodeLinkData[i*6 + 4] = _point[1];
        _nodeLinkData[i*6 + 5] = _point[2];
    }
}

-(void)setClosestTouchedNode:(BOOL)set
{
    // already set as closest node to touch so return
    if(set && _closestNodeToTouch) return;
    
    // set is true, so change from not closest to closest
    // use complimentary colour to represent selected node
    if(set && !_closestNodeToTouch){
        
        _closestNodeToTouch = TRUE;
        
        // invert colour (RBG) - alpha still 1.0f
        for(int i=0; i<3; i++){
            _col[i] = 1.0f - _col[i];
        }
        return;
    }
    
    // set is false, so change from closest node to not closest
    // use original colour for unselected node (invert again)
    if(!set && _closestNodeToTouch){
        
        _closestNodeToTouch = FALSE;
        
        // invert colour (RBG) - alpha unchanged
        for(int i=0; i<3; i++){
            _col[i] = 1.0f - _col[i];
        }
        return;
    }
    
    // otherwise set is false and closest node is false, change nothing and return
    return;
}

-(BOOL)isClosestTouchedNode
{    
    return _closestNodeToTouch;
}


@end








//
//  Node.m
//  projTest
//
//  Created by THM on 5/17/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "Node.h"

@implementation Node

-(Node *) initPoint: (GLfloat *) pt colour: (GLfloat *) _col size: (GLfloat) _size{
    self = [super init];
    
    if(self){
        [self setPoint: pt];
        [self setColour:_col];
        [self setSize: _size];
    }
    
    return self;
}


-(void) draw{
    
    glVertexPointer(3, GL_FLOAT, 0, tetraVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, tetraColour);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glPushMatrix();
    //glLoadIdentity();
    glTranslatef(point[0], point[1], point[2]);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);
    glPopMatrix();
}

-(void) redraw{}

-(void) deleteObj{}

-(void) selectObj{}

-(void) setPoint: (GLfloat *) _pt{
    point[0] = _pt[0];
    point[1] = _pt[1];
    point[2] = _pt[2];
}

-(void) setSize: (GLfloat) _size{
    radSize = _size;
}

-(void) setColour: (GLfloat *) _colour{
    col[0] = _colour[0];
    col[1] = _colour[1];
    col[2] = _colour[2];
    col[3] = _colour[3];
}

@end

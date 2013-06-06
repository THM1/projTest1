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
        [self setColour:col];
        [self setSize: size];
    }
    
    return self;
}


-(void) draw: (GLuint *)_vertexArray withModelView:(GLKMatrix4 *)_modelView withNormal:(GLKMatrix3 *)_normal withProgram:(GLuint *)_program
{
    //GLint UNIFORM_MODELVIEW_MATRIX = 0, UNIFORM_NORMAL_MATRIX = 1;
    
    //glUseProgram(*_program);
    
    //glUniformMatrix4fv(UNIFORM_MODELVIEW_MATRIX, 1, 0, _modelView->m);
    //glUniformMatrix3fv(UNIFORM_NORMAL_MATRIX, 1, 0, _normal->m);

    glDrawArrays(GL_TRIANGLES, 0, 36);
    //glDrawArrays(GL_LINES, 0, 36);

}

-(void) drawLinks:(GLuint *)_linkArray
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
    
    //NSLog(@"%f %f %f \n", _point[0], _point[1], _point[2]);
}

-(void) setSize: (float) size{
    _radSize = size;
}

-(void) setColour: (float *) colour{
    _col[0] = colour[0];
    _col[1] = colour[1];
    _col[2] = colour[2];
    _col[3] = colour[3];
    //NSLog(@"%f %f %f %f\n",_col[0], _col[1], _col[2], _col[3]);
}

-(void) getPoint: (float *) pt
{
    for(int i=0; i<sizeof(_point); i++){
        pt[i] = _point[i];
    }
}

-(void) getColour:(float *)col
{
    for(int i=0; i<sizeof(_col); i++){
        col[i] = _col[i];
    }
}

-(void) calculateModelView:(GLKMatrix4 *)_modelView andNormal:(GLKMatrix3 *)_normal withBase:(GLKMatrix4 *)baseModelView andProjection:(GLKMatrix4 *)projection andRotation:(float *)rotation
{
    *_modelView = GLKMatrix4Identity;
    *_modelView = GLKMatrix4MakeTranslation(_point[0], _point[1], _point[2]);
    //*_modelView = GLKMatrix4Rotate(*_modelView, *rotation, -1.0f, -2.0f, -1.0f);
    *_modelView = GLKMatrix4Scale(*_modelView, _radSize, _radSize, _radSize);
    *_modelView = GLKMatrix4Multiply(*baseModelView, *_modelView);
    
    *_normal = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(*_modelView), NULL);
    *_modelView = GLKMatrix4Multiply(*projection, *_modelView);
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


@end








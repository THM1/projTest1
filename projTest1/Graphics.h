//
//  Graphics.h
//  projTest
//
//  Created by THM on 5/17/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]
#define methodNotImplemented() mustOverride()

@protocol Graphics <NSObject>

-(void) draw: (GLuint *)vertexArray withIndices: (GLuint *)indexArray withModelView:(GLKMatrix4 *)modelView withNormal:(GLKMatrix3 *)normal withProgram:(GLuint *)program;
-(void) drawLinks: (GLuint *) linkArray;
-(void) redraw;
-(void) deleteObj;
-(void) selectObj;
-(void) setColour: (float *) colour;
-(void) setSize: (float) size;
-(void) getColour: (float*) col;
-(void) calculateModelView:(GLKMatrix4 *)modelView andNormal:(GLKMatrix3 *)normal withBase:(GLKMatrix4 *)baseModelView andProjection:(GLKMatrix4 *)projection andRotation:(float *)rotation andTranslation: (float *)translation;
//-(void) detectSelected:(CGPoint)touchLocation withZ:(float)zVal andAngle:(float)theta;
-(float) getSize;

@end

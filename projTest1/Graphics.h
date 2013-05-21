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

-(void) draw;
-(void) redraw;
-(void) deleteObj;
-(void) selectObj;
-(void) setColour: (GLfloat *) _colour;
-(void) setSize: (GLfloat) _size;

@end

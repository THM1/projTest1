//
//  _Point.h
//  projTest
//
//  Created by THM on 5/17/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]
#define methodNotImplemented() mustOverride()

@protocol Point <NSObject>

-(void) setPoint: (float *) pt;
-(void) getPoint: (float *) pt;
-(void) setTransformedPoint: (float *) pt;
-(void) getTransformedPoint: (float *) pt;

@end

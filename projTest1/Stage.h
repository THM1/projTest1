//
//  Stage.h
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stage : NSObject{
    NSString *_name;
    float _pos[3];
}

-(Stage *)initWithName:(NSString *)name andPosition:(float *)pos;
-(void)getPos:(float *)pos;
-(NSString *)getName;

-(CGPoint)getCGPoint;

@end

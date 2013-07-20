//
//  Stage.m
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "Stage.h"

@implementation Stage

-(Stage *)initWithName:(NSString *)name andPosition:(float *)pos
{
    self = [super init];
    
    if(self){
        [self setName:name];
        [self setPos:pos];
    }
    
    return self;
}

-(void)setName:(NSString *)name
{
    //NSString *newName = [[NSString alloc] initWithString:name];
    //_name = newName;
    _name = name;
}

-(void)setPos:(float *)pos
{
    for(int i=0; i<3; i++)
        _pos[i] = pos[i];
}

-(void)getPos:(float *)pos
{
    for(int i=0; i<3; i++)
        pos[i] = _pos[i];
}



@end

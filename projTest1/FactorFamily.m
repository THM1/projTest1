//
//  FactorFamily.m
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "FactorFamily.h"

@implementation FactorFamily

-(FactorFamily *)initWithFactorFamily:(FactorFamily *)factorFamily
{
    self = [super init];
    
    if(self){
        [self setName:[factorFamily getName]];
        [self setBasicInfo:[factorFamily getBasicInfo] andMoreInfo:[factorFamily getMoreInfo]];
    }
    
    return self;
}

-(FactorFamily *)initFactorFamilyName:(NSString *)name withInfo:(NSString *)info andMoreInfo:(NSString *)moreInfo
{
    self = [super init];
    
    if(self){
        [self setName:name];
        [self setBasicInfo:info andMoreInfo:moreInfo];
    }
    
    return self;
}

-(void) setName:(NSString *)name
{
    _name = name;
}

-(void) setBasicInfo:(NSString *)basicInfo andMoreInfo:(NSString *)moreInfo
{
    _basicInfo = basicInfo;
    _evenMoreInfo = moreInfo;
}

-(NSString *) getName
{
    return _name;
}

-(NSString *) getBasicInfo
{
    return _basicInfo;
}
-(NSString *) getMoreInfo
{
    return _evenMoreInfo;
}

@end

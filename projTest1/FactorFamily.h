//
//  FactorFamily.h
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactorFamily : NSObject{
@private
    NSString *_name;
    NSString *_basicInfo;
    NSString *_evenMoreInfo;
}

-(FactorFamily *)initFactorFamilyName:(NSString *)name withInfo:(NSString *)info andMoreInfo:(NSString *)moreInfo;
-(FactorFamily *)initWithFactorFamily:(FactorFamily *)factorFamily;

//-(void) setName:(NSString *)name;
//-(void) setBasicInfo:(NSString *)basicInfo andMoreInfo:(NSString *)moreInfo;

-(NSString *) getName;
-(NSString *) getBasicInfo;
-(NSString *) getMoreInfo;
@end

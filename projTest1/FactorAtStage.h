//
//  FactorAtStage.h
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactorFamily.h"

@interface FactorAtStage : FactorFamily{
@private
    float _pValue;       // colour
    float _oddsRatio;    // font size
}

-(FactorAtStage *) initWithFactorFamily: (FactorFamily *)factorFam andPValue:(float *)pVal andOddsRatio: (float *)oddsRatio;

-(void) setPValue: (float *)pVal;
-(void) setOddsRatio: (float *)oddsRatio;

//-(UIColor *) getColourForPValue: (float *)pVal;
//-(float *) getFontSizeForOddsRatio:(float *)oddsRatio;

-(UIColor *)getColour;
-(float)getFontSize;

-(UILabel *)getLabel;
@end

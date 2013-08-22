//
//  GeneRegulationMap.h
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactorFamily.h"
#import "FactorAtStage.h"
#import "Stage.h"
#import "Link.h"

@interface GeneRegulationMap : NSObject{
@private

    NSMutableArray* _stages;
    NSMutableArray* _links;
    NSMutableDictionary* _stagesList;
    NSMutableDictionary* _linksList;
    NSMutableDictionary* _factors;

}

-(GeneRegulationMap *)init;
-(void)drawGeneMapWithView: (UIView *)view andContext:(EAGLContext *)context;

-(void)registerTouchAtPoint:(CGPoint)touchPos onView:(UIView *)view;
@end

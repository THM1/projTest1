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

@interface GeneRegulationMap : NSObject{
@private

    NSMutableArray* _stages;
    NSMutableArray* _links;
    NSMutableDictionary* _factors;

}

@end

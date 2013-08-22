//
//  GeneRegulationMap.m
//  projTest1
//
//  Created by THM on 7/10/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#define MAX_X 700
#define MAX_Y 800

#import "GeneRegulationMap.h"

@implementation GeneRegulationMap

-(GeneRegulationMap *)init
{
    self = [super init];
    
    if(self){
        [self initialiseVariables];
        [self setupStages];
    }
    
    return self;
}

-(void)initialiseVariables
{
    _stagesList = [[NSMutableDictionary alloc] init];
    _linksList = [[NSMutableDictionary alloc] init];
    _links = [[NSMutableArray alloc] init];
    _stages = [[NSMutableArray alloc] init];
}

-(void)setupStages
{
    // open file with gene regulation map details (nodes and edges)
    NSError *error = nil;
    NSStringEncoding *encoding = nil;
    NSString *filePathName = [[NSBundle mainBundle]pathForResource: @"regulation_graph" ofType:@"plain"];
    NSString *stagesInfo = [[NSString alloc] initWithContentsOfFile:filePathName usedEncoding:encoding error:&error];
    
    // place all words in an ordered list in an array (words are distinguished as being separated by white space characters or new line characters)
    NSArray *stagesInfoWordByWord = [stagesInfo componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // initialise variables
    //_stagesList = [[NSMutableDictionary alloc] init];
    //_linksList = [[NSMutableDictionary alloc] init];
    //_links = [[NSMutableArray alloc] init];
    
    // counter for words in array
    unsigned int i=0;

    // check start of file is correct - should be the word "graph"
    if(![stagesInfoWordByWord[i++] isEqual: @"graph"]){
        // incorrect file opened
        NSLog(@"Incorrect File Type. Could not load gene regulation map");
        exit(1);
    }
    
    // scan next parts of the file for the width and height of the image and calculate scale factor
    // between position in image and position on screen
    i++;
    NSString *nextWord =  [stagesInfoWordByWord objectAtIndexedSubscript:i];
    float width = [nextWord floatValue];
    
    i++;
    nextWord = [stagesInfoWordByWord objectAtIndexedSubscript:i];
    float height = [nextWord floatValue];
    
    // scale to screen size
    float positionScale[2];
    positionScale[0]= MAX_X/width;
    positionScale[1] = MAX_Y/height;
    
    // next line of file
    i++;
    while(i<[stagesInfoWordByWord count]){
        
        nextWord = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
        
        // if end of file leave while loop
        if([nextWord isEqualToString:@"stop"]) break;
        
        // lines starting with the word "node" contain the information for that node (or stage)
        if([nextWord isEqualToString:@"node"]){
            
            // get stage name
            NSString *stageName = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
            
            // get stage position and scale x and y positions to size of screen
            float pos[2];
            pos[0] = [[stagesInfoWordByWord objectAtIndexedSubscript:i++] floatValue] * positionScale[0];
            pos[1] = MAX_Y - [[stagesInfoWordByWord objectAtIndexedSubscript:i++] floatValue] * positionScale[1];
            
            // create stage with above name and position and add to stages array
            Stage *newStage = [[Stage alloc] initWithName:stageName andPosition:pos];
            [_stages addObject:newStage];
            [_stagesList setObject:newStage forKey:stageName];
            // go to end of line (6 extra words for node information not required)
            i+=7;
        }
        
        else if([nextWord isEqualToString:@"edge"]){
            
            // get names of prev and next stage for the edge
            NSString *prevStage = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
            NSString *nextStage = [stagesInfoWordByWord objectAtIndexedSubscript:i++];
            
            /*int *prevIndex=0, *nextIndex=0;
            
            // find the stages with the given names by searching in the stages array
            for(int j=0; j<[_stages count]; j++){
                if(![_stages[j] isEqualToString:prevStage]) *prevIndex=j;
                if(![_stages[j] isEqualToString:nextStage]) *nextIndex=j;
            }

            // create link with above prev and next stages and add to links array
            Link *newLink = [[Link alloc] initWithPrev:[_stages objectAtIndexedSubscript:*prevIndex] andNext:[_stages objectAtIndexedSubscript:*nextIndex]];*/
            
            Link *newLink = [[Link alloc] initWithPrev:[_stagesList objectForKey:prevStage] andNext:[_stagesList objectForKey:nextStage]];
            //Link *newLink = [[Link alloc] initWithPrev:[tempStages objectForKey:prevStage] andNext:[tempStages objectForKey:nextStage]];

            [_links addObject:newLink];
            
            NSString *linkName = [[NSString alloc] initWithFormat:@"%@\t%@",prevStage,nextStage];
            [_linksList setObject:newLink forKey:linkName];
            // go to end of line (11 extra words for node information not required)
            i+=11;
        }
    }
    
    //[stagesInfo dealloc];
    //[stagesInfoWordByWord dealloc];
}

-(void)drawGeneMapWithView:(UIView *)view andContext:(EAGLContext *)context
{
    static int count = 0;
    
    float labelSize[2] = {100, 40};
    
    if(!count){
        //UILabel *label = [[UILabel alloc] init];
        unsigned int stageCount = [_stagesList count];
        unsigned int linksCount = [_linksList count];
        
        for(int i=0; i<stageCount; i++){
            
            Stage *tempStage = [_stages objectAtIndexedSubscript:i];
            float tempPos[3];
            [tempStage getPos:tempPos];
            
            CGRect stageRect = CGRectMake(tempPos[0] - labelSize[0]*0.5,    // label starts at top right but we want tempPos to be the central
                                          tempPos[1] - labelSize[1]*0.5,    // position of the label, so adjust by shifting half labelSize in x & y
                                          labelSize[0],
                                          labelSize[1]);
            
            UILabel *label = [[UILabel alloc] initWithFrame:stageRect];
            //[label setText:[tempStage getName]];
            label.text = [tempStage getName];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            
            [view addSubview:label];
            
            //if(i%2) label.hidden = YES;
        }
         
        for(int i=0; i<linksCount; i++){
            
            Link *tempLink = [_links objectAtIndexedSubscript:i];

            UIImageView *imageView = [tempLink getArrow:view];
            
            [view addSubview:imageView];
        }
    }
    
    count = 1;
}

-(void)registerTouchAtPoint:(CGPoint)touchPos onView:(UIView *)view
{
    NSUInteger count = [_links count];
    
    for(int i=0; i<count; i++){
        
        Link *tempLink = [_links objectAtIndexedSubscript:i];
        BOOL touched = [tempLink checkTouched:touchPos];
        
        if(touched){
            [tempLink displayFactors:view];
            return;
        }
    }
}
@end













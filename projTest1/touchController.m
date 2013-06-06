//
//  touchController.m
//  projTest1
//
//  Created by THM on 5/29/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "touchController.h"

@implementation touchController

-(IBAction)handlePinch:(UIPinchGestureRecognizer *)sender
{
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan: {};
            
        case UIGestureRecognizerStateChanged: {};
            
        case UIGestureRecognizerStateEnded:
        default:{};
    
    }
}

@end

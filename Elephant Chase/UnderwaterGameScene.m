//
//  UnderwaterGameScene.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UnderwaterGameScene.h"

@implementation UnderwaterGameScene

-(id)init {
    if ( self = [super init] ) {
        UnderwaterBackgroundLayer *backgroundLayer = [UnderwaterBackgroundLayer node];
        UnderwaterGameplayLayer *gameplayLayer = [UnderwaterGameplayLayer node];
        
        [self addChild:backgroundLayer z:1];
        [self addChild:gameplayLayer z:5];
    }
    return self;    
}

@end

//
//  UnderwaterGameplayLayer.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "UnderwaterGameplayLayer.h"

@implementation UnderwaterGameplayLayer


-(id) init{
	if( (self=[super init])) {
        screenSize = [[CCDirector sharedDirector] winSize];
     
        self.isTouchEnabled = YES;
        
        hero = [CCSprite spriteWithFile:@"hero.png"];
        [hero setPosition:ccp(screenSize.width/2, screenSize.height*0.17f)];
        [self addChild:hero];
        
        
        
//        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"underwater-background.png"];
//        
//        [backgroundImage setPosition: ccp(screenSize.width/2, screenSize.height/2)];
//        [self addChild:backgroundImage z:0 tag:0];        
	}
	return self;
}


- (void) dealloc{
	[super dealloc];
}

@end

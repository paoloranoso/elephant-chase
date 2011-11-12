//
//  UnderwaterBackgroundLayer.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UnderwaterBackgroundLayer.h"

@implementation UnderwaterBackgroundLayer

-(id) init{
	if( (self=[super init])) {
        background = [CCSprite spriteWithFile:@"underwater-background.png"];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [background setPosition: ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background z:0 tag:0];        
	}
	return self;
}


- (void) dealloc{
	[super dealloc];
}

@end

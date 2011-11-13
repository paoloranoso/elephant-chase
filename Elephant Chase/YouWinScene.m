//
//  YouWinScene.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "YouWinScene.h"

#import "LoadingScene.h"

#import "SimpleAudioEngine.h"

// private methods are declared in this manner to avoid "may not respond to ..." compiler warnings
@interface YouWinScene (PrivateMethods)
-(void) createMenu:(ccTime)delta;
-(void) item1Touched:(id)sender;
-(void) item2Touched:(id)sender;
@end

@implementation YouWinScene
+(id) scene{
	CCScene* scene = [CCScene node];
	CCLayer* layer = [YouWinScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init{
	if ((self = [super init])){		
        
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"you-win.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"menu-item-selected.caf"];
        
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.5; 
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"you-win.caf" loop:YES];
        
        
        //background
        CCSprite *background = [CCSprite spriteWithFile:@"win.png"];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [background setPosition: ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background z:0 tag:0];               
        
        
		// wait a short moment before creating the menu so we can see it scroll in
		[self schedule:@selector(createMenu:) interval:1];
	}
	return self;
}

-(void) createMenu:(ccTime)delta
{
	// unschedule the selector, we only want this method to be called once
	[self unschedule:_cmd];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	// set CCMenuItemFont default properties
	[CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
	[CCMenuItemFont setFontSize:80];
	
	CCMenuItemFont* item1 = [CCMenuItemFont itemFromString:@"\"Help!\" \"Help!\"" target:self selector:@selector(item1Touched:)];
	[CCMenuItemFont setFontSize:50];
	CCMenuItemFont* item2 = [CCMenuItemFont itemFromString:@"Main Menu" target:self selector:@selector(item2Touched:)];
	
	// create the menu using the items
	CCMenu* menu = [CCMenu menuWithItems:item1, item2, nil];
	menu.position = CGPointMake(-(size.width / 2), size.height / 2);
	menu.tag = 100;
	[self addChild:menu];
	
	// calling one of the align methods is important, otherwise all labels will occupy the same location
	[menu alignItemsVerticallyWithPadding:40];
	
	// use an action for a neat initial effect - moving the whole menu at once!
	CCMoveTo* move = [CCMoveTo actionWithDuration:3 position:CGPointMake(size.width / 2, size.height / 2)];
	CCEaseElasticOut* ease = [CCEaseElasticOut actionWithAction:move period:0.8f];
	[menu runAction:ease];
}


-(void)item1Touched:(id)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"elephant-attack.caf"];    
}

-(void)item2Touched:(id)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu-item-selected.caf"];
	LoadingScene* scene = [LoadingScene sceneWithTargetScene:TargetSceneMainMenu];    
    [[CCDirector sharedDirector] replaceScene:scene];
}


-(void) dealloc
{
	CCLOG(@"dealloc: %@", self);
	
	// always call [super dealloc] at the end of every dealloc method
	[super dealloc];
}


@end

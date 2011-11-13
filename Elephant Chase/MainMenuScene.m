//
//  MainMenuScene.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"

#import "LoadingScene.h"

#import "SimpleAudioEngine.h"

// private methods are declared in this manner to avoid "may not respond to ..." compiler warnings
@interface MainMenuScene (PrivateMethods)
-(void) createMenu:(ccTime)delta;
-(void) changeScene:(id)sender;
-(void) goBackToPreviousScene;
-(void) titleButtonTouched:(id)sender;
-(void) playButtonTouched:(id)sender;
-(void) helpButtonTouched:(id)sender;
@end

@implementation MainMenuScene
+(id) scene{
	CCScene* scene = [CCScene node];
	CCLayer* layer = [MainMenuScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init{
	if ((self = [super init])){		
        
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"main-menu.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"menu-item-selected.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"elephant-attack.caf"];
        
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.5; 
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main-menu.caf" loop:YES];
        
        
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
	
	CCMenuItemFont* item1 = [CCMenuItemFont itemFromString:@"\"Don't Feed the Elephants\"" target:self selector:@selector(titleButtonTouched:)];
	[CCMenuItemFont setFontSize:50];
	CCMenuItemFont* item2 = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(playButtonTouched:)];
	CCMenuItemFont* item3 = [CCMenuItemFont itemFromString:@"Help" target:self selector:@selector(helpButtonTouched:)];
	
	// create the menu using the items
	CCMenu* menu = [CCMenu menuWithItems:item1, item2, item3, nil];
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

-(void) goBackToPreviousScene
{
	// get the menu back
	CCNode* node = [self getChildByTag:100];
	NSAssert([node isKindOfClass:[CCMenu class]], @"node is not a CCMenu!");
    
	CCMenu* menu = (CCMenu*)node;
    
	// lets move the menu out using a sequence
	CGSize size = [[CCDirector sharedDirector] winSize];
	CCMoveTo* move = [CCMoveTo actionWithDuration:1 position:CGPointMake(-(size.width / 2), size.height / 2)];
	CCEaseBackInOut* ease = [CCEaseBackInOut actionWithAction:move];
	CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(changeScene:)];
	CCSequence* sequence = [CCSequence actions:ease, func, nil];
	[menu runAction:sequence];
}

-(void) changeScene:(id)sender
{
//	[[CCDirector sharedDirector] replaceScene:[HelloWorld scene]];
}

-(void)titleButtonTouched:(id)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"elephant-attack.caf"];    
}

-(void) playButtonTouched:(id)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu-item-selected.caf"];
}

-(void) helpButtonTouched:(id)sender{
    [[SimpleAudioEngine sharedEngine] playEffect:@"menu-item-selected.caf"];    
}


-(void) dealloc
{
	CCLOG(@"dealloc: %@", self);
	
	// always call [super dealloc] at the end of every dealloc method
	[super dealloc];
}

@end
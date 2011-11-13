//
//  LoadingScene.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingScene.h"

#import "MainMenuScene.h"
#import "HelpScene.h"
#import "UnderwaterGameScene.h"
#import "YouWinScene.h"
#import "YouLoseScene.h"

@interface LoadingScene (PrivateMethods)
-(void) update:(ccTime)delta;
@end

@implementation LoadingScene

+(id) sceneWithTargetScene:(TargetScenes)targetScene;
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	// This creates an autorelease object of self (the current class: LoadingScene)
	return [[[self alloc] initWithTargetScene:targetScene] autorelease];
	
	// Note: this does the exact same, it only replaced self with LoadingScene. The above is much more common.
	//return [[[LoadingScene alloc] initWithTargetScene:targetScene] autorelease];
}

-(id) initWithTargetScene:(TargetScenes)targetScene
{
	if ((self = [super init]))
	{
		targetScene_ = targetScene;
        
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Marker Felt" fontSize:64];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position = CGPointMake(size.width / 2, size.height / 2);
		[self addChild:label];
		
		// Must wait one frame before loading the target scene!
		// Two reasons: first, it would crash if not. Second, the Loading label wouldn't be displayed.
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) update:(ccTime)delta
{
	// It's not strictly necessary, as we're changing the scene anyway. But just to be safe.
	[self unscheduleAllSelectors];
	

	switch (targetScene_)
	{
		case TargetSceneMainMenu:
			[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
			break;
		case TargetSceneHelp:
//			[[CCDirector sharedDirector] replaceScene:[OtherScene scene]];
			break;
		case TargetSceneUnderwaterLevel:
            // Important note: if you create new local variables within a case block, it must be put in brackets.
            // Otherwise you'll receive a compilation error "Expected expression before ..."
		{
			CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:3 scene:[UnderwaterGameScene node] withColor:ccWHITE];
			[[CCDirector sharedDirector] replaceScene:transition];
			break;
		}
		case TargetSceneYouLose:
//			[[CCDirector sharedDirector] replaceScene:[ParallaxScene scene]];
			break;
		case TargetSceneYouWin:
//			[[CCDirector sharedDirector] replaceScene:[ParallaxScene scene]];
			break;
			
		default:
			// Always warn if an unspecified enum value was used. It's a reminder for yourself to update the switch
			// whenever you add more enum values.
			NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene_);
			break;
	}

}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end

//
//  LoadingScene.h
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

typedef enum
{
	TargetSceneINVALID = 0,
	TargetSceneMainMenu,
	TargetSceneHelp,    
	TargetSceneUnderwaterLevel,
	TargetSceneYouLose,
	TargetSceneYouWin,
} TargetScenes;

@interface LoadingScene : CCScene{
	TargetScenes targetScene_;
}

+(id) sceneWithTargetScene:(TargetScenes)targetScene;
-(id) initWithTargetScene:(TargetScenes)targetScene;

@end

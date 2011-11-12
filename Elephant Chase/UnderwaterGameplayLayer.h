//
//  UnderwaterGameplayLayer.h
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "SneakyJoystick.h" //need joystick one for delegate methods
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"

@interface UnderwaterGameplayLayer : CCLayer{
    CCSprite *hero;
    CCSprite *elephant;
    CCSprite *boat;
    CCSprite *bomb;    
    
    SneakyButton *leftButton; 
    SneakyButton *rightButton;    
    
    CGSize screenSize;
}

@end

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
    int boatTimer;
    BOOL boatInMotion;
    
    BOOL bombDroppedFromBoat;
    BOOL bombExploded;
    int bombSpeedMultiplier;    
    
    BOOL isElephantChasing;
    BOOL elephantStomped;    
    BOOL isElephantStomping;

    int elephantSpeedMultiplierX;
    int elephantSpeedMultiplierY;
    int elephantRageMultiplier;
    float heroRageMultiplier;
    
    int heroLife;
    int elephantLife;
    
    
    CCSprite *hero;
    CCSprite *elephant;
    CCSprite *boat;
    CCSprite *bomb;    
    
    SneakyButton *leftButton; 
    SneakyButton *rightButton;    
    
    CCParticleExplosion *particleExplosion;
    
    CGSize screenSize;
}

@end

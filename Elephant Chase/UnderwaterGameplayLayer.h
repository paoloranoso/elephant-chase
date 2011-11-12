//
//  UnderwaterGameplayLayer.h
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface UnderwaterGameplayLayer : CCLayer{
    CCSprite *hero;
    CCSprite *elephant;
    CCSprite *boat;
    CCSprite *bomb;    
    
    CGSize screenSize;
}

@end

//
//  UnderwaterGameplayLayer.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "UnderwaterGameplayLayer.h"

#define kDirectionalButtonLength 64.0f


@interface UnderwaterGameplayLayer(PrivateMethods)
-(void)initDirectionalButtons;
@end

@implementation UnderwaterGameplayLayer


-(id) init{
	if( (self=[super init])) {
        screenSize = [[CCDirector sharedDirector] winSize];
     
        self.isTouchEnabled = YES;
        
        hero = [CCSprite spriteWithFile:@"hero.png"];
        [hero setPosition:ccp(screenSize.width/2, screenSize.height*0.17f)];
        [self addChild:hero];
        
        boat = [CCSprite spriteWithFile:@"boat.png"];
        [boat setPosition:ccp(-5.0f, screenSize.height*0.95f)];
        [self addChild:boat];
        
        
        //TESTING
        bomb = [CCSprite spriteWithFile:@"bomb.png"];
        [bomb setPosition:ccp(50.0f, screenSize.height*0.65f)];
        [self addChild:bomb];
        
        
        //TODO: more sprite adding here for elephant, boat, bomb
    
        
        [self initDirectionalButtons];
        
        [self scheduleUpdate];
        
	}
	return self;
}


-(void)initDirectionalButtons{
    CGRect leftButtonDimensions = CGRectMake(0, 0, kDirectionalButtonLength, kDirectionalButtonLength);
    CGRect rightButtonDimensions = CGRectMake(0, 0, kDirectionalButtonLength, kDirectionalButtonLength);    
    CGPoint leftButtonPosition = ccp(screenSize.width*0.1f, screenSize.height*0.05f);
    CGPoint rightButtonPosition = ccp(screenSize.width*0.9f, screenSize.height*0.05f);    
    
    SneakyButtonSkinnedBase *leftButtonBase =
    [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    leftButtonBase.position = leftButtonPosition;
    leftButtonBase.defaultSprite =
    [CCSprite spriteWithFile:@"left-up.png"];
    leftButtonBase.activatedSprite =
    [CCSprite spriteWithFile:@"left-down.png"];
    leftButtonBase.pressSprite =
    [CCSprite spriteWithFile:@"left-down.png"];
    leftButtonBase.button = [[SneakyButton alloc]
                             initWithRect:leftButtonDimensions];
    leftButton = [leftButtonBase.button retain];
    leftButton.isToggleable = NO;
    leftButton.isHoldable = YES;
    [self addChild:leftButtonBase];
    
    
    SneakyButtonSkinnedBase *rightButtonBase =
    [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    rightButtonBase.position = rightButtonPosition;
    rightButtonBase.defaultSprite = [CCSprite
                                      spriteWithFile:@"right-up.png"];
    rightButtonBase.activatedSprite = [CCSprite
                                        spriteWithFile:@"right-down.png"];
    rightButtonBase.pressSprite = [CCSprite
                                    spriteWithFile:@"right-down.png"];
    rightButtonBase.button = [[SneakyButton alloc]
                               initWithRect:rightButtonDimensions];
    rightButton = [rightButtonBase.button retain];
    rightButton.isToggleable = NO;
    rightButton.isHoldable = YES;
    [self addChild:rightButtonBase];    
}



#pragma mark -
#pragma mark Update Method
-(void) update:(ccTime)deltaTime
{    
    //move hero left or right
    if (leftButton.active == YES) {
        if ( hero.position.x < (0+64) ) {
            //do nothing because he'll go off screen
        }else{
            hero.position = ccp( hero.position.x - 150*deltaTime, hero.position.y);
        }
    }
    if (rightButton.active == YES) {
        if ( hero.position.x > (screenSize.width - 32) ) {
            //do nothing because he'll go off screen
        }else{
            hero.position = ccp( hero.position.x + 150*deltaTime, hero.position.y);
        }
    }
    
    
    
    
    //boat moving across screen
    boat.position = ccp( boat.position.x + 100*deltaTime, boat.position.y );
    if (boat.position.x > screenSize.width+32) {
        boat.position = ccp( -32, boat.position.y );
    }    
    

    
    
    
}








- (void) dealloc{
	[super dealloc];
}

@end

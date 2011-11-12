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
-(void)updateBoat;
@end

@implementation UnderwaterGameplayLayer


-(id) init{
	if( (self=[super init])) {
        screenSize = [[CCDirector sharedDirector] winSize];
     
        self.isTouchEnabled = YES;
        
        hero = [CCSprite spriteWithFile:@"hero.png"];
        [hero setPosition:ccp(screenSize.width/2, screenSize.height*0.17f)];
        [self addChild:hero];
        
        //init boat but do not add yet, the updateBoat function will add it
        boat = [CCSprite spriteWithFile:@"cargo-ship.png"];
        [boat setPosition:ccp(screenSize.width + 256.0f, screenSize.height*0.90f)];        
        [self addChild:boat];
         
        elephant = [CCSprite spriteWithFile:@"elephant0.png"];
        [elephant setPosition:ccp(screenSize.width/2, screenSize.height*0.50f)];
        [self addChild:elephant];
        
        
        
        //TESTING
        bomb = [CCSprite spriteWithFile:@"bomb.png"];
        [bomb setPosition:ccp(50.0f, screenSize.height*0.65f)];
        [self addChild:bomb];
        
        
        //TODO: more sprite adding here for elephant, boat, bomb
    
        
        [self initDirectionalButtons];

        
        boatTimer = 10;
        boatInMotion = NO;
        
        
        //to determine hero movement from buttons
        [self scheduleUpdate];
        
        //to randomly make the boat come by every 5-15 secs
        [self schedule:@selector(updateBoat) interval:1.0];
        
        
        
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
#pragma mark Update Methods
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
            [self removeChild:bomb cleanup:YES]; 
        }else{
            hero.position = ccp( hero.position.x + 150*deltaTime, hero.position.y);
        }
    }
    
    
    
    
    //boat moving across screen
    if ( boatInMotion ) {
        boat.position = ccp( boat.position.x - 100*deltaTime, boat.position.y );
        if (boat.position.x < -256) {
            boat.position = ccp( screenSize.width + 256.0f, boat.position.y );
            boatInMotion = NO;
        }    
    }
    
    
}

-(void)updateBoat{
    if (!boatInMotion) {
        boatTimer--;
    }
    
    if ( (boatTimer <= 0) && (!boatInMotion) ){      
        //boat will now move from right to left until it is offscreen
        boatInMotion = YES;
        
        //Reset boatTimer by getting a random number between 5 and 15...this is the number of seconds we wait till the boat comes again
        boatTimer =  (arc4random() % 16) + 5;        
        CCLOG(@"boatTimer reset to %d seconds", boatTimer);
    }
}








- (void) dealloc{
	[super dealloc];
}

@end

//
//  UnderwaterGameplayLayer.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "UnderwaterGameplayLayer.h"

#import "CCTouchDispatcher.h"

#import "SimpleAudioEngine.h"

#define kDirectionalButtonLength 64.0f


@interface UnderwaterGameplayLayer(PrivateMethods)
-(void)initDirectionalButtons;
-(void)updateBoat;
-(void)dropBombFromBoat;
-(void)explodeBombOnSprite:(CCSprite *)sprite;
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
        
        
        bomb = [CCSprite spriteWithFile:@"bomb.png"];
        [bomb setPosition:ccp(-50.0f, screenSize.height*0.65f)];
        [self addChild:bomb];
        
        [self initDirectionalButtons];
        
        boatTimer = 1;
        boatInMotion = NO;
        
        bombDroppedFromBoat = NO;
        bombExploded = NO;
        bombSpeedMultiplier = 1;
        
        
        
        
        //SOUNDZZzZz
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"ocean-bg-music.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"boat.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"elephant-attack.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"elephant-hurt.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"elephant-dies.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ow.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"swim.caf"];        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"thud.caf"];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ocean-bg-music.caf" loop:YES];
        
        
        //update to determine movements and events
        [self scheduleUpdate];
        
        //to randomly make the boat come by every 5-15 secs
        [self schedule:@selector(updateBoat) interval:1.0];
        
        self.isTouchEnabled = YES;
        
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



-(void)dropBombFromBoat{
    //place the bomb where the boat is, update function will take care of it falling and collision detection also
    CGPoint boatPosition = boat.position;    
    bomb.position = boatPosition;
    bombSpeedMultiplier = 1;
    bombDroppedFromBoat = YES;
}

-(void)explodeBombOnSprite:(CCSprite *)sprite{    
    //bomb exploding
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
    particleExplosion = [[[CCParticleExplosion alloc] init] autorelease];

    particleExplosion.position = bomb.position;
    particleExplosion.endSize = 1;    
    [self addChild:particleExplosion z:3.0];
    particleExplosion.autoRemoveOnFinish = YES;

    
    //bomb reset
    bombExploded = YES;
    bomb.position = ccp(-50.0f, -50.0f);

    
    //TODO: ELEPHANT/HUMAN HURTING AND GAME OVER/WIN
    if ( sprite == elephant ) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"elephant-hurt.caf"];        
        CCLOG(@"elephant gets hurt animation");
        //TODO: LOTS OF STUFF TODO HERE:
        //
        //-show bomb explosion!
        //-decrease elephant health
        //-if elephant health 0, you win!  do the following:
        //      -play super explosion animation...maybe just lots of particle crap if no time?
        //      -do all cleanup and replace scene with victory scene!
        //-else
        //  -elephant is stunned and is flashing...cannot move for 3 secs
        //
        //        
        
    }else if ( sprite == hero ){
        [[SimpleAudioEngine sharedEngine] playEffect:@"ow.caf"];        
        CCLOG(@"hero gets hurt animation");        
    }
    
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
        }else{
            hero.position = ccp( hero.position.x + 150*deltaTime, hero.position.y);
        }
    }
    
    
    
    
    //boat moving across screen
    if ( boatInMotion ) {
        boat.position = ccp( boat.position.x - 100*deltaTime, boat.position.y );
        if (boat.position.x < -256) {
            //boat needs to be reset and be put back to where it came from, gets a new bomb also
            boat.position = ccp( screenSize.width + 256.0f, boat.position.y );
            boatInMotion = NO;
            bombDroppedFromBoat = NO;
            bombExploded = NO;
            bombSpeedMultiplier = 1;
        }    
    }
    
    
    
    //bomb falling
    if ( bombDroppedFromBoat && !bombExploded ) {
        CGFloat newY = bomb.position.y - 5.0 * bombSpeedMultiplier * deltaTime;
        bombSpeedMultiplier++;        
        
        bomb.position = ccp(bomb.position.x, newY);
        
        
        //bomb hit elephant!
        if ( CGRectContainsPoint(elephant.boundingBox, bomb.position) ) {
            CCLOG(@"BOMB HIT ELEPHANT!");
            [self explodeBombOnSprite:elephant];
        }else if ( CGRectContainsPoint(hero.boundingBox, bomb.position) ){
            CCLOG(@"BOMB HIT HERO!!!!");     
            [self explodeBombOnSprite:hero];
        }
        else if( bomb.position.y < 0 ){
            //explode on the ocean surface
            CCLOG(@"bomb hit ocean floor");
            [self explodeBombOnSprite:nil];
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
        
    [[SimpleAudioEngine sharedEngine] playEffect:@"boat.caf"];        
    }
}



#pragma mark - Touches
-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {        
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    
    //boat touched
    if ( CGRectContainsPoint(boat.boundingBox, location) ) {        
        CCLOG(@"boat touched!");
        
        if ( !bombDroppedFromBoat ) {
            CCLOG(@"dropped bomb from boat");
            //drop bomb from boat here
            [self dropBombFromBoat];
        }
        
        
        return YES;
    }
    
    return NO;
}




@end

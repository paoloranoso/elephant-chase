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

#import "LoadingScene.h"

#define kDirectionalButtonLength 64.0f


@interface UnderwaterGameplayLayer(PrivateMethods)
-(void)initDirectionalButtons;
-(void)updateBoat;
-(void)dropBombFromBoat;
-(void)explodeBombOnSprite:(CCSprite *)sprite;
-(void)updateElephantChasing;
-(void)moveElephantUpAgain;
-(void)updateHeroLife;
-(void)characterDied:(CCSprite *)sprite;
@end

@implementation UnderwaterGameplayLayer


-(id) init{
	if( (self=[super init])) {
        screenSize = [[CCDirector sharedDirector] winSize];
     
        self.isTouchEnabled = YES;
        
        hero = [CCSprite spriteWithFile:@"hero-left.png"];
        [hero setPosition:ccp(screenSize.width/2, screenSize.height*0.2f)];
        [self addChild:hero];
        
        //init boat but do not add yet, the updateBoat function will add it
        boat = [CCSprite spriteWithFile:@"cargo-ship.png"];
        [boat setPosition:ccp(screenSize.width + 256.0f, screenSize.height*0.90f)];        
        [self addChild:boat];
         
        elephant = [CCSprite spriteWithFile:@"elephant0.png"];
        [elephant setPosition:ccp(-256.0f, screenSize.height*0.55f)];
        [self addChild:elephant];
        
        
        bomb = [CCSprite spriteWithFile:@"bomb.png"];
        [bomb setPosition:ccp(-50.0f, screenSize.height*0.65f)];
        [self addChild:bomb];
        
        [self initDirectionalButtons];
        
        boatTimer = 3;
        boatInMotion = NO;
        
        bombDroppedFromBoat = NO;
        bombExploded = NO;
        bombSpeedMultiplier = 1;
        
        isElephantChasing = NO;
        elephantStomped = NO;    
        elephantSpeedMultiplierX = 1;        
        elephantSpeedMultiplierY = 1;       
        elephantRageMultiplier = 1;
        heroRageMultiplier = 1;
        
        heroLife = 10;
        elephantLife = 20;
        
        gameOver = NO;
        gameWon = NO;
        gameLost = NO;
        
        
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
        
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.5; 
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ocean-bg-music.caf" loop:YES];
        
        
        //update to determine movements and events
        [self scheduleUpdate];
        
        //to randomly make the boat come by every 5-15 secs
        [self schedule:@selector(updateBoat) interval:1.0];
        
        //to have the elephant chase the hero
        [self schedule:@selector(updateElephantChasing) interval:1.0];
        
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
    
    
    //COLORS TEST 1/31/2012
    [particleExplosion setStartColor:ccc4FFromccc4B(ccc4(1.0, 0.5, 0.2, 1.0)) ];
    [particleExplosion setEndColor:ccc4FFromccc4B(ccc4(1.0, 0.7, 0.5, 1.0)) ];
    
//    startColor.g = 0.25f;
//    startColor.b = 0.12f;
//    startColor.a = 1.0f;
//    
//    startColorVar.r = 0.0f;
//    startColorVar.g = 0.0f;
//    startColorVar.b = 0.0f;
//    startColorVar.a = 0.0f;
//    
//    endColor.r = 0.0f;
//    endColor.g = 0.0f;
//    endColor.b = 0.0f;
//    endColor.a = 1.0f;
//    
//    endColorVar.r = 0.0f;
//    endColorVar.g = 0.0f;
//    endColorVar.b = 1.0f;
//    endColorVar.a = 0.0f;
    
    
    
    [self addChild:particleExplosion z:3.0];
    particleExplosion.autoRemoveOnFinish = YES;

    
    //bomb reset
    bombExploded = YES;
    bomb.position = ccp(-50.0f, -50.0f);

    
    if ( sprite == elephant ) {
        elephantLife--;
        
        if ( elephantLife <= 0 ) {
            //WIN!
            [self characterDied:elephant];
        }else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"elephant-hurt.caf"];
            [elephant runAction:[CCBlink actionWithDuration:2.0 blinks:10]];        
            elephantRageMultiplier+=2;
            heroRageMultiplier+= 0.5;            
        }        
    }else if ( sprite == hero ){
        heroLife--;
        [[SimpleAudioEngine sharedEngine] playEffect:@"ow.caf"];        
        
        if ( heroLife <= 0 ) {
            //LOSE!
            [self characterDied:hero];
        }else{
            [hero runAction:[CCBlink actionWithDuration:2.0 blinks:10]];    
        }          
        

        CCLOG(@"hero gets hurt animation");        
    }
    
}

-(void)moveElephantUpAgain{
    elephantStomped = YES;
    isElephantStomping = NO;
}


-(void)characterDied:(CCSprite *)sprite{
    CCLOG(@"===character died called===");    
    if ( sprite == elephant ) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"elephant-dies.caf"];
        
        particleExplosion = [[[CCParticleExplosion alloc] init] autorelease];
        
        particleExplosion.position = elephant.position;
        //            particleExplosion.endSize = 1;    
        [self addChild:particleExplosion z:3.0];
        particleExplosion.autoRemoveOnFinish = YES;
        
//        [self removeChild:elephant cleanup:YES];
        elephant.visible = NO;        
        gameWon = YES;
    }
    
    if ( sprite == hero ) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"ow.caf"];
        
        particleExplosion = [[[CCParticleExplosion alloc] init] autorelease];
        
        particleExplosion.position = hero.position;
        //            particleExplosion.endSize = 1;    
        [self addChild:particleExplosion z:3.0];
        particleExplosion.autoRemoveOnFinish = YES;
        
//        [self removeChild:hero cleanup:YES];
        hero.visible = NO;
        gameLost = YES;
    }    
    
    gameOver = YES;
    
}


#pragma mark -
#pragma mark Update Methods
-(void) update:(ccTime)deltaTime
{    
    //move hero left or right
    if (leftButton.active == YES) {
        if ( hero.rotation != 0.0f ) {
            hero.rotation = 0.0f;
            hero.flipY = NO;
        }
        if ( hero.position.x < (0+64) ) {
            //do nothing because he'll go off screen
        }else{
            hero.position = ccp( hero.position.x - 150 * heroRageMultiplier * deltaTime, hero.position.y);
        }
    }
    if (rightButton.active == YES) {
        if ( hero.rotation != 180.0f ) {
            hero.rotation = 180.0f;
            hero.flipY = YES;
        }
        
        if ( hero.position.x > (screenSize.width - 32) ) {
            //do nothing because he'll go off screen
        }else{
            hero.position = ccp( hero.position.x + 150 * heroRageMultiplier * deltaTime, hero.position.y);
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
        else if( bomb.position.y < 80.0f ){
            //explode on the ocean surface
            CCLOG(@"bomb hit ocean floor");
            [self explodeBombOnSprite:nil];
        }
    }
        
    
    //elephant chasing
    if ( isElephantChasing && !isElephantStomping && !elephantStomped ) {
        CGFloat elephantX = elephant.position.x;
        CGFloat heroX = hero.position.x;
        
        CGFloat difference = elephantX - heroX;
        
        
        
        if ( ( difference > -32.0f ) && ( difference < 32.0f ) ) {
            //stomp on human!!!
            isElephantStomping = YES;
//            CCLOG(@"Stomping on human!");
        }else  if ( difference <= -32.0f ) {
            //move right
            CGFloat newX = elephant.position.x + 100.0 * elephantSpeedMultiplierX * elephantRageMultiplier * deltaTime;
//            elephantSpeedMultiplierX++;                    
            elephant.position = ccp(newX, elephant.position.y);
//            CCLOG(@"elephant moving right to follow human");
        }else if ( difference >= 32.0f ){
            //move left
            CGFloat newX = elephant.position.x - 100.0 * elephantSpeedMultiplierX * elephantRageMultiplier * deltaTime;
//            elephantSpeedMultiplierX++;                    
            elephant.position = ccp(newX, elephant.position.y);            
//            CCLOG(@"elephant moving left to follow human");
        }        
    }
    
    if ( isElephantStomping ) {
        CGFloat newY = elephant.position.y - 5.0 * elephantSpeedMultiplierY * elephantRageMultiplier * deltaTime;
        elephantSpeedMultiplierY++;        
        
        elephant.position = ccp(elephant.position.x, newY);
        
        
        //thump and also check to see if elephant hit human
        if( elephant.position.y < 170 ){
            //thump on the ocean surface
            CCLOG(@"elephant THUMP!");
            [[SimpleAudioEngine sharedEngine] playEffect:@"thud.caf"];              
            [self moveElephantUpAgain];
            

            if ( CGRectContainsPoint(hero.boundingBox, elephant.position) ) {
                CCLOG(@"ELEPHANT HIT HUMAN!!!");
                heroLife--;
                [[SimpleAudioEngine sharedEngine] playEffect:@"ow.caf"];        
                
                if ( heroLife <= 0 ) {
                    //LOSE!
                    [self characterDied:hero];
                }else{
                    [hero runAction:[CCBlink actionWithDuration:2.0 blinks:10]];    
                }          
                
                
            }
            
        }
    }
    
    if ( elephantStomped ) {
        if ( elephant.position.y < screenSize.height*0.55f ) {
            //start moving back up
            
            int specialMultiplier = (elephantRageMultiplier/2) ? (elephantRageMultiplier/2) : 1;
            
            CGFloat newY = elephant.position.y + 100.0 * specialMultiplier * deltaTime;                  
            elephant.position = ccp(elephant.position.x, newY);        
//            CCLOG(@"elephant moving back up");            
        }else{
            //finally up, reset and start over
            isElephantChasing = NO;
            elephantStomped = NO;    
            elephantSpeedMultiplierX = 1;        
            elephantSpeedMultiplierY = 1;        
//            CCLOG(@"elephant completed move up, stuff reset and ready to chase again!");
        }
        
    }
    
    if ( gameOver ) {
        [self unscheduleAllSelectors];
        [self unscheduleUpdate];
        
        //TODO: show win or lose scenes accordingly
        if ( gameWon ) {
            LoadingScene* scene = [LoadingScene sceneWithTargetScene:TargetSceneYouWin];    
            [[CCDirector sharedDirector] replaceScene:scene];            
        }else if ( gameLost ){
            LoadingScene* scene = [LoadingScene sceneWithTargetScene:TargetSceneYouLose];    
            [[CCDirector sharedDirector] replaceScene:scene];            
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
        boatTimer =  (arc4random() % 3) + 5;        
        CCLOG(@"boatTimer reset to %d seconds", boatTimer);
        
    [[SimpleAudioEngine sharedEngine] playEffect:@"boat.caf"];        
    }
}


-(void)updateElephantChasing{
    if ( !isElephantChasing && !isElephantStomping ) {
        //make elephant follow hero on the x-axis
        elephantSpeedMultiplierX = 1;
        isElephantChasing = YES;
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

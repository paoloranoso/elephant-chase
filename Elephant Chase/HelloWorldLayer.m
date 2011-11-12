//
//  HelloWorldLayer.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/11/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


#import "HelloWorldLayer.h"


@implementation HelloWorldLayer

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	[scene addChild: layer];
	
	return scene;
}


-(id) init{
	if( (self=[super init])) {
		
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];	
		label.position =  ccp( size.width /2 , size.height/2 );
		[self addChild: label];
	}
	return self;
}


- (void) dealloc{
	[super dealloc];
}

@end

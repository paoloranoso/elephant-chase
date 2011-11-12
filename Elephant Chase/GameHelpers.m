//
//  GameHelpers.m
//  Elephant Chase
//
//  Created by Paolo Ranoso on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameHelpers.h"


@implementation GameHelpers

- (id)init{
    if ( self = [super init] ) {
        // Initialization code here.
    }
    
    return self;
}


+(BOOL)isPad{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return YES;
    }
    return NO;
}

+(BOOL)isPhone{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return YES;
    }
    return NO;    
}



@end
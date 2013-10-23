//
//  MyManager.m
//  Dance Wars
//
//  Created by Prayaas Jain on 10/4/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "MyManager.h"

static MyManager *sharedMyManager = nil;

@implementation MyManager

@synthesize inputBundle;

#pragma mark Singleton Methods

+ (id) sharedManager {

    static MyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id) init {
    
    if(self = [super init]) {
        inputBundle = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc {
    //should never be called
}

@end

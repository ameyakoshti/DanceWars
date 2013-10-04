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
    
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
    
}

+ (id) allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (id) retain {
    return self;
}

- (unsigned) retainCount {
    return UINT_MAX;
}

- (oneway void) release {
    //never release
}

- (id) autorelease {
    return self;
}

- (id) init {
    if(self = [super init]) {
        inputBundle = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    //should never be called
    [inputBundle release];
    [super dealloc];
}

@end

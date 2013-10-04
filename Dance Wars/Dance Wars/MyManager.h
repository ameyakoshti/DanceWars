//
//  MyManager.h
//  Dance Wars
//
//  Created by Prayaas Jain on 10/4/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyManager : NSObject {
    
    NSMutableDictionary *inputBundle;
    
}

@property (nonatomic, retain) NSMutableDictionary *inputBundle;

+ (id) sharedManager;

@end

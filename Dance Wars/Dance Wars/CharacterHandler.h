//
//  CharacterHandler.h
//  Dance Wars
//
//  Created by Prayaas Jain on 9/27/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CharacterHandler : NSObject {
    
}

@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) CCSprite *character;
@property (nonatomic, retain) NSString *charName;
@property (nonatomic, retain) NSString *aiName;

@end

//
//  CharacterSelect.h
//  Dance Wars
//
//  Created by Prayaas Jain on 9/27/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputHandler.h"
#import "CharacterHandler.h"
#import "cocos2d.h"
#import "MyManager.h"


@interface CharacterSelect : CCLayer {

    CharacterHandler *ch;
    int counter;
    CGSize windowSize;
    MyManager *sharedManager;
    CCMenu *MainMenu;
    CCSprite *label;
}

@property (nonatomic, retain) NSMutableArray *charSpriteList;
@property (nonatomic, assign) int num;
-(CCSprite *) addSprite:(NSString *)spritePath;
+(CCScene *) scene;


@end

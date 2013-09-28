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

@interface CharacterSelect : CCLayer {

    InputHandler *ih;
    CharacterHandler *ch;
    int counter;
    
}

@property (nonatomic, retain) NSMutableArray *charSpriteList;
-(CCSprite *) addSprite:(NSString *)spritePath;
+(CCScene *) scene;


@end

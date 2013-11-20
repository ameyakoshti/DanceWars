//
//  LevelSelectLayer.h
//  Dance Wars
//
//  Created by Prayaas Jain on 9/27/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InputHandler.h"
#import "GameLevelLayer.h"
#import "MyManager.h"
#import "GameLevelLayer.h"
#import "HelloWorldLayer.h"
#import "LevelEnvironment.h"

@interface LevelSelectLayer : CCLayerColor {
    
    InputHandler *ih;
    GameLevelLayer *gll;
    MyManager *sharedManager;
    LevelEnvironment *le;
    CCMenu *gameMenu;
    CCSprite *label;
    CGSize size;
}

+(CCScene *) scene;

@end

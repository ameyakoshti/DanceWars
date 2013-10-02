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

@interface LevelSelectLayer : CCLayerColor {
    
    InputHandler *ih;
    GameLevelLayer *gll;
    
}

+(CCScene *) scene;

@end

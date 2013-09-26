//
//  GameLevelLayer.h
//  Dance Wars
//
//  Created by Prayaas Jain on 9/20/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLevelLayer : CCLayerColor {
    CGSize size;
    NSMutableArray * _patternsGenerated;
    CCSprite *touchIcon;
    CCSprite *dancer;
    int hitCount;
    int objectCount;
    int missCount;
    NSString *score;
    CCLabelTTF *scoreLabel;
    CCProgressTimer *progressTimer;
    int life;
}

+(CCScene *) scene;

@property (nonatomic,retain) CCProgressTimer *progressTimer;
@property (nonatomic,assign) int life;

@end

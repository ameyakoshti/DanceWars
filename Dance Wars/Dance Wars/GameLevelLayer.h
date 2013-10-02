//
//  GameLevelLayer.h
//  Dance Wars
//
//  Created by Prayaas Jain on 9/20/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "InputHandler.h"
#import "GeneratePoints.h"
#import "cocos2d.h"

@interface GameLevelLayer : CCLayer <UIGestureRecognizerDelegate> {
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
    
    float xLocations[6];
    float yLocations[6];
    int visited[6];
    CCSprite *touchHit;
    
    InputHandler *ih;
}

+(CCScene *) scene;

@property (nonatomic,retain) CCProgressTimer *progressTimer;
@property (nonatomic,assign) int life;
@property (nonatomic,assign) NSString *background;

@end

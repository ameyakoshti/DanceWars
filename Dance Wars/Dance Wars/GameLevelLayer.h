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
#import "Score.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "MyManager.h"
#import "LevelEnvironment.h"
#import "SimpleAudioEngine.h"

@interface GameLevelLayer : CCLayer <UIGestureRecognizerDelegate> {
    CGSize size;
    NSMutableArray * _patternsGenerated;
    CCSprite *touchIcon;
    CCSprite *dancer;
    CCSprite *aichar;
    CCSprite *grid;
    CCSpriteBatchNode *userSpriteSheet;
    CCSpriteBatchNode *aiSpriteSheet;
    int hitCount;
    int objectCount;
    int missCount;
    NSString *score;
    CCLabelTTF *scoreLabel;
    MyManager *sharedManager;
    LevelEnvironment *le;
    
    float xLocations[6];
    float yLocations[6];
    int visited[6];
    CCSprite *touchHit;
    
    InputHandler *ih;
    Score *getScore;
}

+(CCScene *) scene;
-(void) enableGesture;

@property (nonatomic,retain) CCProgressTimer *progressTimer;
@property (nonatomic,retain) CCProgressTimer *aiProgressTimer;
@property (nonatomic,assign) int life;
@property (nonatomic,assign) int aiLife;
@property (nonatomic,assign) NSString *background;

@end

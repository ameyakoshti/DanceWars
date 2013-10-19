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
#import "CharacterSelect.h"

@interface GameLevelLayer : CCLayer <UIGestureRecognizerDelegate> {
    
    CGSize size;
    NSMutableArray * _patternsGenerated;
    
    CCSprite *touchIcon[2];
    CCSprite *dancer;
    CCSprite *aichar;
    CCSprite *grid;
    CCSprite *message;
    CCSpriteBatchNode *userSpriteSheet;
    CCSpriteBatchNode *aiSpriteSheet;

    BOOL swipeHit;
    
    int checkIfBothHit;
    int touchPointCounter;
    int hitCount;
    int objectCount;
    int missCount;
    int totalObjects;
    int visited[6];
    
    float xLocations[6];
    float yLocations[6];

    NSString *score;
    CCLabelTTF *scoreLabel;
    
    InputHandler *ih;
    CharacterHandler *charHand;
    Score *getScore;
    MyManager *sharedManager;
    LevelEnvironment *le;

}

+(CCScene *) scene;
-(void) enableGesture;

@property (nonatomic,retain) CCProgressTimer *progressTimer;
@property (nonatomic,retain) CCProgressTimer *aiProgressTimer;
@property (nonatomic,assign) int life;
@property (nonatomic,assign) int aiLife;
@property (nonatomic,assign) NSString *background;

@end

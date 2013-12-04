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
    NSString *charName;
    
    CCSprite *touchIcon[4];
    CCSprite *dancer;
    CCSprite *aichar;
    CCSprite *message;
    CCSprite *messageNice,*messageAwesome,*messageKeepShakin,*messageGreatMove, *messageDance;
    CCSprite *arrow;
    CCSpriteBatchNode *backgroundSpriteSheet;
    CCSpriteBatchNode *userSpriteSheet;
    CCSpriteBatchNode *aiSpriteSheet;
    CCMenuItem *buttonrestart;
    CCMenuItemImage *pauseButton;

    BOOL swipeHit;
    BOOL visited[4];
    
    int touchPointCounter;
    int hitCount;
    int objectCount;
    int missCount;
    int totalObjects;
    int totalHitCount;
    int totalGeneratedObjects;
    
    float xLocations[15];
    float yLocations[15];

    CCLabelTTF *scoreLabel;
    CCLabelTTF *AIscoreLabel;
    CCLabelTTF *UserScoreLabel;

    CCMenu *pauseMenu;
    CCMenu *gameMenu;
    
    InputHandler *ih;
    CharacterHandler *charHand;
    Score *getScore;
    MyManager *sharedManager;
    LevelEnvironment *le;
    
    NSArray *singleTouches;
    NSArray *doubleTouches;
    NSArray *swipes;
}

+(CCScene *) scene;
-(void) enableGesture:(NSNumber *) value;
-(void) initiateBackground:(NSString *) dynamicBackground;

@property (nonatomic,retain) CCProgressTimer *progressTimer;
@property (nonatomic,retain) CCProgressTimer *aiProgressTimer;
@property (nonatomic,assign) int life;
@property (nonatomic,assign) int aiLife;
@property (nonatomic,assign) NSString *background;

@end

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
    
    CCSprite *touchIcon[4];
    CCSprite *dancer;
    CCSprite *aichar;
    CCSprite *message;
    CCSprite *arrow;
    CCSpriteBatchNode *backgroundSpriteSheet;
    CCSpriteBatchNode *userSpriteSheet;
    CCSpriteBatchNode *aiSpriteSheet;

    BOOL swipeHit;

    int touchPointCounter;
    int hitCount;
    int objectCount;
    int missCount;
    int totalObjects;
    int visited[4];
    int totalGeneratedObjects;
    
    float xLocations[15];
    float yLocations[15];

    CCLabelTTF *scoreLabel;
    
    CCMenu *pauseMenu;
    
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

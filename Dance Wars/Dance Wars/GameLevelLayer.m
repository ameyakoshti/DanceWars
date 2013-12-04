//
//  GameLevelLayer.m
//  Dance Wars
//
//  Created by Prayaas Jain on 9/20/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "AppDelegate.h"
#import "GameLevelLayer.h"

@implementation GameLevelLayer

@synthesize life,aiLife,progressTimer,aiProgressTimer,background;

static NSString * const UIGestureRecognizerNodeKey = @"UIGestureRecognizerNodeKey";

// Time between the touch icons
static float levelDifficulty1Speed = 1.45;
static float levelDifficulty2Speed = 0.75;
static float levelDifficulty3Speed = 0.50;
static float speed;
static float swipeSpeed = 1.45;
static bool swipeEnableGlobal = NO;
static float removeMessageSpeed = 0.50;

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	GameLevelLayer *layer = [GameLevelLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    if((self = [super init])) {
        
        size = [[CCDirector sharedDirector] winSize];
        
        // Loading game environment
        totalObjects = 0;
        totalHitCount = 0;
        sharedManager = [MyManager sharedManager];
        le = [sharedManager.inputBundle objectForKey:@"ENVR"];
        le.background.position = ccp(size.width/2, size.height/2);
        [self addChild:le.background z:-10 tag:101];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:le.backgroundMusic];
        [self performSelector:@selector(initiateBackground:) withObject:le.backgroundName afterDelay:0.75];
        
        InputHandler *ihvol = [sharedManager.inputBundle objectForKey:@"VOLCONTROL"];
        InputHandler *ihvolchanged = [sharedManager.inputBundle objectForKey:@"VOLCHANGED"];
        NSLog(@"vol object: %f", ihvol.volumeLevel);
        NSLog(ihvolchanged.checkvolumeAltered ? @"Yes" : @"No");
        
        if(ihvolchanged.checkvolumeAltered && ihvol.volumeLevel < 1.0) {
            [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0];
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0];
        }
        
        // Get character selected values from the character selection screen
        charHand = [sharedManager.inputBundle objectForKey:@"ch"];
        
        // Player character
        dancer = [CCSprite spriteWithFile:[charHand.charName stringByAppendingString:@"_0.png"]];
        if([charHand.charName isEqualToString:@"player_2"])
        dancer.scale = 1.35;
        dancer.position = ccp(225,175);
        [self addChild:dancer z:0 tag:1];
        
        // AI character
        aichar = [CCSprite spriteWithFile:[charHand.aiName stringByAppendingString:@"_0.png"]];
        if([charHand.aiName isEqualToString:@"player_2"])
        aichar.scale = 1.35;
        aichar.position = ccp(801,175);
        aichar.flipX = 180;
        [self addChild:aichar z:0 tag:2];
        
        // Player life bar
        CCSprite* UserLifeWrapper = [CCSprite spriteWithFile:@"outline_health_bar.png"];
        UserLifeWrapper.scale = 0.3;
        UserLifeWrapper.position = ccp(200 ,size.height-50);
        [self addChild:UserLifeWrapper];

        self.life = 0;
        self.progressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"health_bar.png"]];
        self.progressTimer.type = kCCProgressTimerTypeBar;
        self.progressTimer.midpoint = ccp(0,0);
        self.progressTimer.barChangeRate = ccp(1,0);
        [self.progressTimer setScale:0.3];
        self.progressTimer.percentage = self.life;
        self.progressTimer.position = ccp(200 ,size.height-50);
        [self addChild:self.progressTimer];
        
        //User Score label
        UserScoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:35];
        UserScoreLabel.position =CGPointMake(290,size.height - 80);
        UserScoreLabel.color=ccc3(240, 255, 255);
        [UserScoreLabel setString :[NSString stringWithFormat:@"Score: 0"]];
        [self addChild:UserScoreLabel z:1 tag:41];
        
        // AI life bar
        CCSprite *AILifeWrapper = [CCSprite spriteWithFile:@"outline_health_bar.png"];
        AILifeWrapper.position = ccp(size.width-200,size.height-50);
        AILifeWrapper.scale = 0.3;
        AILifeWrapper.flipX = 180;
        [self addChild:AILifeWrapper];
        
        self.aiLife = 0;
        self.aiProgressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"health_bar.png"]];
        self.aiProgressTimer.type = kCCProgressTimerTypeBar;
        self.aiProgressTimer.midpoint = ccp(0,0);
        self.aiProgressTimer.barChangeRate = ccp(1,0);
        [self.aiProgressTimer setScale:0.3];
        self.aiProgressTimer.rotationY = 180;
        self.aiProgressTimer.percentage = self.aiLife;
        self.aiProgressTimer.position = ccp(size.width-200,size.height-50);
        [self addChild:self.aiProgressTimer];
        
        //AI Score Label
        AIscoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:35];
        AIscoreLabel.position =CGPointMake(size.width - 290,size.height - 80);
        AIscoreLabel.color=ccc3(240, 255, 255);
        [AIscoreLabel setString :[NSString stringWithFormat:@"Score: 0"]];
        [self addChild:AIscoreLabel z:1 tag:40];

        
        // Displaying a pause button to return to the main menu screen
        pauseButton = [CCMenuItemImage itemWithNormalImage:@"pausegame.png" selectedImage:@"pausegame_pressed.png" target:self selector:@selector(initiatePause)];
        CCMenu *pauseButtonMenu = [CCMenu menuWithItems:pauseButton, nil];
        pauseButtonMenu.position = ccp(size.width - pauseButton.contentSize.width/2, pauseButton.contentSize.height/2);
        [self addChild:pauseButtonMenu z:1 tag:13];
        
        //Creating and adding pause menu
        CCMenuItemImage *resumebutton = [CCMenuItemImage itemWithNormalImage:@"resume.png" selectedImage:@"resume_pressed.png" target:self selector:@selector(gameResume)];
        
        CCMenuItemImage *mainbutton = [CCMenuItemImage itemWithNormalImage:@"main-menu.png" selectedImage:@"main-menu_pressed.png" target:self selector:@selector(loadHelloWorldLayer)];
        
        CCMenuItemImage *restartbutton = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay_pressed.png" target:self selector:@selector(gameRestart)];
        
        pauseMenu = [CCMenu menuWithItems:resumebutton, mainbutton, restartbutton, nil];
        [pauseMenu alignItemsVertically];
        pauseMenu.position = ccp(size.width/2, size.height + 450);
        [self addChild:pauseMenu z:1000 tag:23];
        
        
        // Start the game by showing the touch icons
        touchPointCounter=1;
        totalGeneratedObjects = 0;
        [self manageTouchIcons];
        
        // Input handler object initialization to set the speed of the touch icons
        ih = [sharedManager.inputBundle objectForKey:@"LDAA"];
        switch (ih.gameLevelDifficulty)
        {
            case 1:
                speed = levelDifficulty1Speed;
                break;
            case 2:
                speed = levelDifficulty2Speed;
                break;
            case 3:
                speed = levelDifficulty3Speed;
                break;
        }
        
        // Initial idle move for user
        //[self initiateIdleDance];
        
        messageDance = [CCSprite spriteWithFile:@"danceMessage.png"];
        messageDance.position = ccp(size.width/2,size.height/2);
        [self addChild:messageDance];
        messageDance.visible = FALSE;
        
        messageNice = [CCSprite spriteWithFile:@"nice.png"];
        messageNice.position = ccp(size.width/2,size.height/2);
        [self addChild:messageNice];
        messageNice.visible = FALSE;
        
        messageAwesome = [CCSprite spriteWithFile:@"awesome.png"];
        messageAwesome.position = ccp(size.width/2,size.height/2);
        [self addChild:messageAwesome];
        messageAwesome.visible = FALSE;
        
        messageKeepShakin = [CCSprite spriteWithFile:@"keepshakinit.png"];
        messageKeepShakin.position = ccp(size.width/2,size.height/2);
        [self addChild:messageKeepShakin];
        messageKeepShakin.visible = FALSE;
        
        messageGreatMove = [CCSprite spriteWithFile:@"greatmove.png"];
        messageGreatMove.position = ccp(size.width/2,size.height/2);
        [self addChild:messageGreatMove];
        messageGreatMove.visible = FALSE;
        
    }
    
    return self;
}

-(void) onEnter {
    // Enable multi touches and gestures
    self.touchEnabled = YES;
    [[[CCDirector sharedDirector]view]setMultipleTouchEnabled:YES];

    [super onEnter];
}

-(void) onExit {
    [self removeChild:pauseMenu cleanup:YES];
    [self removeChildByTag:100 cleanup:YES];
}

-(void) addMessage:(NSString *)image {
    message = [CCSprite spriteWithFile:image];
    if([image isEqualToString:@"danceMessage.png"]){
        message.position = ccp(size.width/2,size.height/2);
    }
    if([image isEqualToString:@"nice.png"]){
        message.position = ccp(size.width/2,size.height*2/3);
    }
    if([image isEqualToString:@"youwin.png"]){
        message.position = ccp(size.width/2,size.height*2/3);
    }
    if([image isEqualToString:@"youlose.png"]){
        message.position = ccp(size.width/2,size.height*2/3);
    }
    [self addChild:message];
}

-(void) removeMessage {
    [self removeChild:message cleanup:YES];
}

-(void) gamePlayLoopCondition {
    
    if (self.life<100 && self.aiLife<100) {

        objectCount=0;
        touchPointCounter=1;
        hitCount=0;
        
        messageDance.visible = TRUE;
        //[self addMessage:@"danceMessage.png"];
        //[self performSelector:@selector(removeMessage) withObject:[NSNumber numberWithInt:1] afterDelay:1];
        [self manageTouchIcons];
    }
    else {
        //[self scheduleOnce:@selector(initiateBlast) delay:1.0];
        if(self.life > self.aiLife){
            [self winGame];
            CCDelayTime *delayloadlayergame =  [CCDelayTime actionWithDuration:3];
            CCCallFunc *callFunclayergame = [CCCallFunc actionWithTarget:self selector:@selector(changeGameLayer)];
            CCCallFunc *removetext = [CCCallFunc actionWithTarget:self selector:@selector(winGameRemove)];
            [self runAction:[CCSequence actions:delayloadlayergame, callFunclayergame, nil]];
            [self runAction:[CCSequence actions:delayloadlayergame, removetext, nil]];
            //[self performSelector:@selector(removeMessage) withObject:[NSNumber numberWithInt:1] afterDelay:3.5];
            [self removeChild:backgroundSpriteSheet];
        }
        else{
            [self loseGame];
            CCDelayTime *delayloadlayergame =  [CCDelayTime actionWithDuration:3];
            CCCallFunc *callFunclayergame = [CCCallFunc actionWithTarget:self selector:@selector(playSameGameLayer)];
            CCCallFunc *removetext = [CCCallFunc actionWithTarget:self selector:@selector(loseGameRemove)];
            [self runAction:[CCSequence actions:delayloadlayergame, callFunclayergame, nil]];
            [self runAction:[CCSequence actions:delayloadlayergame, removetext, nil]];
            //[self performSelector:@selector(removeMessage) withObject:[NSNumber numberWithInt:1] afterDelay:3.5];
            [self removeChild:backgroundSpriteSheet];
        }
        
        pauseButton.visible = FALSE;
        
        // Displaying score
        
        int scoreHeight = size.height*1/3 + 50;
        
        scoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:50];
        scoreLabel.position =CGPointMake(size.width/2,scoreHeight);
        scoreLabel.color=ccc3(240, 255, 255);
        [scoreLabel setString :[NSString stringWithFormat:@"%s", "Score"]];
        [self addChild:scoreLabel z:1 tag:30];
     
        scoreHeight = scoreHeight - 50;
        scoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:50];
        scoreLabel.position =CGPointMake(size.width/2,scoreHeight);
        scoreLabel.color=ccc3(240, 255, 255);
        [scoreLabel setString :[NSString stringWithFormat:@"Accuracy %i%%", (totalHitCount*100)/totalObjects]];
        [self addChild:scoreLabel z:1 tag:31];

        scoreHeight = scoreHeight - 50;
        scoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:50];
        scoreLabel.position =CGPointMake(size.width/2,scoreHeight);
        scoreLabel.color=ccc3(240, 255, 255);
        [scoreLabel setString :[NSString stringWithFormat:@"Total Hits %i of %i", totalHitCount,totalObjects]];
        [self addChild:scoreLabel z:1 tag:32];
        
        scoreHeight = scoreHeight - 50;
        scoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:50];
        scoreLabel.position =CGPointMake(size.width/2,scoreHeight);
        scoreLabel.color=ccc3(240, 255, 255);
        [scoreLabel setString :[NSString stringWithFormat:@"Total Misses %i of %i", (totalObjects-totalHitCount),totalObjects]];
        [self addChild:scoreLabel z:1 tag:33];
 
        CCDelayTime *delay =  [CCDelayTime actionWithDuration:3];
        CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(removeSprite)];
        [self runAction:[CCSequence actions:delay, callFunc, nil]];
    }
}

-(void) initiateBackground:(NSString *)dynamicBackground {
    NSLog(@"background value is %@",dynamicBackground);
    NSString *background_plist = [dynamicBackground stringByAppendingString:@".plist"] ;
    NSString *background_spriteList = [dynamicBackground stringByAppendingString:@".png"];
    
    [self removeChildByTag:102 cleanup:YES];
    
    // Count the number of frames from the plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:dynamicBackground ofType:@"plist"];
    NSDictionary *Dictionary= [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    int numberOfFrames = [[Dictionary valueForKey:@"frames"] count];

    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: background_plist];
    backgroundSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:background_spriteList];
    NSMutableArray *backgroundFrames = [NSMutableArray array];
    
    for (int i=1; i < numberOfFrames; i++)
    {
        NSString *lastPart = [NSString stringWithFormat:@"_%d.png",i];
        NSString *animation_name = [dynamicBackground stringByAppendingString:lastPart];
        [backgroundFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animation_name]];
    }
    
    CCAnimation *backgroundDuration = [CCAnimation animationWithSpriteFrames:backgroundFrames delay:0.1f];
    NSString *frameName = [dynamicBackground stringByAppendingString:@"_1.png"];
    CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName:frameName];
    backgroundSprite.position = ccp(size.width/2, size.height/2);
    CCAction *backgroundAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:backgroundDuration]];
    
    [backgroundSprite runAction:backgroundAction];
    [backgroundSpriteSheet addChild:backgroundSprite];
    [self addChild:backgroundSpriteSheet z:-10 tag:102];
}

-(void) initiateIdleDance {
    NSString *danceMove = @"_i";
    NSString *player = [charHand.charName stringByAppendingString:danceMove];
    NSString *player_plist = [player stringByAppendingString:@".plist"] ;
    NSString *player_spriteList = [player stringByAppendingString:@".png"];
    
    [self removeChildByTag:1 cleanup:YES];
    [self removeChild:userSpriteSheet cleanup:YES];
    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: player_plist];
    userSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:player_spriteList];
    
    NSMutableArray *danceFrames = [NSMutableArray array];
    
    for (int i=1; i <= 63; i++) {
        NSString *lastPart = [NSString stringWithFormat:@"_%d.png",i];
        NSString *animation_name = [ player stringByAppendingString:lastPart];
        [danceFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animation_name]];
    }
    
    CCAnimation *danceDuration = [CCAnimation animationWithSpriteFrames:danceFrames delay:0.1f];
    
    NSString *frameName = [player stringByAppendingString:@"_1.png"];
    CCSprite *dance = [CCSprite spriteWithSpriteFrameName:frameName];
    dance.position = ccp(150,200);
    CCFiniteTimeAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:danceDuration] times:1];
    
    [dance runAction:[CCSequence actions: danceAction, [CCCallFunc actionWithTarget:self selector:@selector(initiateAIDance)],nil]];
    [userSpriteSheet addChild:dance];
    [self addChild:userSpriteSheet];
}

-(void) initiateUserDance {
    
    int num;
    NSString *danceMove;
    NSString *plistPath;
    NSString *player;
    do
    {
        num = arc4random()%6;
        //NSLog(@"Num is: %d",num);
        danceMove = [NSString stringWithFormat:@"_d%d",num];
        player = [charHand.charName stringByAppendingString:danceMove];
        plistPath = [[NSBundle mainBundle] pathForResource:player ofType:@"plist"];
    }
    while ([plistPath length]==0);
    
    //Count number of frames from plist
    NSDictionary *Dictionary= [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    int numberOfFrames = [[Dictionary valueForKey:@"frames"] count];
    
    if(numberOfFrames > 0)
    {
        // Remove previous player sprite and add the new dance sprite
        [self removeChildByTag:1 cleanup:YES];
        [self removeChildByTag:103 cleanup:YES];
        
        NSString *player_plist = [player stringByAppendingString:@".plist"] ;
        NSString *player_spriteList = [player stringByAppendingString:@".png"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: player_plist];
        userSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:player_spriteList];
        
        NSMutableArray *danceFrames = [NSMutableArray array];
        
        for (int i=1; i <= numberOfFrames; i++) {
            NSString *lastPart = [NSString stringWithFormat:@"_%d.png",i];
            NSString *animation_name = [ player stringByAppendingString:lastPart];
            [danceFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animation_name]];
        }
        
        CCAnimation *danceDuration = [CCAnimation animationWithSpriteFrames:danceFrames delay:0.1f];
        
        NSString *frameName = [player stringByAppendingString:@"_1.png"];
        CCSprite *dance = [CCSprite spriteWithSpriteFrameName:frameName];
        dance.position = ccp(225,175);
        if([charHand.charName isEqualToString:@"player_2"])
        dance.scale = 1.35;
        
        CCFiniteTimeAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:danceDuration] times:1];
        
        [dance runAction:[CCSequence actions: danceAction, [CCCallFunc actionWithTarget:self selector:@selector(initiateAIDance)],nil]];
        [userSpriteSheet addChild:dance];
        [self addChild:userSpriteSheet z:1 tag:103];
    }
    
    else
    {
        [self initiateAIDance];
    }
}

-(void) initiateAIDance {
    
    [self removeChildByTag:2 cleanup:YES];
    [self removeChildByTag:104 cleanup:YES];
    
    int num;
    NSString *danceMove;
    NSString *plistPath;
    NSString *aiPlayer;
    do
    {
        num = arc4random()%6;
        NSLog(@"Num is: %d",num);
        danceMove = [NSString stringWithFormat:@"_d%d",num];
        aiPlayer = [charHand.aiName stringByAppendingString:danceMove];
        plistPath = [[NSBundle mainBundle] pathForResource:aiPlayer ofType:@"plist"];
    }
    while ([plistPath length]==0);
    
    // Count the number of frames from the plist
    NSDictionary *Dictionary= [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    int numberOfFrames = [[Dictionary valueForKey:@"frames"] count];
    
    NSString *ai_plist=[aiPlayer stringByAppendingString:@".plist"];
    NSString *aiSheetName = [aiPlayer stringByAppendingString:@".png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:ai_plist];
    aiSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:aiSheetName];
    
    NSMutableArray *walkframes = [NSMutableArray array];
    
    for (int i = 1; i <=numberOfFrames; i++)
    {
        NSString *lastPart = [NSString stringWithFormat:@"_%d.png",i];
        NSString *animation_name = [aiPlayer stringByAppendingString:lastPart];
        [walkframes addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animation_name]];
    }
    
    CCAnimation *walk = [CCAnimation animationWithSpriteFrames:walkframes delay:0.1f];
    NSString *danceFrameName = [aiPlayer stringByAppendingString:@"_1.png"];
    CCSprite *dance = [CCSprite spriteWithSpriteFrameName:danceFrameName];
    dance.position = ccp(801, 175);
    dance.flipX = 180;
    if([charHand.aiName isEqualToString:@"player_2"])
    dance.scale = 1.35;
    
    CCAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walk] times:1];
    [dance runAction:danceAction];
    [aiSpriteSheet addChild:dance];
    [self addChild:aiSpriteSheet z:1 tag:104];
    [self scheduleOnce:@selector(gamePlayLoopCondition) delay:0.5];
    
    // this is to get the score for the AI player
    int aiscore = (int)(([getScore calScore]*100)/2100);
    
    // update AI progress bar
    if(self.aiLife >= 0 && self.aiLife < 100)
    {
        self.aiLife += aiscore;
        if(AIscoreLabel)
        
        if(self.aiLife > 100){
            self.aiLife = 100;
        }
        
            [self removeChildByTag:40 cleanup:YES];
        
        AIscoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:35];
        AIscoreLabel.position =CGPointMake(size.width - 290,size.height - 80);
        AIscoreLabel.color=ccc3(240, 255, 255);
        [AIscoreLabel setString :[NSString stringWithFormat:@"Score: %i", self.aiLife]];
        [self addChild:AIscoreLabel z:1 tag:40];

        
        [self.aiProgressTimer setSprite:[CCSprite spriteWithFile:@"health_bar.png"]];
        [self.aiProgressTimer setScale:0.3];
        [self.aiProgressTimer setPercentage:self.aiLife];
    }
}

-(void) loadHelloWorldLayer {
    
    InputHandler *ihvol = [sharedManager.inputBundle objectForKey:@"VOLCONTROL"];
    InputHandler *ihvolchanged = [sharedManager.inputBundle objectForKey:@"VOLCHANGED"];
    NSLog(@"vol object: %f", ihvol.volumeLevel);
    NSLog(ihvolchanged.checkvolumeAltered ? @"Yes" : @"No");
    
    if(ihvolchanged.checkvolumeAltered && ihvol.volumeLevel < 1.0) {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:ihvol.volumeLevel];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:ihvol.volumeLevel];
    }
    
    [[CCDirector sharedDirector] resume];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.2 scene:[HelloWorldLayer scene]]];
}

-(void) initiatePause {
    
    [self removeChildByTag:13 cleanup:YES];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    [pauseMenu runAction:[CCMoveTo actionWithDuration:0.75 position:ccp(size.width/2, size.height/2)]];
    [self performSelector:@selector(gamePause) withObject:nil afterDelay:0.80];
}

-(void) gamePause {

    [[CCDirector sharedDirector] pause];
}

-(void) gameRestart {
    
    [[CCDirector sharedDirector] resume];
    InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    [self removeAllChildrenWithCleanup:YES];
    if(ih2.gameLevelDifficulty == 1) {
        [self loadLevelEasy];
    } else if (ih2.gameLevelDifficulty == 2) {
        [self loadLevelMed];
    } else if(ih2.gameLevelDifficulty == 3) {
        [self loadLevelDif];
    }
    
    //    gameMenu = [CCMenu menuWithItems:buttonrestart, nil];
    //    [gameMenu alignItemsVertically];
    //    [gameMenu runAction:[CCMoveTo actionWithDuration:0.75 position:ccp(size.width/2, size.height/2)]];
    //    [self addChild:gameMenu z:1 tag:100];
    
    [pauseMenu runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(size.width/2,size.height+450)]];
}

-(void) gameResume {
    
    [[CCDirector sharedDirector] resume];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    pauseButton = [CCMenuItemImage itemWithNormalImage:@"pausegame.png" selectedImage:@"pausegame_pressed.png" target:self selector:@selector(initiatePause)];
    CCMenu *pauseButtonMenu = [CCMenu menuWithItems:pauseButton, nil];
    pauseButtonMenu.position = ccp(size.width - pauseButton.contentSize.width/2, pauseButton.contentSize.height/2);
    [self addChild:pauseButtonMenu z:1 tag:13];
    [pauseMenu runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(size.width/2,size.height+450)]];
}

-(void) manageTouchIcons {
    // Setting move difficulty
    NSString *moveDifficulty;
    InputHandler *ihMoveDiff = [sharedManager.inputBundle objectForKey:@"USERLIFE+MOVEDIFF"];
    if ([ihMoveDiff moveDifficulty] == 0){
        moveDifficulty = @"MoveDifficultyWt3";
    }
    else{
        moveDifficulty = [NSString stringWithFormat:@"MoveDifficultyWt%d",[ihMoveDiff moveDifficulty]];
    }
    
    // Reading from pList
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TouchPatterns" ofType:@"plist"];
    NSDictionary *Dictionary = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    
    // Reading move difficulties from pList
    NSDictionary *DictionaryMoveDifficulty = [Dictionary valueForKey:moveDifficulty];
    
    // Number of patterns in the current move difficulty
    int numberOfPatterns = [[Dictionary valueForKey:moveDifficulty] count];
    
    // Randomly select a pattern
    int lowerBound = 1;
    int upperBound = numberOfPatterns;
    int randomPattern = lowerBound + arc4random() % (upperBound - lowerBound);
    
    // Reading touch pattern from pList based on the randomly selected move
    NSDictionary *DictionaryMove = [DictionaryMoveDifficulty valueForKey:[NSString stringWithFormat:@"Move%d",randomPattern]];
    
    // Everytime allocate to avoid overlap
    singleTouches = [[NSArray alloc]init];
    doubleTouches = [[NSArray alloc]init];
    swipes = [[NSArray alloc]init];
    
    singleTouches = [[DictionaryMove valueForKey:@"SingleTouches"] componentsSeparatedByString:@","];
    doubleTouches = [[DictionaryMove valueForKey:@"DoubleTouches"] componentsSeparatedByString:@","];
    swipes = [[DictionaryMove valueForKey:@"Swipes"] componentsSeparatedByString:@","];
    
    totalGeneratedObjects = (singleTouches.count) + (doubleTouches.count*2) + (swipes.count*2);
    
    [self schedule:@selector(displayTouchIcons) interval:1.5 repeat:5 delay:speed];
}

-(void) displayTouchIcons {
    // to check if both the touch icons are tapped at the same time
    messageNice.visible = FALSE;
    messageAwesome.visible = FALSE;
    messageGreatMove.visible = FALSE;
    messageKeepShakin.visible = FALSE;
    messageDance.visible = FALSE;
    
    visited[1] = NO;
    visited[2] = NO;
    
    swipeHit = NO;
    
    // touchpointcounter starts with 0 and the Touches array start from 1, hence touchPointCounter+1
    for (int i = 0 ; i < singleTouches.count ; i++){
        if([singleTouches[i] intValue] == (touchPointCounter)){
            [self addTouchIcons:1 withArg2:@"touchpoints.png" withArg3:NO withArg4:NO];
            [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:1] afterDelay:speed];
            break;
        }
    }
    
    for (int i = 0 ; i < doubleTouches.count ; i++){
        if([doubleTouches[i] intValue] == (touchPointCounter)){
            [self addTouchIcons:1 withArg2:@"touchpoints-blue.png" withArg3:NO withArg4:NO];
            [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:1] afterDelay:speed];
            
            [self addTouchIcons:2 withArg2:@"touchpoints-blue.png" withArg3:NO withArg4:YES];
            [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:2] afterDelay:speed];
            break;
        }
    }
    
    for (int i = 0 ; i < swipes.count ; i++){
        if([swipes[i] intValue] == (touchPointCounter)){
            [self addTouchIcons:2 withArg2:@"touchpoints-blue.png" withArg3:NO withArg4:NO];
            [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:2] afterDelay:swipeSpeed];
            
            [self addTouchIcons:1 withArg2:@"touchpoints-green.png" withArg3:YES withArg4:NO];
            [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:1] afterDelay:swipeSpeed];
            break;
        }
    }
    
    // This is counter is for counting the number of times the touch icons will appear
    // It does not count the total number of touch icons.
    touchPointCounter++;
    
}

-(void) addTouchIcons:(int) touchNumber withArg2:(NSString *) fileName withArg3:(BOOL) swipeEnable withArg4:(BOOL) secondPoint {
    touchIcon[touchNumber] = [CCSprite spriteWithFile:fileName];
    swipeEnableGlobal = swipeEnable;
    
    // creating the imaginary rectangle in which the icons will appear
    float randomH,randomW;
    float maxX = size.width * 2/3;
    float minX = size.width * 1/3;
    float maxY,minY;
    if (secondPoint){
        maxY = yLocations[objectCount-1] + 100;
        minY = yLocations[objectCount-1] - 100;
    }else{
        maxY = size.height * 2/3;
        minY = size.height * 1/3;
    }
    float rangeX = maxX - minX;
    float rangeY = maxY - minY;
    
    // Show the first touch icon randomly
    if(objectCount == 0){
        randomH = (arc4random() % (int)rangeY) + (int)minY;
        randomW = (arc4random() % (int)rangeX) + (int)minX;
    }
    else{
        int halfOfTouchIcon = touchIcon[touchNumber].contentSize.width/2;
        float previousRangeXFrom = xLocations[objectCount-1]-(halfOfTouchIcon*2);
        float previousRangeXTo = xLocations[objectCount-1]+(halfOfTouchIcon*2);
        float previousRangeYFrom = yLocations[objectCount-1]-halfOfTouchIcon;
        float previousRangeYTo = yLocations[objectCount-1]+halfOfTouchIcon;
        
        // 10 attempts to find a better location for touch point
        for(int attempts = 0 ; attempts < 10 ; attempts ++){
            randomH = (arc4random() % (int)rangeY) + (int)minY;
            randomW = (arc4random() % (int)rangeX) + (int)minX;
            
            if((randomW < previousRangeXFrom || randomW > previousRangeXTo) && (randomH < previousRangeYFrom || randomH > previousRangeYTo)){
                break;
            }
        }
    }
    touchIcon[touchNumber].position = ccp(randomW, randomH);
    
    // these variables are used to store the location of the touch points to calculate the score
    xLocations[objectCount] = (float)randomW;
    yLocations[objectCount] = (float)randomH;
    
    // This is to enable swipe gesture on touch icon
    if(swipeEnable){
        touchIcon[touchNumber].isTouchEnabled = YES;
        [self enableGesture:[NSNumber numberWithInt:touchNumber]];
        
        //calculate position of the arrow and scale
        
        
        arrow = [CCSprite spriteWithFile:@"arrow.png"];
        CGPoint touchIconFirst,touchIconSecond;
        touchIconFirst.x = xLocations[objectCount-1];
        touchIconFirst.y = yLocations[objectCount-1];
        touchIconSecond.x = xLocations[objectCount];
        touchIconSecond.y = yLocations[objectCount];
        
        float dist = ccpDistance(touchIconFirst,touchIconSecond);
        float degrees = atan2(touchIconFirst.x - touchIconSecond.x , touchIconFirst.y - touchIconSecond.y)  * 180/3.14159265;
        if(degrees < 0) degrees+=360;
        int x,y;
        degrees += 270;
        
        
        if(xLocations[objectCount] > xLocations[objectCount-1] && yLocations[objectCount] > yLocations[objectCount-1]){
            //quad 1
             x = xLocations[objectCount-1] + abs((xLocations[objectCount] - xLocations[objectCount-1])/2);
             y = yLocations[objectCount-1] + abs((yLocations[objectCount] - yLocations[objectCount-1])/2);
        }
        if(xLocations[objectCount] > xLocations[objectCount-1] && yLocations[objectCount] < yLocations[objectCount-1]){
            //quad 4
            x = xLocations[objectCount-1] + abs((xLocations[objectCount] - xLocations[objectCount-1])/2);
            y = yLocations[objectCount-1] - abs((yLocations[objectCount] - yLocations[objectCount-1])/2);
        }
        if(xLocations[objectCount] < xLocations[objectCount-1] && yLocations[objectCount] > yLocations[objectCount-1]){
            //quad 2
            x = xLocations[objectCount-1] - abs((xLocations[objectCount] - xLocations[objectCount-1])/2);
            y = yLocations[objectCount-1] + abs((yLocations[objectCount] - yLocations[objectCount-1])/2);

        }
        if(xLocations[objectCount] < xLocations[objectCount-1] && yLocations[objectCount] < yLocations[objectCount-1]){
            //quad 3
            x = xLocations[objectCount-1] - abs((xLocations[objectCount] - xLocations[objectCount-1])/2);
            y = yLocations[objectCount-1] - abs((yLocations[objectCount] - yLocations[objectCount-1])/2);
        }
        arrow.position = ccp(x,y);
        NSLog(@" Degrees = %f ", degrees);
        arrow.rotation = degrees;
        arrow.scaleX = dist/arrow.boundingBox.size.width;
        [self addChild:arrow];
        
        
        
    }else{
        [self addChild:touchIcon[touchNumber]];
    }
    
    // Counts the number of objects in every round
    objectCount ++;
    
    // The total number of objects across all the round
    totalObjects ++;
}

-(void) removeTouchIcons:(NSNumber *) value {
    int val = [value intValue];
    [self removeChild:touchIcon[val] cleanup:YES];
    
    if(swipeEnableGlobal){
        [self removeChild:arrow cleanup:YES];
    }
    
    if(objectCount == totalGeneratedObjects){
        
        // Calculate the score and accuracy for user and ai
        InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
        
        [ih2 setUserAccuracy:(hitCount*100/objectCount)];
        [sharedManager.inputBundle setObject:ih2 forKey:@"USERACC"];
        
        getScore = [[Score alloc] init];
        [getScore calScore];
        
        [self updateUserProgressBar];
    }
}

-(void) updateUserProgressBar {
    InputHandler *ih3 = [sharedManager.inputBundle objectForKey:@"USERLIFE+MOVEDIFF"];
    
    // Increment progress bar for user
    if(self.life >= 0 && self.life < 100){

        self.life += (int)([ih3 userLife]/(1.83));
    
        //self.life += (int)[ih3 userLife];
        
        if(self.life > 100){
            self.life = 100;
        }
        
        if(UserScoreLabel)
            [self removeChildByTag:41 cleanup:YES];
        
        UserScoreLabel = [CCLabelTTF labelWithString:@"%d" fontName:@"Papyrus" fontSize:35];
        UserScoreLabel.position =CGPointMake(290,size.height - 80);
        UserScoreLabel.color=ccc3(240, 255, 255);
        [UserScoreLabel setString :[NSString stringWithFormat:@"Score: %i", self.life]];
        [self addChild:UserScoreLabel z:1 tag:41];

        
        [self.progressTimer setSprite:[CCSprite spriteWithFile:@"health_bar.png"]];
        [self.progressTimer setScale:0.3];
        [self.progressTimer setPercentage:self.life];
        }
      [self initiateUserDance];
    
}

-(void) enableGesture:(NSNumber *) value {
    // pan gesture recognizer
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    [touchIcon[[value intValue]] addGestureRecognizer:panGestureRecognizer];
    [self addChild:touchIcon[[value intValue]]];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void) handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer {
    CCNode *node = aPanGestureRecognizer.node;
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
    
    node.position = ccpAdd(node.position, translation);
    
    // this is to check if the touch gesture has been through the other point
    
    if(CGRectContainsPoint(touchIcon[1].boundingBox, ccp(touchIcon[2].position.x,touchIcon[2].position.y)) && !swipeHit){
        swipeHit = YES;
        totalHitCount = totalHitCount + 1;
        
        touchIcon[1].visible = FALSE;
        touchIcon[2].visible = FALSE;
        arrow.visible = FALSE;
        
        // Particle effects on a gesture hit
        [self showBlastEffect:touchIcon[2].position];
        
        if(self.life >= 0 && self.life < 100){
            self.life += 1;
            if(self.life > 25 && self.life < 60){
                [self.progressTimer setSprite:[CCSprite spriteWithFile:@"health_bar.png"]];
                [self.progressTimer setScale:0.3];
            }
            if(self.life > 60){
                [self.progressTimer setSprite:[CCSprite spriteWithFile:@"health_bar.png"]];
                [self.progressTimer setScale:0.3];
            }
        }
        [self.progressTimer setPercentage:self.life];
    }
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for(UITouch *touch in touches)
    {
        CGPoint location = [[CCDirector sharedDirector] convertTouchToGL:touch];
        
        if((CGRectContainsPoint(touchIcon[1].boundingBox, location)) && visited[1] == NO) {
            visited[1] = YES;
            hitCount++;
            totalHitCount++;
            touchIcon[1].visible = FALSE;
            //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            [self showBlastEffect:touchIcon[1].position];
        }
        if((CGRectContainsPoint(touchIcon[2].boundingBox, location)) && visited[2] == NO) {
            visited[2] = YES;
            hitCount++;
            totalHitCount++;
            touchIcon[2].visible = FALSE;
            //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            [self showBlastEffect:touchIcon[2].position];
        }
    }
    
    // Check If Both Hit = 0;
    if(visited[1] == YES && visited[2] == YES){
        // Generate random message
        int num = arc4random()%5;
        switch (num) {
            case 1:
                messageNice.visible = TRUE;
                break;
            case 2:
                messageAwesome.visible = TRUE;
                break;
            case 3:
                messageGreatMove.visible = TRUE;
                break;
            case 4:
                messageKeepShakin.visible = TRUE;
                break;
                
            default:
                break;
        }
        
        [self performSelector:@selector(removeMessage) withObject:[NSNumber numberWithInt:1] afterDelay:removeMessageSpeed];
    }
}

-(void) showBlastEffect:(CGPoint) location {
    // Some animation where the icon is generated
    CCParticleSystem *emitter = [CCParticleExplosion node];
    //set the location of the emitter
    emitter.position = location;
    //set size of particle animation
    emitter.scale = 0.5;
    //set an Image for the particle
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"music_note.png"];
    //set length of particle animation
    [emitter setLife:0.08f];
    //add to layer ofcourse(effect begins after this step)
    [self addChild: emitter];
}

-(void) loadLevelEasy {
    le.background = [CCSprite spriteWithFile:@"background_1_1.png"];
    le.backgroundName = [NSString stringWithFormat:@"background_1"];
    le.backgroundMusic = [NSString stringWithFormat:@"madrid.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    
    [self performSelector:@selector(loadGameLayer)];
}

-(void) loadLevelMed {
    
    InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    le.background = [CCSprite spriteWithFile:@"background_2_1.png"];
    le.backgroundName = [NSString stringWithFormat:@"background_2"];
    le.backgroundMusic = [NSString stringWithFormat:@"losangeles.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    ih2.gameLevelDifficulty=2;
    
    [self performSelector:@selector(loadGameLayer)];
}

-(void) loadLevelDif {
    
    InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    le.background = [CCSprite spriteWithFile:@"background_3_1.png"];
    le.backgroundName = [NSString stringWithFormat:@"background_3"];
    le.backgroundMusic = [NSString stringWithFormat:@"bombay.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    ih2.gameLevelDifficulty=3;
    
    [self performSelector:@selector(loadGameLayer)];
}

-(void) loadGameLayer {
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    CCScene *gameLevel = [GameLevelLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:gameLevel]];
}

-(void) changeGameLayer {
 
    InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    CCMenuItemImage *buttonLevel1;
    
    if(ih2.gameLevelDifficulty == 1) {
        buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"next.png" selectedImage:@"next_pressed.png" target:self selector:@selector(loadLevelMed)];
    } else if (ih2.gameLevelDifficulty == 2) {
        buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"next.png" selectedImage:@"next_pressed.png" target:self selector:@selector(loadLevelDif)];
    }
    
    CCMenuItemImage *mainbutton = [CCMenuItemImage itemWithNormalImage:@"main-menu.png" selectedImage:@"main-menu_pressed.png" target:self selector:@selector(loadHelloWorldLayer)];
    
    if (ih2.gameLevelDifficulty == 1 || ih2.gameLevelDifficulty == 2) {
        gameMenu = [CCMenu menuWithItems:buttonLevel1, mainbutton, nil];
    } else if (ih2.gameLevelDifficulty == 3) {
        gameMenu = [CCMenu menuWithItems:mainbutton, nil];
    }

    [gameMenu alignItemsVertically];

    //gameMenu.position = ccp(size.width/2, size.height);
    [gameMenu runAction:[CCMoveTo actionWithDuration:0.75 position:ccp(size.width/2, size.height/2)]];
    [self addChild:gameMenu z:1 tag:100];
    
}

-(void) playSameGameLayer {

    InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    CCMenuItemImage *buttonLevel1;
    
    if(ih2.gameLevelDifficulty == 1) {
        buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay_pressed.png" target:self selector:@selector(loadLevelEasy)];
    } else if (ih2.gameLevelDifficulty == 2) {
        buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay_pressed.png" target:self selector:@selector(loadLevelMed)];
    } else if(ih2.gameLevelDifficulty == 3) {
        buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay_pressed.png" target:self selector:@selector(loadLevelDif)];
    }
    
    CCMenuItemImage *mainbutton = [CCMenuItemImage itemWithNormalImage:@"main-menu.png" selectedImage:@"main-menu_pressed.png" target:self selector:@selector(loadHelloWorldLayer)];
    
    gameMenu = [CCMenu menuWithItems:buttonLevel1, mainbutton, nil];
    [gameMenu alignItemsVertically];
    [gameMenu runAction:[CCMoveTo actionWithDuration:0.75 position:ccp(size.width/2, size.height/2)]];
    [self addChild:gameMenu z:1 tag:100];
}

-(void) winGame {
    [self addMessage:@"youwin.png"];
}

-(void) winGameRemove {
    [self removeMessage];
}

-(void) loseGame {
    [self addMessage:@"youlose.png"];
}

-(void) loseGameRemove {
    [self removeMessage];
}

-(void) removeSprite {
    [self removeChildByTag:31 cleanup:YES];
    [self removeChildByTag:32 cleanup:YES];
    [self removeChildByTag:33 cleanup:YES];
    [self removeChildByTag:30 cleanup:YES];

}

-(void) dealloc {
    
}

@end

//
//  LevelSelectLayer.m
//  Dance Wars
//
//  Created by Prayaas Jain on 9/27/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "LevelSelectLayer.h"

@implementation LevelSelectLayer


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSelectLayer *layer = [LevelSelectLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    
    if((self = [super initWithColor:ccc4(0, 0, 0, 0)])) {
        sharedManager = [MyManager sharedManager];
        
        ih = [[InputHandler alloc] init];
        
        // Initializing level env
        le = [[LevelEnvironment alloc]init];
        
        size = [[CCDirector sharedDirector] winSize];
        
        // Add background image
        CCSprite *levelBg = [CCSprite spriteWithFile:@"levelselect_bg.png"];
        levelBg.position = ccp(size.width/2, size.height/2);
        [self addChild:levelBg];
        
        // Level header
        label = [CCSprite spriteWithFile:@"select_difficulty.png"];
        label.position = ccp(size.width/2, 775);
        [self addChild:label];
        
        // menu to create different levels of difficulty
        CCMenuItemImage *buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"difficulty_level_1.png" selectedImage:@"difficulty_level_1_pressed.png" target:self selector:@selector(loadLevelEasy)];
        CCMenuItemImage *buttonLevel2 = [CCMenuItemImage itemWithNormalImage:@"difficulty_level_2.png" selectedImage:@"difficulty_level_2_pressed.png" target:self selector:@selector(loadLevelMed)];
        CCMenuItemImage *buttonLevel3 = [CCMenuItemImage itemWithNormalImage:@"difficulty_level_3.png" selectedImage:@"difficulty_level_3_pressed.png" target:self selector:@selector(loadLevelDif)];
        
        gameMenu = [CCMenu menuWithItems:buttonLevel1, buttonLevel2, buttonLevel3, nil];
        NSNumber* itemsPerRow = [NSNumber numberWithInt:3];
        [gameMenu alignItemsInColumns:itemsPerRow, itemsPerRow, itemsPerRow, nil];
        gameMenu.position = ccp(size.width/2, size.height/3);
        
        [self addChild:gameMenu];
        
        // Adds a button after the game is over to return to the main menu
        CCMenuItemImage *homeButton = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home_pressed.png" target:self selector:@selector(loadHome)];
        CCMenu *homeMenu = [CCMenu menuWithItems:homeButton, nil];
        homeMenu.position = ccp(size.width - homeButton.contentSize.width/2, homeButton.contentSize.height/2);
        [self addChild:homeMenu];
        
        [self displayMenuElements];
    }
    return self;
}

- (void) displayMenuElements {
    [label runAction:[CCMoveTo actionWithDuration:1 position:ccp(size.width/2, size.height*3/4)]];
}

-(void) loadHome {
    CCScene *home = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:home]];
}

- (void) loadLevelEasy {
    [ih setGameLevelDifficulty:1];
    
    [sharedManager.inputBundle setObject:ih forKey:@"LDAA"];
    
    le.background = [CCSprite spriteWithFile:@"background_1_1.png"];
    le.backgroundName = [NSString stringWithFormat:@"background_1"];
    le.backgroundMusic = [NSString stringWithFormat:@"madrid.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    [self performSelector:@selector(loadGameLayer)];
}

- (void) loadLevelMed {
    [ih setGameLevelDifficulty:2];

    [sharedManager.inputBundle setObject:ih forKey:@"LDAA"];
    
    le.background = [CCSprite spriteWithFile:@"background_2_1.png"];
    le.backgroundName = [NSString stringWithFormat:@"background_2"];
    le.backgroundMusic = [NSString stringWithFormat:@"losangeles.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    [self performSelector:@selector(loadGameLayer)];
}

- (void) loadLevelDif {    
    [ih setGameLevelDifficulty:3];

    [sharedManager.inputBundle setObject:ih forKey:@"LDAA"];
    
    le.background = [CCSprite spriteWithFile:@"background_3_1.png"];
    le.backgroundName = [NSString stringWithFormat:@"background_3"];
    le.backgroundMusic = [NSString stringWithFormat:@"bombay.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    [self performSelector:@selector(loadGameLayer)];
}

-(void)onExit{
    [self removeChild:gameMenu cleanup:YES];
}

- (void) loadGameLayer {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    CCScene *gameLevel = [GameLevelLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:gameLevel]];
}
@end

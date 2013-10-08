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
        
        // initializing level env
        le = [[LevelEnvironment alloc]init];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Select Your Level of Difficulty" fontName:@"Papyrus" fontSize:50];
        label.position = ccp(size.width/2, size.height*3/4);
        [self addChild:label];
        
        // menu to create different levels of difficulty
        CCMenuItemImage *buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"i_love_clubbing_heart.png" selectedImage:@"i_love_clubbing_heart.png" target:self selector:@selector(loadLevelEasy)];
        CCMenuItemImage *buttonLevel2 = [CCMenuItemImage itemWithNormalImage:@"i_love_dancing_heart.png" selectedImage:@"i_love_dancing_heart.png" target:self selector:@selector(loadLevelMed)];
        CCMenuItemImage *buttonLevel3 = [CCMenuItemImage itemWithNormalImage:@"i_love_disco.png" selectedImage:@"i_love_disco.png" target:self selector:@selector(loadLevelDif)];
        
        CCMenuItemImage *buttonLevel4 = [CCMenuItemImage itemWithNormalImage:@"i_love_music.png" selectedImage:@"i_love_music.png" target:self selector:@selector(loadLevelDif)];
        
        CCMenu *gameMenu = [CCMenu menuWithItems:buttonLevel1, buttonLevel2, buttonLevel3, buttonLevel4, nil];
        NSNumber* itemsPerRow = [NSNumber numberWithInt:4];
        [gameMenu alignItemsInColumns:itemsPerRow, itemsPerRow, itemsPerRow, nil];
        gameMenu.position = ccp(size.width/2, size.height/3);
        
        [self addChild:gameMenu];
        
        // this adds a button after the game is over to return to the main menu
        CCMenuItemImage *homeButton = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home_pressed.png" target:self selector:@selector(loadHome)];
        CCMenu *homeMenu = [CCMenu menuWithItems:homeButton, nil];
        homeMenu.position = ccp(size.width - homeButton.contentSize.width/2, homeButton.contentSize.height/2);
        [self addChild:homeMenu];

    }
    return self;
}

-(void) loadHome {
    CCScene *gameLevel = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.2 scene:gameLevel]];
}

- (void) loadLevelEasy {
    [ih setGameLevelDifficulty:1];
    
    [sharedManager.inputBundle setObject:ih forKey:@"LDAA"];
    
    le.background = [CCSprite spriteWithFile:@"bombay.png"];
    le.backgroundMusic = [NSString stringWithFormat:@"bombay.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    [self performSelector:@selector(loadGameLayer)];
}

- (void) loadLevelMed {
    [ih setGameLevelDifficulty:2];

    [sharedManager.inputBundle setObject:ih forKey:@"LDAA"];
    
    le.background = [CCSprite spriteWithFile:@"losangeles.png"];
    le.backgroundMusic = [NSString stringWithFormat:@"losangeles.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    [self performSelector:@selector(loadGameLayer)];
}

- (void) loadLevelDif {    
    [ih setGameLevelDifficulty:3];

    [sharedManager.inputBundle setObject:ih forKey:@"LDAA"];
    
    le.background = [CCSprite spriteWithFile:@"madrid.png"];
    le.backgroundMusic = [NSString stringWithFormat:@"madrid.mp3"];
    
    [sharedManager.inputBundle setObject:le forKey:@"ENVR"];
    [self performSelector:@selector(loadGameLayer)];
}

- (void) loadGameLayer {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    CCScene *gameLevel = [GameLevelLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:gameLevel]];
}
@end

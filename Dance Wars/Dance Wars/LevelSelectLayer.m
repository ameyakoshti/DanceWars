//
//  LevelSelectLayer.m
//  Dance Wars
//
//  Created by Prayaas Jain on 9/27/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "LevelSelectLayer.h"
#import "GameLevelLayer.h"


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
        ih = [[InputHandler alloc] init];
        
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
    }
    return self;
}

- (void) loadLevelEasy {
    
    [ih setGameLevelDifficulty:1];
    [ih setAiAccuracy:30];
    [gll setBackground:@"level_bg.jpg"];
    NSLog(@"Level Difficulty set to %d", [ih gameLevelDifficulty]);
    NSLog(@"Level Difficulty set to %d", [ih aiAccuracy]);
    [self performSelector:@selector(loadGameLayer)];
    
}

- (void) loadLevelMed {
    
    [ih setGameLevelDifficulty:2];
    [ih setAiAccuracy:60];
    [gll setBackground:@"level_bg.jpg"];
    NSLog(@"Level Difficulty set to %d", [ih gameLevelDifficulty]);
    [self performSelector:@selector(loadGameLayer)];
    
}

- (void) loadLevelDif {
    
    [ih setGameLevelDifficulty:3];
    [ih setAiAccuracy:90];
    [gll setBackground:@"level_bg.jpg"];
    NSLog(@"Level Difficulty set to %d", [ih gameLevelDifficulty]);
    [self performSelector:@selector(loadGameLayer)];
    
}

- (void) loadGameLayer {
    
    CCScene *gameLevel = [GameLevelLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:gameLevel]];
}
@end

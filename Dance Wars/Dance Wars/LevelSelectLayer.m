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
    
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Select Your Level of Difficulty" fontName:@"Papyrus" fontSize:50];
        label.position = ccp(size.width/2, size.height*3/4);
        [self addChild:label];
        
        CCMenuItemImage *buttonLevel1 = [CCMenuItemImage itemWithNormalImage:@"level_button1.png" selectedImage:@"level_button1_pressed.png" target:self selector:@selector(loadGameLayer)];
        CCMenuItemImage *buttonLevel2 = [CCMenuItemImage itemWithNormalImage:@"level_button2.png" selectedImage:@"level_button2_pressed.png" target:self selector:@selector(loadGameLayer)];
        CCMenu *gameMenu = [CCMenu menuWithItems:buttonLevel1, buttonLevel2, nil];
        gameMenu.position = ccp(size.width/2, size.height/3);
        
        [self addChild:gameMenu];
        
        
    }
    return self;
}

- (void) loadGameLayer {
    
    CCScene *gameLevel = [GameLevelLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.0 scene:gameLevel]];
    
}



@end

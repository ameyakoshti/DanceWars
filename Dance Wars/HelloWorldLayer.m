//
//  HelloWorldLayer.m
//  Dance Wars
//
//  Created by Prayaas Jain on 9/20/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "GameLevelLayer.h"
#import "CharacterSelect.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// initialize here
-(id) init {
    
    if((self = [super initWithColor:ccc4(0, 0, 0, 0)])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *levelBg = [CCSprite spriteWithFile:@"home_bg.jpg"];
        levelBg.position = ccp(size.width/2, size.height/2);
        
        [self addChild:levelBg];
        
        CCSprite *introName = [CCSprite spriteWithFile:@"intro_name.png"];
        introName.position = ccp(size.width/2, size.height*3/4);
                
        CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"play_button.png" selectedImage:@"play_button_pressed.png" target:self selector:@selector(loadCharacterSelectLayer)];
        CCMenu *gameMenu = [CCMenu menuWithItems:playButton, nil];
        gameMenu.position = ccp(size.width/2, size.height/4);
        
        [self addChild:introName];
        [self addChild:gameMenu];
        
    }
    
    return self;
}

- (void) loadCharacterSelectLayer {
    CCScene *charSelect = [CharacterSelect scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:charSelect]];
}

@end

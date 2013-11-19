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
#import "OptionsSelectLayer.h"

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
        
        size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *levelBg = [CCSprite spriteWithFile:@"background_main.png"];
        levelBg.position = ccp(size.width/2, size.height/2);
        
        [self addChild:levelBg];
        
        introName = [CCSprite spriteWithFile:@"dance_wars_label.png"];
        introName.position = ccp(size.width/2, size.height + introName.contentSize.height);
        
        CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"play_button.png" selectedImage:@"play_button_pressed.png" target:self selector:@selector(loadCharacterSelectLayer)];
        CCMenuItemImage *optionsButton = [CCMenuItemImage itemWithNormalImage:@"options.png" selectedImage:@"options_pressed.png" target:self selector:@selector(loadOptionsLayer)];

        MainMenu = [CCMenu menuWithItems:playButton, optionsButton, nil];
        MainMenu.position = ccp(0 - MainMenu.contentSize.width, size.height - MainMenu.contentSize.height/2);
        [MainMenu alignItemsVertically];
    
        
        [self addChild:introName];
        [self addChild:MainMenu];
        [self displayMenuElements];
    }
    
    return self;
}

- (void) displayMenuElements {
    [MainMenu runAction:[CCMoveTo actionWithDuration:1 position:ccp(440, 260)]];

}

- (void) loadCharacterSelectLayer {
    [[SimpleAudioEngine sharedEngine] playEffect:@"drum.mp3"];
    CCScene *charSelect = [CharacterSelect scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:charSelect]];
}

- (void) loadOptionsLayer {
    CCScene *optionsSelect = [OptionsSelectLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:optionsSelect]];
}


@end

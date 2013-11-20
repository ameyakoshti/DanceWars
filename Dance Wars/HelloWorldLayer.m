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
        
        CCSprite *levelBg = [CCSprite spriteWithFile:@"main_menu_background.png"];
        levelBg.position = ccp(size.width/2, size.height/2);
        
        [self addChild:levelBg];
        
        introName = [CCSprite spriteWithFile:@"dance-wars_text.png"];
        introName.position = ccp(size.width/2, size.height + introName.contentSize.height);
        
        playLabel = [CCSprite spriteWithFile:@"play_label.png"];
        playLabel.position = ccp(0 - playLabel.contentSize.width, size.height - playLabel.contentSize.height/2);
        
        settingsLabel = [CCSprite spriteWithFile:@"settings_label.png"];
        settingsLabel.position = ccp(0 - settingsLabel.contentSize.width, size.height - settingsLabel.contentSize.height/2);
        
        CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"play.png" selectedImage:@"play_pressed.png" target:self selector:@selector(loadCharacterSelectLayer)];
        CCMenuItemImage *optionsButton = [CCMenuItemImage itemWithNormalImage:@"settings.png" selectedImage:@"settings_pressed.png" target:self selector:@selector(loadOptionsLayer)];

        MainMenuPlay = [CCMenu menuWithItems:playButton, nil];
        MainMenuSettings = [CCMenu menuWithItems:optionsButton, nil];
        MainMenuPlay.position = ccp(445, 302);
        MainMenuSettings.position = ccp(550, 188);
        
        [self addChild:introName];
        [self addChild:MainMenuPlay];
        [self addChild:MainMenuSettings];
        [self addChild:playLabel];
        [self addChild:settingsLabel];
        [self displayMenuElements];
    }
    
    return self;
}

- (void) displayMenuElements {
    [playLabel runAction:[CCMoveTo actionWithDuration:1 position:ccp(445, 350)]];
    [settingsLabel runAction:[CCMoveTo actionWithDuration:1 position:ccp(550, 140)]];
    [introName runAction:[CCMoveTo actionWithDuration:1 position:ccp(size.width/2, 650)]];

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

-(void)onExit{
    [self removeChild:MainMenuPlay cleanup:YES];
    [self removeChild:MainMenuSettings cleanup:YES];
}

@end

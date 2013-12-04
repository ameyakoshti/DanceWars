//
//  OptionsSelectLayer.m
//  Dance Wars
//
//  Created by Arnab Banik on 11/9/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "OptionsSelectLayer.h"
#import "CCControlExtension.h"


@implementation OptionsSelectLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OptionsSelectLayer *layer = [OptionsSelectLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if((self = [super init])) {
        
        windowSize = [[CCDirector sharedDirector] winSize];
        
        // Add background image
        CCSprite *charBg = [CCSprite spriteWithFile:@"settings_screen_bg.png"];
        charBg.position = ccp(windowSize.width/2, windowSize.height/2);
        [self addChild:charBg];
        
        //add labels for settings and volume
        settingsLabel = [CCSprite spriteWithFile:@"settings_text.png"];
        settingsLabel.position = ccp(windowSize.width/2, windowSize.height + settingsLabel.contentSize.height);
        
        volumeLabel = [CCSprite spriteWithFile:@"volume_text.png"];
        volumeLabel.position = ccp(0 - volumeLabel.contentSize.width, windowSize.height - volumeLabel.contentSize.height/2);
        
        
        // Create the slider
        CCControlSlider *slider = [CCControlSlider sliderWithBackgroundFile:@"slidebar2_bg.png" progressFile:@"slider2_filler.png" thumbFile:@"slider2_sliderButton.png"];
        slider.minimumValue = 0.0f; // Sets the min value of range
        slider.maximumValue = 1.0f; // Sets the max value of range
        slider.position = ccp(windowSize.width/2, windowSize.height*3/5);
        
        // When the value of the slider will change, the given selector will be call
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:CCControlEventValueChanged];
        
        [self addChild:slider];
        
        CCMenuItemImage *homeButton = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home_pressed.png" target:self selector:@selector(loadHelloWorldLayer11)];
        CCMenu *goHome = [CCMenu menuWithItems:homeButton, nil];
        goHome.position = ccp(windowSize.width - homeButton.contentSize.width/2, homeButton.contentSize.height/2);
        [self addChild:goHome];
        
        [self addChild:settingsLabel];
        [self addChild:volumeLabel];
        [self displaySettingsElements];
    }
    return self;
}

- (void) displaySettingsElements {
    [volumeLabel runAction:[CCMoveTo actionWithDuration:1 position:ccp(300, windowSize.height*7/10)]];
    [settingsLabel runAction:[CCMoveTo actionWithDuration:1 position:ccp(windowSize.width/2, 675)]];
}

- (void)valueChanged:(CCControlSlider *)sender
{
    ih = [[InputHandler alloc]init];
    ih2 = [[InputHandler alloc]init];
    // Change volume of your sounds
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:sender.value];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:sender.value];
    
    [ih setVolumeLevel:sender.value];
    [ih2 setCheckvolumeAltered:TRUE];
    sharedManager = [MyManager sharedManager];
    [sharedManager.inputBundle setObject:ih forKey:@"VOLCONTROL"];
    [sharedManager.inputBundle setObject:ih2 forKey:@"VOLCHANGED"];
    
}

//-(void) loadHelloWorldLayer {
//        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.2 scene:[HelloWorldLayer scene]]];
//}

- (void) loadHelloWorldLayer11 {
    CCScene *helloworldSelect = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:helloworldSelect]];
    
}

@end

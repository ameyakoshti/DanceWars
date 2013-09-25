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
        
//        CCLabelTTF *welcomeLabel = [CCLabelTTF labelWithString:@"DANCE WARS" fontName:@"Papyrus" fontSize:100];
//        welcomeLabel.position = ccp(size.width/2, size.height*2/3);
        
        CCSprite *introName = [CCSprite spriteWithFile:@"intro_name.png"];
        introName.position = ccp(size.width/2, size.height*2/3);
                
        CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"play_button.png" selectedImage:@"play_button.png" target:self selector:@selector(loadGameLayer)];
        CCMenu *gameMenu = [CCMenu menuWithItems:playButton, nil];
        gameMenu.position = ccp(size.width/2, size.height/3);
        
        [self addChild:introName];
        [self addChild:gameMenu];
        
    }
    
    return self;
}

- (void) loadGameLayer {
    
    CCScene *gameLevel = [GameLevelLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:2.0 scene:gameLevel]];
    
}

@end

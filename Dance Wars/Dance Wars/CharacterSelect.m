//
//  CharacterSelect.m
//  Dance Wars
//
//  Created by Prayaas Jain on 9/27/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "CharacterSelect.h"
#import "LevelSelectLayer.h"


@implementation CharacterSelect

@synthesize charSpriteList,num;


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	CharacterSelect *layer = [CharacterSelect node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init {
    
    if((self = [super init])) {
        
        windowSize = [[CCDirector sharedDirector] winSize];
        
        charSpriteList = [[NSMutableArray alloc] init];
        
        ch = [[CharacterHandler alloc] init];
        
        // Add background image
        CCSprite *charBg = [CCSprite spriteWithFile:@"characterselect_bg.png"];
        charBg.position = ccp(windowSize.width/2, windowSize.height/2);
        [self addChild:charBg];
        
        // Character header
        label = [CCSprite spriteWithFile:@"select_character_bg.png"];
        label.position = ccp(windowSize.width/2, 775);
        [self addChild:label];
        
        CCMenuItemImage *characterOne = [CCMenuItemImage itemWithNormalImage:@"player_1.png" selectedImage:@"player_1_pressed.png" target:self selector:@selector(selectCharacterOne)];
        CCMenuItemImage *characterTwo = [CCMenuItemImage itemWithNormalImage:@"player_2.png" selectedImage:@"player_2_pressed.png" target:self selector:@selector(selectCharacterTwo)];
        CCMenuItemImage *characterThree = [CCMenuItemImage itemWithNormalImage:@"player_3.png" selectedImage:@"player_3_pressed.png" target:self selector:@selector(selectCharacterThree)];
        CCMenuItemImage *characterFour = [CCMenuItemImage itemWithNormalImage:@"player_4.png" selectedImage:@"player_4_pressed.png" target:self selector:@selector(selectCharacterFour)];
        
        MainMenu = [CCMenu menuWithItems:characterOne, characterTwo, characterThree, characterFour, nil];
        MainMenu.position = ccp(windowSize.width/2,300);
        NSNumber* itemsPerRow = [NSNumber numberWithInt:2];
        [MainMenu alignItemsInColumns:itemsPerRow, itemsPerRow, itemsPerRow, nil];
        //[MainMenu alignItemsHorizontally];
        
        [self addChild:MainMenu];
        
        // Adding player 1 in the player selection menu
        NSString *charPath = @"player_1.png";
        [self addSprite:charPath];
        
        // Adding player 2 in the player selection menu
        charPath = @"player_2.png";
        [self addSprite:charPath];
        
        // Adding player 3 in the player selection menu
        charPath = @"player_3.png";
        [self addSprite:charPath];
        
        // Adding player 4 in the player selection menu
        charPath = @"player_4.png";
        [self addSprite:charPath];
        
        
        // Adds a button after the game is over to return to the main menu
        CCMenuItemImage *homeButton = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home_pressed.png" target:self selector:@selector(loadHome)];
        CCMenu *homeMenu = [CCMenu menuWithItems:homeButton, nil];
        homeMenu.position = ccp(windowSize.width - homeButton.contentSize.width/2, homeButton.contentSize.height/2);
        [self addChild:homeMenu];
        
        [self displayMenuElements];
    }
    return self;
}

- (void) displayMenuElements {
    [label runAction:[CCMoveTo actionWithDuration:1 position:ccp(windowSize.width/2, 650)]];
}

-(void)onExit{
    [self removeChild:MainMenu cleanup:YES];
    //[self removeChild:[self getChildByTag:MainMenu] cleanup:YES];
}

-(void) loadHome {
    CCScene *home = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:home]];
}

- (CCSprite *) addSprite:(NSString *)spritePath {
    
    [ch setCharacter:[CCSprite spriteWithFile:spritePath]];
    [ch setSelected:@"0"];
    
    NSString *name = [NSString stringWithFormat:@"%@", spritePath];
    [ch setCharName:name];
    
    [charSpriteList addObject:ch];
    return ch.character;
}

- (void) selectCharacterOne {

    for(CharacterHandler *ch2 in charSpriteList) {
        BOOL playerSelected = false;
        
        // creating manual frames for individual players
        
        // Frame for player 1 selection
       
        playerSelected = TRUE;
        [ch2 setSelected:@"1"];
        if([ch2.selected  isEqual: @"1"]){
            NSString *name = [NSString stringWithFormat:@"player_1"];
            [ch setCharName:name];
            do
            {
                num=arc4random()%5;
            }while(num==0 || num==1);
            NSString *aiName = [NSString stringWithFormat:@"player_%d",num];
            [ch setAiName:aiName];
        }
        
        sharedManager = [MyManager sharedManager];
        [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
        
        if(playerSelected){
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:levelSelect]];
        }
    }
}

- (void) selectCharacterTwo {
    for(CharacterHandler *ch2 in charSpriteList) {
        BOOL playerSelected = false;

        // Frame for player 2 selection
        
        playerSelected = TRUE;
        [ch2 setSelected:@"2"];
        if([ch2.selected  isEqual: @"2"]){
            NSString *name = [NSString stringWithFormat:@"player_2"];
            [ch setCharName:name];
            do
            {
                num=arc4random()%5;
            }while(num==0 || num==2);
            NSString *aiName = [NSString stringWithFormat:@"player_%d",num];
            [ch setAiName:aiName];

        }
        
        sharedManager = [MyManager sharedManager];
        [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
        
        if(playerSelected){
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:levelSelect]];
        }
    }
}

- (void) selectCharacterThree {
    for(CharacterHandler *ch2 in charSpriteList) {
        BOOL playerSelected = false;
        
        // Frame for player 3 selection
        
        playerSelected = TRUE;
        [ch2 setSelected:@"3"];
        if([ch2.selected  isEqual: @"3"]){
            NSString *name = [NSString stringWithFormat:@"player_3"];
            [ch setCharName:name];
            do
            {
                num=arc4random()%5;
            }while(num==0 || num==3);
            NSString *aiName = [NSString stringWithFormat:@"player_%d",num];
            [ch setAiName:aiName];
        }
        
        sharedManager = [MyManager sharedManager];
        [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
        
        if(playerSelected){
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:levelSelect]];
        }
    }
}

- (void) selectCharacterFour {
    for(CharacterHandler *ch2 in charSpriteList) {
        BOOL playerSelected = false;
        
        // Frame for player 4 selection
        
        playerSelected = TRUE;
        [ch2 setSelected:@"4"];
        if([ch2.selected  isEqual: @"4"]){
            NSString *name = [NSString stringWithFormat:@"player_4"];
            [ch setCharName:name];
            do
            {
                num=arc4random()%5;
            }while(num==0 || num==4);
            NSString *aiName = [NSString stringWithFormat:@"player_%d",num];
            [ch setAiName:aiName];
        }
        
        sharedManager = [MyManager sharedManager];
        [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
        
        if(playerSelected){
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:levelSelect]];
        }
    }
}

- (void) dealloc {
}

@end

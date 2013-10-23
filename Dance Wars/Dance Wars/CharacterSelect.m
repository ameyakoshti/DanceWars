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

@synthesize charSpriteList;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CharacterSelect *layer = [CharacterSelect node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
    if((self = [super init])) {
        
        windowSize = [[CCDirector sharedDirector] winSize];
        
        counter=1;
        
        charSpriteList = [[NSMutableArray alloc] init];
        
        //ih = [[InputHandler alloc] init];
        ch = [[CharacterHandler alloc] init];
        
        // Add background image
        CCSprite *charBg = [CCSprite spriteWithFile:@"characterselect_bg.png"];
        charBg.position = ccp(windowSize.width/2, windowSize.height/2);
        [self addChild:charBg];
        
        // Character header
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Select Your Character" fontName:@"Papyrus" fontSize:50];
        label.position = ccp(windowSize.width/2, windowSize.height*6/7);
        [self addChild:label];
        
        // Adding player 1 in the player selection menu (chacha: dance1.png)
        NSString *charPath1 = @"player_1.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*1/8,windowSize.height/3);
        [self addChild:ch.character];
        
        // Adding player 2 in the player selection menu(lady: d1.png)
        charPath1 = @"player_2.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*3/8,windowSize.height/3);
        [self addChild:ch.character];
        
        // Adding player 3 in the player selection menu (hulk1.png)
        charPath1 = @"player_2.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*5/8,windowSize.height/3);
        [self addChild:ch.character];
        
        // Adding player 4 in the player selection menu(random)
        charPath1 = @"player_2.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*7/8,windowSize.height/3);
        [self addChild:ch.character];
        
        self.touchEnabled = YES;
        [[[CCDirector sharedDirector]view]setMultipleTouchEnabled:YES];
    }
    return self;
}

// This function is for drawing all the default cocos2d geometry on the layer
// The function name has to be as it is.

 -(void)draw
{
    [super draw];
    
    // Color and width of the line
    ccDrawColor4B(255, 255, 255, 255);
    glLineWidth(5.0f);
    
    // Drwing 3 vertical lines for player selsection
    ccDrawLine(ccp(windowSize.width*1/4, 0), ccp(windowSize.width*1/4, windowSize.height));
    ccDrawLine(ccp(windowSize.width*1/2, 0), ccp(windowSize.width*1/2, windowSize.height));
    ccDrawLine(ccp(windowSize.width*3/4, 0), ccp(windowSize.width*3/4, windowSize.height));
}

- (CCSprite *) addSprite:(NSString *)spritePath {
    
    [ch setCharacter:[CCSprite spriteWithFile:spritePath]];
    [ch setSelected:@"0"];
    
    NSString *name = [NSString stringWithFormat:@"%@", spritePath];
    [ch setCharName:name];
    
    [charSpriteList addObject:ch];
    return ch.character;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        CGPoint location = [[CCDirector sharedDirector] convertTouchToGL:touch];
        
        for(CharacterHandler *ch2 in charSpriteList) {
            BOOL playerSelected = false;
            
            // creating manual frames for individual players
            
            // Frame for player 1 selection
            if(location.x > 0 && location.x < windowSize.width*1/4 && location.y > 0 && location.y < windowSize.height){
                playerSelected = TRUE;
                [ch2 setSelected:@"1"];
                if([ch2.selected  isEqual: @"1"]){
                    NSString *name = [NSString stringWithFormat:@"player_1"];
                    [ch setCharName:name];
                }
                NSLog(@"Name = %@",ch.charName);
                NSLog(@"Selected = %@",ch2.selected);
                
                sharedManager = [MyManager sharedManager];
                [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            }
            
            // Frame for player 2 selection
            if(location.x > windowSize.width*1/4 && location.x < windowSize.width*1/2 && location.y > 0 && location.y < windowSize.height){
                playerSelected = TRUE;
                [ch2 setSelected:@"2"];
                if([ch2.selected  isEqual: @"2"]){
                    NSString *name = [NSString stringWithFormat:@"player_2"];
                    [ch setCharName:name];
                }
                
                sharedManager = [MyManager sharedManager];
                [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            }
            
            // Frame for player 3 selection
            if(location.x > windowSize.width*1/2 && location.x < windowSize.width*3/4 && location.y > 0 && location.y < windowSize.height){
                playerSelected = TRUE;
                [ch2 setSelected:@"3"];
                if([ch2.selected  isEqual: @"3"]){
                    NSString *name = [NSString stringWithFormat:@"player_3"];
                    [ch setCharName:name];
                }
                sharedManager = [MyManager sharedManager];
                [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            }
            
            // Frame for player 4 selection
            if(location.x > windowSize.width*3/4 && location.x < windowSize.width && location.y > 0 && location.y < windowSize.height){
                playerSelected = TRUE;
                [ch2 setSelected:@"4"];
                if([ch2.selected  isEqual: @"4"]){
                    NSString *name = [NSString stringWithFormat:@"player_4"];
                    [ch setCharName:name];
                }
                
                sharedManager = [MyManager sharedManager];
                [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            }
            
            if(playerSelected){
                CCScene *levelSelect = [LevelSelectLayer scene];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.25 scene:levelSelect]];
            }
        }
        
    }
}

- (void) dealloc {
}

@end

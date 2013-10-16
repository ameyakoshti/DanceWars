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
        
        // Adding player 1 in the player selection menu
        NSString *charPath1 = @"dance1.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*1/8,windowSize.height/3);
        [self addChild:ch.character];
        
        // Adding player 2 in the player selection menu
        charPath1 = @"d1.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*3/8,windowSize.height/3);
        [self addChild:ch.character];
        
        // Adding player 3 in the player selection menu
        charPath1 = @"dancer3.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*5/8,windowSize.height/3);
        [self addChild:ch.character];
        
        // Adding player 4 in the player selection menu
        charPath1 = @"dancer4.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(windowSize.width*7/8,windowSize.height/3);
        [self addChild:ch.character];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
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
    
    // NSString *name = [NSString stringWithFormat:@"char%d",counter++];
    NSString *name = [NSString stringWithFormat:@"%@", spritePath];
    [ch setCharName:name];
    //NSLog(@"Name = %@",ch.charName);
    
    [charSpriteList addObject:ch];
    //NSLog(@"Bx%f,By%f",ch.character.boundingBox.origin.x, ch.character.boundingBox.origin.y);
    
    return ch.character;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    return YES;
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [[CCDirector sharedDirector] convertTouchToGL:touch];
    
    for(CharacterHandler *ch2 in charSpriteList) {
        
        // creating manual frames for individual players
        
        // Frame for player 1 selection
        
        if(location.x > 0 && location.x < windowSize.width*1/4 && location.y > 0 && location.y < windowSize.height){
            [ch2 setSelected:@"1"];
            if([ch2.selected  isEqual: @"1"]){
                NSString *name = [NSString stringWithFormat:@"dance"];
                [ch setCharName:name];
            }
            NSLog(@"Name = %@",ch.charName);
            NSLog(@"Selected = %@",ch2.selected);
            
            sharedManager = [MyManager sharedManager];
            [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
        
        // Frame for player 2 selection
        
        if(location.x > windowSize.width*1/4 && location.x < windowSize.width*1/2 && location.y > 0 && location.y < windowSize.height){
            [ch2 setSelected:@"2"];
            if([ch2.selected  isEqual: @"2"]){
                NSString *name = [NSString stringWithFormat:@"d"];
                [ch setCharName:name];
            }
            
            sharedManager = [MyManager sharedManager];
            [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
        
        // Frame for player 3 selection
        
        if(location.x > windowSize.width*1/2 && location.x < windowSize.width*3/4 && location.y > 0 && location.y < windowSize.height){
            [ch2 setSelected:@"3"];
            if([ch2.selected  isEqual: @"3"]){
                NSString *name = [NSString stringWithFormat:@"dancer"];
                [ch setCharName:name];
            }
            sharedManager = [MyManager sharedManager];
            [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
        
        // Frame for player 4 selection
        
        if(location.x > windowSize.width*3/4 && location.x < windowSize.width && location.y > 0 && location.y < windowSize.height){
            [ch2 setSelected:@"4"];
            if([ch2.selected  isEqual: @"4"]){
                NSString *name = [NSString stringWithFormat:@"dancer1"];
                [ch setCharName:name];
            }
            
            sharedManager = [MyManager sharedManager];
            [sharedManager.inputBundle setObject:ch2 forKey:@"ch"];
            
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
        
    }
}

- (void) dealloc {
    
    [super dealloc];
    
}

@end

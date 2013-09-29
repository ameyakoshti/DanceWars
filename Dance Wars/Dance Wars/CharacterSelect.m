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
        
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        counter=1;
        
        charSpriteList = [[NSMutableArray alloc] init];
        
        ih = [[InputHandler alloc] init];
        ch = [[CharacterHandler alloc] init];
        
        NSString *charPath1 = @"dance5.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(128,300);
        [self addChild:ch.character];
        
        charPath1 = @"dance1.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(384,300);
        [self addChild:ch.character];
        
        charPath1 = @"dance2.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(640,300);
        [self addChild:ch.character];
             
        charPath1 = @"dance4.png";
        [self addSprite:charPath1];
        ch.character.position = ccp(896,300);
        [self addChild:ch.character];
     
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

    }
    return self;
}

-(void)draw
{
    [super draw];
    
    ccDrawColor4B(255, 255, 255, 255);
    glLineWidth(5.0f);
    ccDrawLine(ccp(256, 0), ccp(256, 768));
    ccDrawLine(ccp(512, 0), ccp(512, 768));
    ccDrawLine(ccp(768, 0), ccp(768, 768));
}

- (CCSprite *) addSprite:(NSString *)spritePath {
    
    [ch setCharacter:[CCSprite spriteWithFile:spritePath]];
    [ch setSelected:@"0"];
    
    NSString *name = [NSString stringWithFormat:@"char%d",counter++];
    [ch setCharName:name];
    
    [charSpriteList addObject:ch];
    NSLog(@"Bx%f,By%f",ch.character.boundingBox.origin.x, ch.character.boundingBox.origin.y);
   
    return ch.character;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    return YES;
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [[CCDirector sharedDirector] convertTouchToGL:touch];
        
    //for(int i=0; i<[charSpriteList count]; i++) {
    for(CharacterHandler *ch2 in charSpriteList) {
    
        //NSLog(@"%@",[charSpriteList objectAtIndex:i]);
        NSLog(@"Bx%f,By%f,Lx%f,Ly%f",ch2.character.boundingBox.origin.x, ch2.character.boundingBox.origin.y, location.x, location.y);
        
        

        
        
        //if(CGRectContainsPoint(ch2.character.boundingBox, location)) {
        
        // creating manual frames for individual players
        
        // Frame for player 1 selection
        
        if(location.x > 0 && location.x < 256 && location.y > 0 && location.y <768){
            [ch2 setSelected:@"1"];
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
        
        // Frame for player 2 selection
        
        if(location.x > 256 && location.x < 512 && location.y > 0 && location.y <768){
            [ch2 setSelected:@"2"];
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
        
        // Frame for player 3 selection
        
        if(location.x > 512 && location.x < 768 && location.y > 0 && location.y <768){
            [ch2 setSelected:@"3"];
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
        
        // Frame for player 4 selection
        
        if(location.x > 768 && location.x < 1024 && location.y > 0 && location.y <768){
            [ch2 setSelected:@"4"];
            CCScene *levelSelect = [LevelSelectLayer scene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:levelSelect]];
        }
    }
}

- (void) dealloc {
    
    [super dealloc];
    
}

@end

//
//  GeneratePoints.m
//  Dance Wars
//
//  Created by Ameya Koshti on 9/18/13.
//  Copyright (c) 2013 Ameya Koshti. All rights reserved.
//

#import "GeneratePoints.h"
#import "HelloWorldLayer.h"
#import "MyManager.h"

@implementation GeneratePoints

- (id) init {
    
    [super init];
    
    ih = [[InputHandler alloc] init];
    return self;
}

- (float) calcAIScore {
    
    MyManager *sharedManager = [MyManager sharedManager];
    InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    
    InputHandler *ihsetacc = [sharedManager.inputBundle objectForKey:@"SETACC"];
    
    NSLog(@"setacc: %@", ihsetacc);

    //NSLog(@"Object %@", ih2);
    NSLog(@"Level Difficulty: %d", [ih2 gameLevelDifficulty]);
    NSLog(@"AI Accuracy: %d", [ih2 aiAccuracy]);
    NSLog(@"Player Accuracy: %f", [ihsetacc accuracy]);
    
    
    [ih setMoveDifficulty:3];                                         //not been implemented yet
    
    patternDifficulty = ([ih moveDifficulty] * [ih2 gameLevelDifficulty]);
    [ih setPointsScored: (patternDifficulty * [ihsetacc accuracy])];
    
    NSLog(@"Move Dif: %d", [ih moveDifficulty]);
    NSLog(@"Player Points: %f", [ih pointsScored]);
    
    float aiscore;
    aiscore = (66*3)*1000/9;
    
    //[ih setAiScore:([ih2 aiAccuracy] * patternDifficulty)*1000/9];   //1000 - randomly chosen multiplying factor to generate score range. 9 is the
                                                                    //scale down factor
    
    [ih setAiScore:aiscore];
    
    NSLog(@"AI Score = %f", aiscore);
    NSLog(@"AI S: %f", [ih aiScore]);
    
    return [ih aiScore];
}

@end

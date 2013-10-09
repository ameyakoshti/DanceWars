//
//  GeneratePoints.m
//  Dance Wars
//
//  Created by Ameya Koshti on 9/18/13.
//  Copyright (c) 2013 Ameya Koshti. All rights reserved.
//

#import "Score.h"
#import "HelloWorldLayer.h"
#import "MyManager.h"
#import "InputHandler.h"

@implementation Score

- (id) init {
    
    [super init];
    
    ih = [[InputHandler alloc] init];
    return self;
}

-(float) calScore {
    
    float aiscore;
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    // set game layer difficulty
    //InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    
    // set move difficulty
    [ih setMoveDifficulty:3];

    // retrieving object with game layer diff, ai accurancy, user accuracy.
    InputHandler *ih3 = [sharedManager.inputBundle objectForKey:@"USERACC"];
    
    patternDifficulty = ([ih moveDifficulty] * [ih3 gameLevelDifficulty]);
    
    // set user score
    [ih setUserScore: (patternDifficulty * [ih3 userAccuracy])];
    
    // set ai acurracy
    switch([ih3 gameLevelDifficulty]){
        case 1:{[ih3 setAiAccuracy:30];break;}
        case 2:{[ih3 setAiAccuracy:60];break;}
        case 3:{[ih3 setAiAccuracy:90];}
    }
    
    NSLog(@"Diff: %d",[ih3 gameLevelDifficulty]);
    NSLog(@"AIAcc: %d", [ih3 aiAccuracy]);
    NSLog(@"USer Acc: %f", [ih3 userAccuracy]);
    
    // set ai score
    aiscore = (patternDifficulty * [ih3 aiAccuracy]);
    [ih setAiScore:aiscore];
    NSLog(@"AIScore: %f",[ih aiScore]);
    
    return [ih aiScore];
}
@end

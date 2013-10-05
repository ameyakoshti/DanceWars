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

@implementation GeneratePoints

- (id) init {
    
    [super init];
    
    ih = [[InputHandler alloc] init];
    return self;
}

-(float) calScore:(float)Accuracy {
    
    float aiscore;
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    // set game layer difficulty
    InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
    
    // set move difficulty
    [ih setMoveDifficulty:3];

    // set user accuracy
    [ih setUserAccuracy:Accuracy];
    
    patternDifficulty = ([ih moveDifficulty] * [ih2 gameLevelDifficulty]);
    
    // set user score
    [ih setUserScore: (patternDifficulty * [ih userAccuracy])];
    
    // set ai acurracy
    switch([ih2 gameLevelDifficulty]){
        case 1:{[ih setAiAccuracy:30];break;}
        case 2:{[ih setAiAccuracy:60];break;}
        case 3:{[ih setAiAccuracy:90];}
    }
    
    // set ai score
    aiscore = (patternDifficulty * [ih aiAccuracy]);
    [ih setAiScore:aiscore];
    
    return [ih aiScore];
}
@end

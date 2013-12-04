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
    
    if ( self = [super init]) {
    
        ih = [[InputHandler alloc] init];
    }
    return self;
    
}

-(float) calScore {
    
    float aiscore;
    
    MyManager *sharedManager = [MyManager sharedManager];
    
    // set game layer difficulty
    //InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];

    // retrieving object with game layer diff, ai accurancy, user accuracy.
    InputHandler *ih3 = [sharedManager.inputBundle objectForKey:@"USERACC"];
    
    // set move difficulty
    [ih3 setMoveDifficulty:3];           //initial move difficulty for each of the three levels
    
    if([ih3 userAccuracy] >= 70)
        [ih3 setMoveDifficulty:5];
    else if([ih3 userAccuracy] >= 70 && [ih3 moveDifficulty] == 5)
        [ih3 setMoveDifficulty:7];
    
    NSLog(@"Move Difficulty Set To: %d", [ih3 moveDifficulty]);

    
    patternDifficulty = ([ih3 moveDifficulty] * [ih3 gameLevelDifficulty]);
    
    // set user score
    [ih setUserScore: (patternDifficulty * [ih3 userAccuracy])];
    NSLog(@"Userscore: %f", [ih userScore]);
    [sharedManager.inputBundle setObject:ih3 forKey:@"USERLIFE+MOVEDIFF"];
    
    //set user life value
    [ih3 setUserLife:[ih userScore]/21];
    
    // set ai acurracy based on level difficulty and user move difficulty
    switch([ih3 gameLevelDifficulty]){
        case 1:{
                    if([ih3 moveDifficulty] == 3)
                        [ih3 setAiAccuracy:30];
                    else if([ih3 moveDifficulty] == 5)
                        [ih3 setAiAccuracy:40];
                    else
                        [ih3 setAiAccuracy:50];
                    break;
                }
        case 2:{
                    if([ih3 moveDifficulty] == 3)
                        [ih3 setAiAccuracy:60];
                    else if([ih3 moveDifficulty] == 5)
                        [ih3 setAiAccuracy:70];
                    else
                        [ih3 setAiAccuracy:80];
                    break;
                }
        case 3:{
                    if([ih3 moveDifficulty] == 3)
                        [ih3 setAiAccuracy:85];
                    else if([ih3 moveDifficulty] == 5)
                        [ih3 setAiAccuracy:90];
                    else
                        [ih3 setAiAccuracy:100];
                    break;
                }
    }
    
    NSLog(@"Diff: %d",[ih3 gameLevelDifficulty]);
    NSLog(@"AIAcc: %d", [ih3 aiAccuracy]);
    NSLog(@"User Acc: %f", [ih3 userAccuracy]);
    
    // set ai score
    aiscore = (patternDifficulty * [ih3 aiAccuracy]);
    [ih setAiScore:aiscore];
    NSLog(@"AIScore: %f",[ih aiScore]);
    
    return [ih aiScore];
}
@end

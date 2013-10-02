//
//  GeneratePoints.m
//  Dance Wars
//
//  Created by Ameya Koshti on 9/18/13.
//  Copyright (c) 2013 Ameya Koshti. All rights reserved.
//

#import "GeneratePoints.h"

@implementation GeneratePoints

- (id) init {
    
    [super init];
    
    
    return self;
}

- (float) calcAIScore:(InputHandler *)ih2 {
    
    ih = ih2;
    
    [ih setMoveDifficulty:3];                                         //not been implemented yet
    
    patternDifficulty = ([ih moveDifficulty] * [ih gameLevelDifficulty]);
    [ih setPointsScored: (patternDifficulty * [ih accuracy])];
    
    [ih setAiScore:([ih aiAccuracy] * patternDifficulty)*1000/9];   //1000 - randomly chosen multiplying factor to generate score range. 9 is the
    //scale down factor
    
    NSLog(@"AI Score = %f", [ih aiScore]);
    
    
    return [ih aiScore];
}

@end

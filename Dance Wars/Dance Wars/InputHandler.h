//
//  InputHandler.h
//  Dance Wars
//
//  Created by Ameya Koshti on 9/18/13.
//  Copyright (c) 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InputHandler : NSObject {
    
    
}

@property (nonatomic) float accuracy;
@property (nonatomic) int gameLevelDifficulty;
@property (nonatomic) int moveDifficulty;     //player move difficulty
@property (nonatomic) float aiScore;          //ai response points
@property (nonatomic) float pointsScored;     //player points
@property (nonatomic) int aiAccuracy;         //accuracy of AI depending on the level selected
@end
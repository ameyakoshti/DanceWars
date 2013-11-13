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

@property (nonatomic) int gameLevelDifficulty;// difficulty of the game
@property (nonatomic) int moveDifficulty;     //player move difficulty
@property (nonatomic) float userAccuracy;     // user accuracy
@property (nonatomic) float userScore;        //player points
@property (nonatomic) int aiAccuracy;         //accuracy of AI depending on the level selected
@property (nonatomic) float aiScore;          //ai response points
@property (nonatomic) float userLife;         //corresponds to value obtained from user score being used to update progress bar
@property (nonatomic) float volumeLevel;      //set volume level, and update in gamelevellayer
@property (nonatomic) bool checkvolumeAltered;//check if volume is modified
@end
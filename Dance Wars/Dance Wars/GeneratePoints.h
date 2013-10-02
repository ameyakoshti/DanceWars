//
//  GeneratePoints.h
//  Dance Wars
//
//  Created by Ameya Koshti on 9/18/13.
//  Copyright (c) 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InputHandler.h"

@interface GeneratePoints : NSObject {
    
    InputHandler *ih;
    float patternDifficulty;
}

- (float) calcAIScore:(InputHandler *)ih2;

@end
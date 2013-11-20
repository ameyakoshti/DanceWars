//
//  OptionsSelectLayer.h
//  Dance Wars
//
//  Created by Arnab Banik on 11/9/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InputHandler.h"
#import "MyManager.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"
#import "MyManager.h"
#import "InputHandler.h"

@interface OptionsSelectLayer : CCLayer {
    
    CGSize windowSize;
    MyManager *sharedManager;
    InputHandler *ih, *ih2;
    CCSprite *settingsLabel;
    CCSprite *volumeLabel;

}

+(CCScene *) scene;

@end

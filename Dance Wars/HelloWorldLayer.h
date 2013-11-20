//
//  HelloWorldLayer.h
//  Dance Wars
//
//  Created by Prayaas Jain on 9/20/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface HelloWorldLayer : CCLayerColor {
    
    CGSize size;
    CCMenu *MainMenuPlay;
    CCMenu *MainMenuSettings;
    CCSprite *introName;
    CCSprite *playLabel;
    CCSprite *settingsLabel;
    
}


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

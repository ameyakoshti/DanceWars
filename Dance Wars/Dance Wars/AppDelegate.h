//
//  AppDelegate.h
//  Dance Wars
//
//  Created by Ameya Koshti on 9/18/13.
//  Copyright Ameya Koshti 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"


// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	
	CCDirectorIOS	*__unsafe_unretained_director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@end

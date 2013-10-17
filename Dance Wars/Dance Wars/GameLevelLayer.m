//
//  GameLevelLayer.m
//  Dance Wars
//
//  Created by Prayaas Jain on 9/20/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "AppDelegate.h"
#import "GameLevelLayer.h"

@implementation GameLevelLayer

@synthesize life,aiLife,progressTimer,aiProgressTimer,background;

static NSString * const UIGestureRecognizerNodeKey = @"UIGestureRecognizerNodeKey";

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	GameLevelLayer *layer = [GameLevelLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    
    if((self = [super init])) {
        
        //self.isTouchEnabled = YES;
        size = [[CCDirector sharedDirector] winSize];
        score = [[NSString alloc] init];
        
        // loading game environment
        sharedManager = [MyManager sharedManager];
        le = [sharedManager.inputBundle objectForKey:@"ENVR"];
        le.background.position = ccp(size.width/2, size.height/2);
        [self addChild:le.background];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:le.backgroundMusic];
        
        
        charHand = [sharedManager.inputBundle objectForKey:@"ch"];
        NSLog(@"Char selected in the init = %@", charHand.charName);
        
        
        grid = [CCSprite spriteWithFile:@"grid_map.png"];
        grid.position = ccp(size.width/2, size.height/2);
        [self addChild:grid];
        
        //user sprite as selected from the char sel layer
        
        dancer = [CCSprite spriteWithFile:[charHand.charName stringByAppendingString:@"1.png"]];
        dancer.position = ccp(150,200);
        [self addChild:dancer];
        
        aichar = [CCSprite spriteWithFile:@"dance1.png"];
        aichar.position = ccp(876,200);
        [self addChild:aichar];
       
        // Player life bar
        self.life = 0;
        self.progressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"healthbar_red.png"]];
        self.progressTimer.type = kCCProgressTimerTypeBar;
        self.progressTimer.midpoint = ccp(0,0);
        self.progressTimer.barChangeRate = ccp(1,0);
        [self.progressTimer setScale:1];
        self.progressTimer.percentage = self.life;
        self.progressTimer.position = ccp(120 ,size.height-50);
        [self addChild:self.progressTimer];        

        // AI life bar
        self.aiLife = 0;
        self.aiProgressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"healthbar_red.png"]];
        self.aiProgressTimer.type = kCCProgressTimerTypeBar;
        self.aiProgressTimer.midpoint = ccp(0,0);
        self.aiProgressTimer.barChangeRate = ccp(1,0);
        [self.aiProgressTimer setScale:1];
        self.aiProgressTimer.percentage = self.aiLife;
        self.aiProgressTimer.position = ccp(size.width-120,size.height-50);
        [self addChild:self.aiProgressTimer];

        // input handler object initialization
        ih = [[InputHandler alloc] init];
    }
    
    _patternsGenerated = [[NSMutableArray alloc] init];
    
    touchPointCounter=0;
    [self schedule:@selector(managingTouchIcons) interval:1.0 repeat:5 delay:1.5];
    
    self.touchEnabled = YES;
    [[[CCDirector sharedDirector]view]setMultipleTouchEnabled:YES];
    
    //[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    return self;
}

-(void) initiateAIDance {
    
    [self removeChild:aichar];
    [self removeChild:aiSpriteSheet];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dance.plist"];
    aiSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"dance.png"];
    
    NSMutableArray *walkframes = [NSMutableArray array];
    
    for (int i = 1; i <= 10; ++i) {
        NSString *frameName = [NSString stringWithFormat:@"dance%d.png",i];
        [walkframes addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    CCAnimation *walk = [CCAnimation animationWithSpriteFrames:walkframes delay:0.1f];
    CCSprite *dance = [CCSprite spriteWithSpriteFrameName:@"dance1.png"];
    dance.position = ccp(876, 200);
    
    CCAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walk] times:1];
    
    [dance runAction:danceAction];
    [aiSpriteSheet addChild:dance];
    [self addChild:aiSpriteSheet];
    
    [self scheduleOnce:@selector(initiateBlast) delay:2.0];
   
    // this is to get the score for the AI player
    int aiscore = (int)(([getScore calScore]*100)/2100);
    
    // AI life bar
    if(self.aiLife >= 0 && self.aiLife < 100){
        self.aiLife += aiscore;
        if(self.aiLife > 25 && self.aiLife < 60){
            [self.aiProgressTimer setSprite:[CCSprite spriteWithFile:@"healthbar_orange.png"]];
            [self.aiProgressTimer setScale:1];
        }
        if(self.aiLife > 60){
            [self.aiProgressTimer setSprite:[CCSprite spriteWithFile:@"healthbar_green.png"]];
            [self.aiProgressTimer setScale:1];
        }
        if(self.aiLife < 25){
            [self.aiProgressTimer setSprite:[CCSprite spriteWithFile:@"healthbar_red.png"]];
            [self.aiProgressTimer setScale:1];
        }
    }
    [self.aiProgressTimer setPercentage:self.aiLife];
}

-(void) initiateUserDance {

    NSString *name;
    NSLog(@"Char name = %@",charHand.charName);
    
    if([charHand.charName  isEqual: @"d"]) {
        name = @"ladydance";
    }
    else {
        name = @"dance";
        
    }
    
    [self removeChild:userSpriteSheet];

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[name stringByAppendingString:@".plist"]];
    NSString *BatchName = [name stringByAppendingString:@".png"];
    userSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:BatchName];
    
    NSMutableArray *walkframes = [NSMutableArray array];
    
    for (int i=1; i <= 83; ++i) {
        NSString *lastPart = [NSString stringWithFormat:@"%d.png",i];
//        NSLog(@"Last part = %@",lastPart);
//        NSLog(@"Char name = %@",charHand.charName);
        NSString *name = [charHand.charName stringByAppendingString:lastPart];
//        NSLog(@"Name = %@",name);
        
        NSString *frameName = [NSString stringWithFormat: @"%@",name];
        [walkframes addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
       
    }
    
    CCAnimation *walk = [CCAnimation animationWithSpriteFrames:walkframes delay:0.1f];
    CCSprite *dance = [CCSprite spriteWithSpriteFrameName:@"d1.png"];
    dance.position = ccp(150,200);
    CCAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walk] times:1];
    
    [dance runAction:[CCSequence actions: danceAction, [CCCallFunc actionWithTarget:self selector:@selector(initiateAIDance)],nil]];
    [userSpriteSheet addChild:dance];
    [self addChild:userSpriteSheet];    
}

-(void) initiateBlast {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bomb.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bomb.png"];
    
    NSMutableArray *walkframes = [NSMutableArray array];

    for (int i = 1; i <= 21; ++i) {
        NSString *frameName = [NSString stringWithFormat:@"f%d.png",i];
        [walkframes addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    CCAnimation *walk = [CCAnimation animationWithSpriteFrames:walkframes delay:0.1f];
    CCSprite *dance = [CCSprite spriteWithSpriteFrameName:@"f1.png"];
    dance.position = ccp(876, 150);
    
    CCAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walk] times:1];
    
    [dance runAction:danceAction];
    [spriteSheet addChild:dance];
    [self addChild:spriteSheet];
    
    if (self.life<100 && self.aiLife<100) {
        
        NSLog(@"The user score %d",self.life);
        NSLog(@"The AI Score%d",self.aiLife);
        
        objectCount=0;
        
        [self removeChild:spriteSheet];
        touchPointCounter=0;
        [self schedule:@selector(managingTouchIcons) interval:1.0 repeat:5 delay:1.5];
    }
}

-(void) initiateDance {

    [self removeChild: dancer];

    [self initiateUserDance];
    
    // this adds a button after the game is over to return to the main menu
    CCMenuItemImage *homeButton = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home_pressed.png" target:self selector:@selector(loadGameLayer)];
    CCMenu *gameMenu = [CCMenu menuWithItems:homeButton, nil];
    gameMenu.position = ccp(size.width - homeButton.contentSize.width/2, homeButton.contentSize.height/2);
    [self addChild:gameMenu];
}

-(void) loadGameLayer {
    // stop game music
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    // start home background music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3"];
    
    CCScene *gameLevel = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.2 scene:gameLevel]];
}

-(void) managingTouchIcons {
    if(touchPointCounter == 3 || touchPointCounter == 5){
        [self addTouchIcons:1 withArg2:@"touchpoints-blue.png"];
        [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:1] afterDelay:0.75];
        
        [self addTouchIcons:2 withArg2:@"touchpoints-blue.png"];
        [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:2] afterDelay:0.75];
    }else{
        [self addTouchIcons:1 withArg2:@"touchpoints.png"];
        [self performSelector:@selector(removeTouchIcons:) withObject:[NSNumber numberWithInt:1] afterDelay:0.75];
    }
    
    touchPointCounter++;
}

-(void) addTouchIcons:(int) touchNumber withArg2:(NSString *) fileName {
    
    touchIcon[touchNumber] = [CCSprite spriteWithFile:fileName];
    
    // creating the imaginary rectangle in which the icons will appear
    float maxX = size.width * 2/3;
    float minX = size.width * 1/3;
    float maxY = size.height * 2/3;
    float minY = size.height * 1/3;
    float rangeX = maxX - minX;
    float rangeY = maxY - minY;
    float randomH = (arc4random() % (int)rangeY) + (int)minY;
    float randomW = (arc4random() % (int)rangeX) + (int)minX;
    
    touchIcon[touchNumber].position = ccp(randomW, randomH);
    
    // these variables are used to store the location of the touch points to calculate the score
    xLocations[objectCount] = (float)randomW;
    yLocations[objectCount] = (float)randomH;
    visited[objectCount] = 0;
    
    [self addChild:touchIcon[touchNumber]];
    //[self scheduleOnce:@selector(removeTouchIcons) delay:0.75];
    [_patternsGenerated addObject:touchIcon[touchNumber]];
    objectCount ++;
    totalObjects ++;
    
    CCParticleSystem *emitter = [CCParticleExplosion node];
    //set the location of the emitter
    emitter.position = touchIcon[touchNumber].position;
    //set size of particle animation
    emitter.scale = 0.5;
    //set an Image for the particle
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"touchpoints.png"];
    //set length of particle animation
    [emitter setLife:0.1f];
    //add to layer ofcourse(effect begins after this step)
    [self addChild: emitter];
}

-(void) removeTouchIcons:(NSNumber *) value{
    int val = [value intValue];
    [self removeChild:touchIcon[val] cleanup:YES];
    
    if(objectCount >= 8){
        
        // calculate the score and accuracy for user and ai
        
        InputHandler *ih2 = [sharedManager.inputBundle objectForKey:@"LDAA"];
        
        [ih2 setUserAccuracy:(hitCount*100/objectCount)];
        [sharedManager.inputBundle setObject:ih2 forKey:@"USERACC"];
        
        getScore = [[Score alloc] init];
        [getScore calScore];
        
        InputHandler *ih3 = [sharedManager.inputBundle objectForKey:@"USERLIFE"];
        
        //increment progress bar for user
        if(self.life >= 0 && self.life < 100){
            self.life += (int)[ih3 userLife];
            if(self.life > 25 && self.life < 60){
                [self.progressTimer setSprite:[CCSprite spriteWithFile:@"healthbar_orange.png"]];
                [self.progressTimer setScale:1];
            }
            if(self.life > 60){
                [self.progressTimer setSprite:[CCSprite spriteWithFile:@"healthbar_green.png"]];
                [self.progressTimer setScale:1];
            }
        }
        [self.progressTimer setPercentage:self.life];
        
        //allow the user to swipe now.
        /*        touchHit = [CCSprite spriteWithFile:@"gesture.png"];
         touchHit.scale = 0.5f;
         touchHit.position = ccp(size.width/2,size.height/2);
         touchHit.isTouchEnabled=YES;
         
         //enable pan gesture recognizer
         [self enableGesture]; */
        
        //enable dance show
        [self initiateDance];
        
        [self removeChild:grid];
    }
}

-(void) enableGesture{
    //! pan gesture recognizer
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    [touchHit addGestureRecognizer:panGestureRecognizer];
    [self addChild:touchHit];
    
    /*
     //! pinch gesture recognizer
     UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
     [sprite addGestureRecognizer:pinchGestureRecognizer];
     pinchGestureRecognizer.delegate = self;
     
     //! rotation gesture recognizer
     UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGestureRecognizer:)];
     [sprite addGestureRecognizer:rotationGestureRecognizer];
     rotationGestureRecognizer.delegate = self;
     */
    
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void) handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer{
    CCNode *node = aPanGestureRecognizer.node;
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
    
    node.position = ccpAdd(node.position, translation);
    // this is to check if the touch gesture has been through the touch points
    
    for(int pointNumber = 0 ; pointNumber < 6 ; pointNumber++){
        
        if(CGRectContainsPoint(touchHit.boundingBox, ccp(xLocations[pointNumber],yLocations[pointNumber]))  && visited[pointNumber] == 0){
            visited[pointNumber] = 1;
            CCParticleSystem *emitterGesture = [CCParticleExplosion node];
            //set the location of the emitter
            emitterGesture.position = node.position;
            //set size of particle animation
            emitterGesture.scale = 0.5;
            //set an Image for the particle
            emitterGesture.texture = [[CCTextureCache sharedTextureCache] addImage:@"Icon-Small.png"];
            //set length of particle animation
            [emitterGesture setLife:1.0f];
            //add to layer ofcourse(effect begins after this step)
            [self addChild: emitterGesture];
            
            if(self.life >= 0 && self.life < 100){
                self.life += 15;
                if(self.life > 25 && self.life < 60){
                    [self.progressTimer setSprite:[CCSprite spriteWithFile:@"healthbar_orange.png"]];
                    [self.progressTimer setScale:1];
                }
                if(self.life > 60){
                    [self.progressTimer setSprite:[CCSprite spriteWithFile:@"healthbar_green.png"]];
                    [self.progressTimer setScale:1];
                }
            }
           [self.progressTimer setPercentage:self.life];
        }
    }

}

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches)
    {
        CGPoint location = [[CCDirector sharedDirector] convertTouchToGL:touch];
        
        if((CGRectContainsPoint(touchIcon[1].boundingBox, location))) {
            [self removeChild:touchIcon[1] cleanup:YES];
            hitCount++;
        }
        else {
           // for negative points
        }
    }
}

-(void) dealloc {
}

@end

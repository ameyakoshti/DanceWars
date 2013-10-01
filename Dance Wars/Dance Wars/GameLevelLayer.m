//
//  GameLevelLayer.m
//  Dance Wars
//
//  Created by Prayaas Jain on 9/20/13.
//  Copyright 2013 Ameya Koshti. All rights reserved.
//

#import "AppDelegate.h"
#import "GameLevelLayer.h"
#import "HelloWorldLayer.h"
#import "CCNode+SFGestureRecognizers.h"

@implementation GameLevelLayer

@synthesize life;
@synthesize progressTimer;

static NSString * const UIGestureRecognizerNodeKey = @"UIGestureRecognizerNodeKey";

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLevelLayer *layer = [GameLevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    
    if((self = [super init])) {
    
        //self.isTouchEnabled = YES;
        size = [[CCDirector sharedDirector] winSize];
        score = [[NSString alloc] init];
                
        //check.position = ccp(size.width/2, size.height/2);
        
        CCSprite *levelBg = [CCSprite spriteWithFile:@"level_bg.jpg"];
        levelBg.position = ccp(size.width/2, size.height/2);
    
        //[self addChild:check];
        [self addChild:levelBg];
        
        dancer = [CCSprite spriteWithFile:@"dance1.png"];
        dancer.position = ccp(200,250);
        
        [self addChild:dancer];
       
        self.life = 0;
        self.progressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"healthbar_red.png"]];
        self.progressTimer.type = kCCProgressTimerTypeBar;
        self.progressTimer.midpoint = ccp(0,0);
        self.progressTimer.barChangeRate = ccp(1,0);
        [self.progressTimer setScale:1];
        self.progressTimer.percentage = self.life;
        self.progressTimer.position = ccp(size.width-120,size.height-20);
        [self addChild:self.progressTimer];        


        CCSprite *sprite = [CCSprite spriteWithFile:@"gesture.png"];
        sprite.scale = 0.5f;
        sprite.position = ccp(arc4random() % (int)size.width, arc4random() % (int)size.height);
        sprite.isTouchEnabled=YES;
        
        //! pan gesture recognizer
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGestureRecognizer.delegate = self;
        [sprite addGestureRecognizer:panGestureRecognizer];
        
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
        [self addChild:sprite];

    }
    
    _patternsGenerated = [[NSMutableArray alloc] init];
    

    [self schedule:@selector(addTouchIcons) interval:1.0 repeat:5 delay:1.5];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
     return self;    
}


#pragma mark - GestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    CCNode *node = aPanGestureRecognizer.node;
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
    
    node.position = ccpAdd(node.position, translation);
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)aPinchGestureRecognizer
{
    if (aPinchGestureRecognizer.state == UIGestureRecognizerStateBegan || aPinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CCNode *node = aPinchGestureRecognizer.node;
        float scale = [aPinchGestureRecognizer scale];
        node.scale *= scale;
        aPinchGestureRecognizer.scale = 1;
    }
}

- (void)handleRotationGestureRecognizer:(UIRotationGestureRecognizer*)aRotationGestureRecognizer
{
    if (aRotationGestureRecognizer.state == UIGestureRecognizerStateBegan || aRotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CCNode *node = aRotationGestureRecognizer.node;
        float rotation = aRotationGestureRecognizer.rotation;
        node.rotation += CC_RADIANS_TO_DEGREES(rotation);
        aRotationGestureRecognizer.rotation = 0;
    }
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) calcScore {
    missCount = objectCount - hitCount;
    NSLog(@" misses = %d", missCount);
    NSLog(@"hits = %d", hitCount);
    scoreLabel = [CCLabelTTF labelWithString:score fontName:@"Marker felt" fontSize:25];
    scoreLabel.position = ccp(size.width - 100, size.height - 20);
    //[scoreLabel setString:@"0,0"];
    [self addChild:scoreLabel];
    score = [NSString stringWithFormat:@"Hits =  %u, Misses = %u",hitCount, missCount];
    [scoreLabel setString:score];
}

-(void) initiateDance {

    [self removeChild: dancer];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dance.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"dance.png"];
    
    NSMutableArray *walkframes = [NSMutableArray array];
    
    for (int i = 1; i <= 10; ++i) {
        
        // [walkframes addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString tringWithFormat:@"dance%d.png", 1]]];
        
        NSString *frameName = [NSString stringWithFormat:@"dance%d.png",i];
        [walkframes addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        
    }
    
    CCAnimation *walk = [CCAnimation animationWithFrames:walkframes delay:0.1f];
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    CCSprite *dance = [CCSprite spriteWithSpriteFrameName:@"dance1.png"];
    dance.position = ccp(200, 250);
    
    CCAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walk restoreOriginalFrame:NO] times:1];
    
    [dance runAction:danceAction];
    [spriteSheet addChild:dance];
    [self addChild:spriteSheet];

    // this adds a button after the game is over to return to the main menu
    CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"menu.png" selectedImage:@"menu.png" target:self selector:@selector(loadGameLayer)];
    CCMenu *gameMenu = [CCMenu menuWithItems:playButton, nil];
    gameMenu.position = ccp(950, 70);
    [self addChild:gameMenu];

}

- (void) loadGameLayer {
    
    CCScene *gameLevel = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.2 scene:gameLevel]];
    
}

- (void) addTouchIcons {
    
    touchIcon = [CCSprite spriteWithFile:@"touchpoints.png"];
    
    
    float maxX = size.width * 3/4;
    float minX = size.width * 1/4;
    float rangeX = maxX- minX;
    float randomH = (arc4random() % (int)size.height) + (int) size.height * 1/4;
    float randomW = (arc4random() % (int)rangeX) + minX;
    CCLOG(@"I am here!!!");
    NSLog(@"H = %f",randomH);
    NSLog(@"W = %f",randomW);
   
    if(randomH > 768)
        randomH = size.height - touchIcon.boundingBox.size.height;
    if(randomW < minX)
        randomW = 400;
    if(randomW > maxX)
        randomW = 600;
    touchIcon.position = ccp(randomW, randomH);
    NSLog(@"%f and %f", touchIcon.position.x, touchIcon.position.y);
    [self addChild:touchIcon];
    [self scheduleOnce:@selector(removeTouchIcons) delay:0.75];
    [_patternsGenerated addObject:touchIcon];
    objectCount ++;
}

- (void) removeTouchIcons{
    
    //NSLog(@"Trying to remove now!! missed hit");
    [self removeChild:touchIcon cleanup:YES];
    
    if(objectCount >= 6){
        [self calcScore];
        [self initiateDance];
        

    }
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    return YES;
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    // user touch recognition and matching
    //UITouch *touch = [touches anyObject];
    
    UIAlertView *patternDecision;
    
        CGPoint location = [[CCDirector sharedDirector] convertTouchToGL:touch];
    
        if((CGRectContainsPoint(touchIcon.boundingBox, location))) {
        
            patternDecision = [[UIAlertView alloc] initWithTitle:@"Touch Detected" message:@"You have a HIT!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //NSLog(@"Hit!!");
            [self removeChild:touchIcon cleanup:YES];
            hitCount++;
            //[patternDecision show];
            [patternDecision release];
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
        else {
        
            patternDecision = [[UIAlertView alloc] initWithTitle:@"Touch Detected" message:@"You Missed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //NSLog(@"Miss!!");
            //[patternDecision show];
            [patternDecision release];
            if(self.life > 0 && self.life <= 100){
                self.life -= 15;
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

- (void) dealloc {
    
    [super dealloc];
    
    [_patternsGenerated release];
    _patternsGenerated = nil;
    
}


@end

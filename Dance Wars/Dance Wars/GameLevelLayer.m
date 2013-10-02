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
@synthesize progressTimer, background;

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
        
        CCSprite *levelBg = [CCSprite spriteWithFile:@"Jungle.png"];
        levelBg.position = ccp(size.width/2, size.height/2);
    
        //[self addChild:check];
        [self addChild:levelBg];
        
        dancer = [CCSprite spriteWithFile:@"dance1.png"];
        dancer.position = ccp(150,200);
        
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


        touchHit = [CCSprite spriteWithFile:@"gesture.png"];
        touchHit.scale = 0.5f;
        touchHit.position = ccp(arc4random() % (int)size.width, arc4random() % (int)size.height);
        touchHit.isTouchEnabled=YES;
        
        //! pan gesture recognizer
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGestureRecognizer.delegate = self;
        [touchHit addGestureRecognizer:panGestureRecognizer];
        
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
        [self addChild:touchHit];
        
        
        
        // objects from input handler
        ih = [[InputHandler alloc] init];
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
    /*
    CCParticleSystem *emitterGesture = [CCParticleExplosion node];
    //set the location of the emitter
    emitterGesture.position = node.position;
    //set size of particle animation
    emitterGesture.scale = 0.3;
    //set an Image for the particle
    emitterGesture.texture = [[CCTextureCache sharedTextureCache] addImage:@"colorwheel_trail.png"];
    //set length of particle animation
    [emitterGesture setLife:0.1f];
    //add to layer ofcourse(effect begins after this step)
    [self addChild: emitterGesture];
    */
    
    
    
    // this is to check if the touch gesture has been through the touch points
    //NSLog(@"%f %f",node.position.x,node.position.y);
    for(int pointNumber = 0 ; pointNumber < 6 ; pointNumber++){
        
        if(CGRectContainsPoint(touchHit.boundingBox, ccp(xLocations[pointNumber],yLocations[pointNumber]))){
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
        }
    }

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
    
    [ih setAccuracy:(hitCount*100/objectCount)];
    GeneratePoints *gp = [[GeneratePoints alloc] init];
    [gp calcAIScore:ih];
    
    missCount = objectCount - hitCount;
    //NSLog(@" misses = %d", missCount);
    //NSLog(@"hits = %d", hitCount);
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
    
    CCAnimation *walk = [CCAnimation animationWithSpriteFrames:walkframes delay:0.1f];
    CCSprite *dance = [CCSprite spriteWithSpriteFrameName:@"dance1.png"];
    dance.position = ccp(150, 200);
    
    CCAction *danceAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walk] times:1];
    
    [dance runAction:danceAction];
    [spriteSheet addChild:dance];
    [self addChild:spriteSheet];

    // this adds a button after the game is over to return to the main menu
    CCMenuItemImage *playButton = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home_pressed.png" target:self selector:@selector(loadGameLayer)];
    CCMenu *gameMenu = [CCMenu menuWithItems:playButton, nil];
    gameMenu.position = ccp(size.width - playButton.contentSize.width/2, playButton.contentSize.height/2);
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
   
    if(randomH > 768)
        randomH = size.height - touchIcon.boundingBox.size.height;
    if(randomW < minX)
        randomW = 400;
    if(randomW > maxX)
        randomW = 600;
    touchIcon.position = ccp(randomW, randomH);
    
    // these variables are used to store the location of the touch points to calculate the score
    xLocations[objectCount] = (float)randomW;
    yLocations[objectCount] = (float)randomH;
    
    [self addChild:touchIcon];
    [self scheduleOnce:@selector(removeTouchIcons) delay:0.75];
    [_patternsGenerated addObject:touchIcon];
    objectCount ++;
    
    CCParticleSystem *emitter = [CCParticleExplosion node];
    //set the location of the emitter
    emitter.position = touchIcon.position;
    //set size of particle animation
    emitter.scale = 0.5;
    //set an Image for the particle
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"touchpoints.png"];
    //set length of particle animation
    [emitter setLife:0.1f];
    //add to layer ofcourse(effect begins after this step)
    [self addChild: emitter];
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

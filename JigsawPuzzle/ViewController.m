//
//  ViewController.m
//  JigsawPuzzle
//
//  Created by Mike_Gazdich_rMBP on 10/29/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSDictionary *puzzlePieceDict;
@property (strong, nonatomic) NSArray *puzzlePieces;
@property (strong, nonatomic) NSArray *pieceCoord;
@property (strong, nonatomic) NSMutableArray *isCorrect;

@property (strong, nonatomic) NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button

- (void)placePiecesRandom;
- (void)handlePanning1:(UIPanGestureRecognizer *)recognizer;
- (BOOL)gameIsWon;
- (NSString*)getSuccessMessage:(NSTimeInterval) timeInt;

@end

@implementation ViewController

/*
 A geometric translation moves every point of our UIImageView object by the same amount
 in a given direction when it is panned (dragged) from one location to another.
 We store the (x, y) coordinates of the last translation of imageViewj into the
 static variable lastTranslationj, where j=1,2,3,4
 
 CGPoint is a structure that contains the (x, y) coordinate values
 */
static CGPoint lastTranslation1;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _isCorrect = [[NSMutableArray alloc]init];
    [_isCorrect addObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];

    self.congratsImage.hidden = YES;
    self.rocketImage1.hidden = YES;
    self.rocketImage2.hidden = YES;
    
    self.startDate = [NSDate date];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"puzzlePieceCenterCoordinates" ofType:@"plist"];
    self.puzzlePieceDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    self.puzzlePieces = [[self.puzzlePieceDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self drawRectangle];
    
    // Obtain the URL path to the hokie gobble sound file, turkeyGobble.wav.
    NSURL *soundFilePath = [[NSBundle mainBundle] URLForResource: @"clickSound" withExtension: @"wav"];
    
    // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
    self.soundFileURLRef = (__bridge CFURLRef) soundFilePath;
    // Obtain the URL path to the hokie gobble sound file, turkeyGobble.wav.
    soundFilePath = [[NSBundle mainBundle] URLForResource: @"applaudSound" withExtension: @"wav"];
    
    // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
    CFURLRef soundFileURLRef = (__bridge CFURLRef) soundFilePath;
    
    AudioServicesCreateSystemSoundID(soundFileURLRef, &_applaudSoundID);
    
    /*
     Create a system sound object for the short sound (30 seconds or shorter) in file turkeyGobble.wav
     
     Load the turkey gobble sound file into memory from its file and store the assigned
     identifier in the _turkeyGobbleSoundID instance variable.
     
     & is a unary operator known as the Address Operator. It basically represents
     two-level indirection. &_turkeyGobbleSoundID points to another pointer that contains
     the memory address of the sound; hence, double pointers or double indirection.
     
     AudioServicesCreateSystemSoundID is a C programming language function, which takes
     self.soundFileURLRef as input and provides the value of &_turkeyGobbleSoundID as output.
     */
    AudioServicesCreateSystemSoundID (self.soundFileURLRef, &_clickSoundID);
    
    /**************************************************************************************************
     *  Panning (Dragging) is a continuous gesture, which                                             *
     *                                                                                                *
     *   (a) begins when the user starts panning while one or more fingers are pressed down, and      *
     *   (b) ends when all fingers are lifted.                                                        *
     *                                                                                                *
     *  Panning has the following 3 states:                                                           *
     *                                                                                                *
     *  UIGestureRecognizerStateBegan                                 UIGestureRecognizerStateEnded   *
     *              |                                                                |                *
     *              |                UIGestureRecognizerStateChanged                 |                *
     *              V                                                                V                *
     *  time --------------------------------------------------------------------------------------   *
     *         touch begins                                                     touch ends            *
     *************************************************************************************************/
    
    //--------------------------------------------------------------
    // Create Panning (Dragging) Gesture Recognizer for Image View 1
    UIPanGestureRecognizer *panRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 1
    [self.puzzleImage1 addGestureRecognizer:panRecognizer1];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 2
    UIPanGestureRecognizer *panRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 2
    [self.puzzleImage2 addGestureRecognizer:panRecognizer2];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 3
    UIPanGestureRecognizer *panRecognizer3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 3
    [self.puzzleImage3 addGestureRecognizer:panRecognizer3];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 4
    UIPanGestureRecognizer *panRecognizer4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 4
    [self.puzzleImage4 addGestureRecognizer:panRecognizer4];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 5
    UIPanGestureRecognizer *panRecognizer5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 5
    [self.puzzleImage5 addGestureRecognizer:panRecognizer5];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 6
    UIPanGestureRecognizer *panRecognizer6 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 6
    [self.puzzleImage6 addGestureRecognizer:panRecognizer6];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 7
    UIPanGestureRecognizer *panRecognizer7 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 7
    [self.puzzleImage7 addGestureRecognizer:panRecognizer7];

    // Create Panning (Dragging) Gesture Recognizer for Image View 8
    UIPanGestureRecognizer *panRecognizer8 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 8
    [self.puzzleImage8 addGestureRecognizer:panRecognizer8];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 10
    UIPanGestureRecognizer *panRecognizer10 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 10
    [self.puzzleImage10 addGestureRecognizer:panRecognizer10];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 10
    UIPanGestureRecognizer *panRecognizer12 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 12
    [self.puzzleImage12 addGestureRecognizer:panRecognizer12];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 11
    UIPanGestureRecognizer *panRecognizer11 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 11
    [self.puzzleImage11 addGestureRecognizer:panRecognizer11];
    
    // Create Panning (Dragging) Gesture Recognizer for Image View 9
    UIPanGestureRecognizer *panRecognizer9 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning1:)];
    // Add Panning (Dragging) Gesture Recognizer to Image View 9
    [self.puzzleImage9 addGestureRecognizer:panRecognizer9];


}

#pragma mark - Panning (Dragging) Handling Methods

/*********************************************************
 *  Handle Panning (Dragging) Gesture  for Image View 1  *
 ********************************************************/
- (void)handlePanning1:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint newTranslation = [recognizer translationInView:self.view];
    
    //Update the image's center point with new translation in both x and y direction.
    CGPoint center = CGPointMake(recognizer.view.center.x + newTranslation.x, recognizer.view.center.y + newTranslation.y);
    
    //set the new center position of the image.
    recognizer.view.center = center;
    
    //reset the translation to be 0,0
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    NSString *pieceName = [self.puzzlePieces objectAtIndex:recognizer.view.tag];
    
    self.pieceCoord = [self.puzzlePieceDict objectForKey:pieceName];
    
    CGPoint pieceCenter = CGPointMake([[self.pieceCoord objectAtIndex:0] floatValue],
                                 [[self.pieceCoord objectAtIndex:1] floatValue]);
    
    if ((center.x >= pieceCenter.x - 20 && center.x <= pieceCenter.x + 20) &&
        (center.y >= pieceCenter.y - 20 && center.y <= pieceCenter.y + 20)){
        recognizer.view.center = pieceCenter;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        lastTranslation1.x = 0;
        lastTranslation1.y = 0;
        if(recognizer.view.center.x != pieceCenter.x || recognizer.view.center.y != pieceCenter.y){
            [self.isCorrect setObject: @(NO) atIndexedSubscript: recognizer.view.tag];
        }
        else{
            // Then, play the click sound
            AudioServicesPlaySystemSound (_clickSoundID);
            [self.isCorrect setObject:@(YES) atIndexedSubscript:recognizer.view.tag];
        }
        if ([self gameIsWon]){
            
            // Obtain the URL path to the hokie gobble sound file, turkeyGobble.wav.
            NSURL *soundFilePath = [[NSBundle mainBundle] URLForResource: @"applaudSound" withExtension: @"wav"];
            
            // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
            CFURLRef soundFileURLRef = (__bridge CFURLRef) soundFilePath;
            
            AudioServicesCreateSystemSoundID(soundFileURLRef, &_applaudSoundID);
            AudioServicesPlaySystemSound(_applaudSoundID);
            
            self.puzzlePicture.hidden = NO;
            self.congratsImage.hidden = NO;
            self.congratsImage.alpha = 0.0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.50];
            self.congratsImage.alpha = 1.0;          // Make the image entirely invisible (fade out) at the end of animation
            self.rocketImage1.hidden = NO;
            self.rocketImage2.hidden = NO;
            CGPoint moveLocate = self.rocketImage2.center;
            moveLocate.y -= 300.0;
            self.rocketImage2.center = moveLocate;
            moveLocate = self.rocketImage1.center;
            moveLocate.y -= 300.0;
            self.rocketImage1.center = moveLocate;
            [UIView commitAnimations];
            NSDate *endDate = [NSDate date];
            self.gameCompleteMessage.text = [self getSuccessMessage:[endDate timeIntervalSinceDate:_startDate]];
            
            [_stopWatchTimer invalidate];
            _stopWatchTimer = nil;
            self.instructLabel.text = @"Tap New Game to Play.";
        }
    }
}

- (void) placePiecesRandom
{
    float randX = 50 + arc4random_uniform(900);
    float randY = 50 + arc4random_uniform(600);
    self.puzzleImage1.frame = (CGRect){{randX,randY}, self.puzzleImage1.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage2.frame = (CGRect){{randX,randY}, self.puzzleImage2.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage3.frame = (CGRect){{randX,randY}, self.puzzleImage3.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage4.frame = (CGRect){{randX,randY}, self.puzzleImage4.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage5.frame = (CGRect){{randX,randY}, self.puzzleImage5.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage6.frame = (CGRect){{randX,randY}, self.puzzleImage6.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage7.frame = (CGRect){{randX,randY}, self.puzzleImage7.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage8.frame = (CGRect){{randX,randY}, self.puzzleImage8.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage9.frame = (CGRect){{randX,randY}, self.puzzleImage9.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage10.frame = (CGRect){{randX,randY}, self.puzzleImage10.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage11.frame = (CGRect){{randX,randY}, self.puzzleImage11.frame.size};
    randX = 50 + arc4random_uniform(900);
    randY = 50 + arc4random_uniform(600);
    self.puzzleImage12.frame = (CGRect){{randX,randY}, self.puzzleImage12.frame.size};
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    self.instructLabel.text = @"";
    self.puzzlePicture.hidden = YES;
    self.congratsImage.hidden = YES;
    self.rocketImage1.hidden = YES;
    self.rocketImage2.hidden = YES;
    self.gameCompleteMessage.text = @"";
    CGPoint resetCenter = CGPointMake(915, 675);
    self.rocketImage1.center = resetCenter;
    resetCenter = CGPointMake(100, 675);
    self.rocketImage2.center = resetCenter;
    [_isCorrect removeAllObjects];
    [_isCorrect addObjectsFromArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];
    if(_stopWatchTimer)
    {
        [_stopWatchTimer invalidate];
        _stopWatchTimer = nil;
    }
    self.startDate = [NSDate date];
    _stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0
                                                 target:self
                                               selector:@selector(updateTimer)
                                               userInfo:nil
                                                repeats:YES];

    [self placePiecesRandom];
}

- (BOOL) gameIsWon
{
    return ![self.isCorrect containsObject:@(NO)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:_startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.timerCountLabel.text = timeString;
}

- (NSString*)getSuccessMessage:(NSTimeInterval)timeInt
{
    NSString* message;
    
    if ((timeInt/60.00) >= 3.00)
    {
        message = @"You did Slow.";
    }
    else if (timeInt/60.00 >= 2.00)
    {
        message = @"You did Satisfactory.";
    }
    else if (timeInt >= 41)
    {
        message = @"You did Good.";
    }
    else if (timeInt >= 20)
    {
        message = @"You did Great.";
    }
    else if (timeInt < 20)
    {
        message = @"You did Outstanding.";
    }
    else
    {
        message = @"Error, please completely close the application and restart.";
    }
    
    return message;
}
// Create a rectangular canvas to hold the puzzle pieces
-(void)drawRectangle
{
    // Obtain the height, width information of the super view.
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat halfHeight = self.view.frame.size.height/2;
    CGFloat halfWidth = self.view.frame.size.width/2;
    
    // Obtain the size of the full puzzle image: jigsawPuzzlePhoto.png
    CGFloat imageWidthInPixels = 603;
    CGFloat imageHeightInPixels = 453;
    
    // Calculate the position where rectangle canvas is placed. (Top left corner of rect)
    CGFloat positionRectY = (height/2) - (imageWidthInPixels/2);
    CGFloat positionRectX = (width/2) - (imageHeightInPixels/2);
    
    // Geometric objects (e.g., rectangle) can be drawn on top of a UIImageView object
    // Therefore, create a UIImageView object as your canvas with a size of 1024x768 to hold the drawings
    // Specify in the .h file: @property (strong, nonatomic)  UIImageView *backgroundRect;
    self.backgroundRect = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, width)];
    
    // Create a bitmap-based graphics context and make it the current context.
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    // Draw the entire image in the specified rectangle, scaling it as needed to fit.
    [self.backgroundRect.image drawInRect:CGRectMake(0, 0, width, height)];
    
    // Obtain the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a new empty path in the current graphics context
    CGContextBeginPath(context);
    
    // Draw a rectangle with the given position and size
    CGContextStrokeRect(context, CGRectMake(positionRectX, positionRectY, imageHeightInPixels, imageWidthInPixels));
    
    // Set the background canvas to the contents of the current bitmap graphics context.
    self.backgroundRect.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Remove the current bitmap-based graphics context from the top of the stack.
    UIGraphicsEndImageContext();
    
    // Set the background canvas center
    [self.backgroundRect setCenter:CGPointMake(halfHeight, halfWidth)];
    
    [self.view addSubview:self.backgroundRect];
}

@end
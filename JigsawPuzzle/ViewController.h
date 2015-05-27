//
//  ViewController.h
//  JigsawPuzzle
//
//  Created by Mike_Gazdich_rMBP on 10/29/13.
//  Copyright (c) 2013 Mike Gazdich. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 Audio Toolbox Framework provides C programming language functions
 for recording, playback, and stream parsing of audio files.
 */
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundRect;
@property (strong, nonatomic) IBOutlet UILabel *instructLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage1;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage2;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage3;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage4;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage5;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage6;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage7;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage8;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage9;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage10;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage11;
@property (strong, nonatomic) IBOutlet UIImageView *puzzleImage12;
@property (strong, nonatomic) IBOutlet UIImageView *puzzlePicture;
@property (strong, nonatomic) IBOutlet UIImageView *congratsImage;
@property (strong, nonatomic) IBOutlet UIImageView *rocketImage1;
@property (strong, nonatomic) IBOutlet UIImageView *rocketImage2;
@property (strong, nonatomic) IBOutlet UILabel *gameCompleteMessage;

/*
 We define _clickSoundID as an instance variable pointing to the pointer
 containing the memory location where the sound file is stored.
 This creates a two-level indirection with double pointers.
 */

@property (readonly)    SystemSoundID   clickSoundID;
/*
 We define _clickSoundID as an instance variable pointing to the pointer
 containing the memory location where the sound file is stored.
 This creates a two-level indirection with double pointers.
 */

@property (readonly)    SystemSoundID   applaudSoundID;

/*
 CFURL (Core Foundation Uniform Resource Locator) "provides facilities for creating,
 parsing, and dereferencing URL strings. CFURL is useful to applications that need
 to use URLs to access resources, including local files." [Apple]
 
 CFURLRef is a C programming language type and is provided in Core Foundation, which
 provides code in lower-level C framework.
 */
@property (readwrite)   CFURLRef        soundFileURLRef;
- (IBAction)buttonPressed:(UIButton *)sender;


@end

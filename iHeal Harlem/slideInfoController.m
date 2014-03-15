//
//  slideInfoController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 3/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "slideInfoController.h"
#import "getPresentationData.h"
#import "slideInfo.h"

@interface slideInfoController ()
@property (strong, nonatomic) IBOutlet UITextView *infoTextField;
@property (strong, nonatomic) IBOutlet UIImageView *slideImage;

@end

@implementation slideInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // we KNOW the type is an info slide, so get info based on that.
    // ... but must make a SPECIFIC public method in shared data to return a slideInfo type...
    slideInfo *currentSlide = [getPresentationData dataShared].getCurrentSlideInfo;
    
    //slideInfo *currentSlide = [getPresentationData dataShared].getCurrentSlideInfo;
    NSLog(@"stuffzz? %@\n",currentSlide.text);
    
    self.slideImage.image = [UIImage imageNamed:currentSlide.image];
    self.infoTextField.text = currentSlide.text;
    // self.navbar.title.text = currentSlide.title;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

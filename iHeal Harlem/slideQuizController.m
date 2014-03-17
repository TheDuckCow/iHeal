//
//  slideQuizController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 3/16/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "slideQuizController.h"
#import "getPresentationData.h"
#import "slideInfoController.h"
#import "slideQuiz.h"

@interface slideQuizController ()

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITableView *answersTable;
@property (strong, nonatomic) IBOutlet UIButton *flagButton;

- (IBAction)previousSlide:(UIButton *)sender;
- (IBAction)nextSlide:(UIButton *)sender;

- (IBAction)info:(UIButton *)sender;
- (IBAction)languageButton:(UIButton *)sender;
- (IBAction)flagToggle:(UIButton *)sender;

@end

@implementation slideQuizController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)previousSlide:(UIButton *)sender {
    
    // NEED to verify the TYPES of the next slide.. perhaps that should be equiv return type,
    // or next time call current slide type function
    int result = [getPresentationData dataShared].setPreviousSlide;
    if (result == 0){
        slideInfoController *slideInfo =[self.storyboard instantiateViewControllerWithIdentifier:@"slideInfoID"];
        // ONCE we get the right segue style, will be of the form below
        //[self.navigationController pushViewController:slideInfo animated:YES];
        //for now..
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        NSLog(@"Return to menu!");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)nextSlide:(UIButton *)sender {
    int result = [getPresentationData dataShared].setNextSlide;
    if (result == 0){
        slideInfoController *slideInfo =[self.storyboard instantiateViewControllerWithIdentifier:@"slideInfoID"];
        [self.navigationController pushViewController:slideInfo animated:YES];
        //[self.navigationController modalTransitionStyle]; // not right.. but something like this
    }
    else{
        NSLog(@"Return to menu!");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)info:(UIButton *)sender {
}

- (IBAction)languageButton:(UIButton *)sender {
}

- (IBAction)flagToggle:(UIButton *)sender {
    // flag is toggled to this state below
    bool flagState = [getPresentationData dataShared].toggleCurrentSlideFlag;
    
    if (flagState){
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagSet.png"] forState:UIControlStateNormal];
    }
    else{
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagClear.png"] forState:UIControlStateNormal];
    }
}

@end

//
//  IHHaboutPage.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 3/29/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "IHHaboutPage.h"
#import "getPresentationData.h"

@interface IHHaboutPage ()
@property (strong, nonatomic) IBOutlet UITextView *textAbout;

@property (strong, nonatomic) IBOutlet UITextView *textGAI;
@property (strong, nonatomic) IBOutlet UITextView *textCredits;
- (IBAction)gaiPress:(UIButton *)sender;
- (IBAction)jumpFirstSlide:(UIButton *)sender;
- (IBAction)jumpQuizSlide:(UIButton *)sender;
- (IBAction)reviewSlides:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *jumpFirstSlideButton;
@property (strong, nonatomic) IBOutlet UIButton *jumpQuizSlideButton;
@property (strong, nonatomic) IBOutlet UIButton *reviewSlidesButton;

@end

@implementation IHHaboutPage

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
    
    // set localized strings
    NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
    self.title = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutPageTitle"];
    self.textAbout.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutTextMain"];
    self.textGAI.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutDevGAI"];
    self.textCredits.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutCredits"];
    
    // set localized buttons...
    NSString *str = [[getPresentationData dataShared] getLocalName: lang forKey:@"jumpFirstSlide"];
    [self.jumpFirstSlideButton setTitle: str forState:UIControlStateNormal];
    [self.jumpFirstSlideButton setTitle: str forState:UIControlStateSelected];
    
    str = [[getPresentationData dataShared] getLocalName: lang forKey:@"jumpQuizSlide"];
    [self.jumpQuizSlideButton setTitle: str forState:UIControlStateNormal];
    [self.jumpQuizSlideButton setTitle: str forState:UIControlStateSelected];
    
    str = [[getPresentationData dataShared] getLocalName: lang forKey:@"reviewSlides"];
    [self.reviewSlidesButton setTitle: str forState:UIControlStateNormal];
    [self.reviewSlidesButton setTitle: str forState:UIControlStateSelected];
    
    
}

- (IBAction)gaiPress:(UIButton *)sender {
    // jump to web browser to show Global Apps Page
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://globalappinitiative.org/"]];
}


- (IBAction)jumpFirstSlide:(UIButton *)sender {
    [[getPresentationData dataShared] setPresentationSlide: 0];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)jumpQuizSlide:(UIButton *)sender {
    
    [[getPresentationData dataShared] jumpToFirstQuizSlide];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)reviewSlides:(UIButton *)sender {
    UIViewController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"reviewFlagsContID"];
    //[self presentViewController:nextView animated:YES completion:nil];
    [self.navigationController pushViewController:nextView animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

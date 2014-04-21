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
@property (strong, nonatomic) IBOutlet UITextView *textUsage;

@property (strong, nonatomic) IBOutlet UITextView *textGAI;
@property (strong, nonatomic) IBOutlet UITextView *textCredits;
- (IBAction)gaiPress:(UIButton *)sender;

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
    
    // need to load in a random language presentation if one doesn't already exist!
    // alt if none exists, was in menu, assume english.
    
    // set localized strings
    NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
    self.title = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutPageTitle"];
    self.textAbout.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutTextMain"];
    self.textUsage.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutTextUsage"];
    self.textGAI.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutDevGAI"];
    self.textCredits.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"aboutCredits"];
    
}

- (IBAction)gaiPress:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://globalappinitiative.org/"]];
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

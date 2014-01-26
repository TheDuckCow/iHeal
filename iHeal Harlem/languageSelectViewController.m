//
//  languageSelectViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "languageSelectViewController.h"
#import "getPresentationData.h"

@interface languageSelectViewController ()
@property NSArray *languageChoices;
@end

@implementation languageSelectViewController


- (IBAction)unwindToLanguageSelect:(UIStoryboardSegue *)segue
{
    // ie unwinded from the add item view controller
    //XYZAddToDoItemViewController *source = [segue sourceViewController];
    
    //Retrieve the controller’s presentation array...
    
    // set the continue presentation array...
    
}

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
    self.languageChoices = [[NSMutableArray alloc] init]; // need to allocate memory for the array itself!!
    self.languageChoices = [getPresentationData dataShared].getLanguageChoices;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

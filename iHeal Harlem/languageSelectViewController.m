//
//  languageSelectViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "languageSelectViewController.h"

@interface languageSelectViewController ()

@property NSMutableArray *languageChoices;
@end

@implementation languageSelectViewController


- (void) loadLanguageChoices {
    
    [self.languageChoices addObject:@"English"];
    [self.languageChoices addObject:@"French"];
    [self.languageChoices addObject:@"Spanish"];
    
}


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
    [self loadLanguageChoices];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

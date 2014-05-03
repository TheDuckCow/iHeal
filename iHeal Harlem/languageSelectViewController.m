//
//  languageSelectViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "languageSelectViewController.h"
#import "getPresentationData.h"
#import "conditionMenuTableViewController.h"

@interface languageSelectViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableOfLangs;
@property NSArray *languageChoices;
@end

@implementation languageSelectViewController


- (IBAction)unwindToLanguageSelect:(UIStoryboardSegue *)segue
{
    // ie unwinded from the add item view controller
    //XYZAddToDoItemViewController *source = [segue sourceViewController];
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
    [[getPresentationData dataShared] setLanguageNames];
    
    self.languageChoices = [getPresentationData dataShared].getLanguageChoices;
    
    NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
    self.title = [[getPresentationData dataShared] getLocalName: lang forKey: @"languageSelection"];

    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // one section to return
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // number of presentationts (rows) plus extra info row
    return [self.languageChoices count];
}

- (UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"languageCellStyle";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *languageChoices = [getPresentationData dataShared].getLanguageUINames;
    
    
    // perhaps add some exception handling?? if invalid number of languages returned e.g...
    UILabel *langName = (UILabel *)[cell viewWithTag:42];
    NSString *temp = languageChoices[indexPath.row];
    langName.text = temp;
    
    // make background transparent
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.0];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@" yo %i",indexPath.row);
    NSMutableArray *choices = [getPresentationData dataShared].getLanguageChoices;
    NSString *PresentationKeyname = [getPresentationData dataShared].getPresentationKeyname;
    //NSString *conditionPlist = [[self.menuTitles objectAtIndex:indexPath.row]
                               //stringByAppendingFormat:@" (#%d)", currentIndex+1];
    
    NSString *conditionPlist = [NSString stringWithFormat:@"%@.%@", PresentationKeyname,choices[indexPath.row]];
    //NSLog(@"PLIST: %@",conditionPlist);
    if (![[[getPresentationData dataShared] activePlist] isEqual: conditionPlist]){
        [[getPresentationData dataShared] replacePresentation: conditionPlist];
    }
    
    // immediately set the new language title of slide in nav bar
    NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
    self.title = [[getPresentationData dataShared] getLocalName: lang forKey: @"languageSelection"];
    
    
    // "pop" this view
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}



// everytime the view shows up (e.g. after a navbar stack pop), reload the table cells!
// necessary to keep the string in "continue" slide up to date
- (void) viewDidAppear:(BOOL)animated{
    [self.tableOfLangs reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

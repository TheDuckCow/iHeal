//
//  conditionMenuTableViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "conditionMenuTableViewController.h"
#import "getPresentationData.h"
#import "slideController.h"
//#import <QuartzCore/QuartzCore.h>

@interface conditionMenuTableViewController ()
@property NSArray *menuTitles;
@property NSArray *menuKeys;
@end

@implementation conditionMenuTableViewController


- (IBAction)unwindToConditionMenu:(UIStoryboardSegue *)segue
{
    // ie unwinded from the add item view controller
    //XYZAddToDoItemViewController *source = [segue sourceViewController];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadStuff];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) reloadStuff{
    // get the menu titles, from according plist
    self.menuTitles = [[NSMutableArray alloc] init];
    self.menuKeys = [[NSMutableArray alloc]init];
    NSDictionary *menuDict = [getPresentationData dataShared].getMenuTitles;
    //self.self.menuTitles = [getPresentationData dataShared].getMenuTitles;
    
    // set navigation title
    NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
    self.title = [[getPresentationData dataShared] getLocalName: lang forKey: @"presentationMenu"];
    
    self.self.menuTitles = [menuDict objectForKey:@"titles"];
    self.self.menuKeys = [menuDict objectForKey:@"keys"];
    
    // set background image
    UIImage *image = [UIImage imageNamed:@"background_1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first cell should be startPresID, second should be cellID
    NSString *CellIdentifier = @"cellID";
    
    // special size/font for the first cell
    if (indexPath.row==0){
        CellIdentifier = @"startPresID";
    }
    
    // identifier
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // set transparent background color
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    // originally first cell was green... but that's misleading! have them all the same... perhaps even add buttons to them
    /*
    if (indexPath.row==0){
        cell.backgroundColor = [UIColor colorWithRed:224/255.0 green:243/255.0 blue:176/255.0 alpha:0.25];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    }
     */
    
    // Get the label for the cell
    NSString *menuKey = [self.menuKeys objectAtIndex:indexPath.row];
    
    int currentIndex = [getPresentationData dataShared].getCurrentSlideIndex;
    if ([menuKey isEqual: @"continue" ]){
        NSString *menuSelection = [[self.menuTitles objectAtIndex:indexPath.row]
                                   stringByAppendingFormat:@" (#%d)", currentIndex+1];
        cell.textLabel.text = menuSelection;
    }
    else{
        // default general case
        NSString *menuSelection = [self.menuTitles objectAtIndex:indexPath.row];
        cell.textLabel.text = menuSelection;
    }
    
    //cell.textLabel.layer.borderWidth=1.0f;
    //cell.textLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    
    return cell;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 220;
    return 70;
}

// everytime the view shows up (e.g. after a navbar stack pop), reload the table cells!
// necessary to keep the string in "continue" slide up to date
- (void) viewWillAppear:(BOOL)animated{
    [self reloadStuff];
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // determine which option was selected
    
    // since "Start Presentation" is first element of table, but not represented in the plist
    // first entry in plist typically "continue", which will be index 0
    NSString *nextController = @"slideContID";
    
    NSString *menuSelection = [self.menuKeys objectAtIndex:indexPath.row];
    if ([menuSelection  isEqual: @"startPresentation"]){
        
        // first show alert, since this is where presentation really STARTS
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        NSString *alertTitle = [[getPresentationData dataShared] getLocalName: lang forKey: @"alertStartPresTitle"];
        NSString *alertBody = [[getPresentationData dataShared] getLocalName: lang forKey: @"alertStartPresBody"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        
        // special case, if it is "Start Presentation", always first entry
        [[getPresentationData dataShared] setPresentationSlide:0];
        nextController = @"slideContID";
        // sets how the "next" and "previous" slides funciton
        [getPresentationData dataShared].presentationFlowMode = @"linear";
    }
    else if ([menuSelection  isEqual: @"continue"]){
        // do nothing, the correct slide should already be set! > unless later to read from menu.../save
        nextController = @"slideContID";
        // sets how the "next" and "previous" slides funciton
        [getPresentationData dataShared].presentationFlowMode = @"linear";
    }
    else if ([menuSelection  isEqual: @"jumpInfo"]){
        NSLog(@"jumpInfo < does nothing currently");
        nextController = @"slideContID";
        // sets how the "next" and "previous" slides funciton
        [getPresentationData dataShared].presentationFlowMode = @"linear";
    }
    else if ([menuSelection  isEqual: @"jumpQuiz"]){
        //NSLog(@"jumpQuiz");
        int result = [[getPresentationData dataShared] jumpToFirstQuizSlide];
        // not using result, but if -1 means there is no quiz slide in presentation,
        // should just do nothing
        if (result==0){
            nextController = @"slideContID";
            // sets how the "next" and "previous" slides funciton
            [getPresentationData dataShared].presentationFlowMode = @"linear";
        }
        else{
            nextController = @"nil";
            
            // first show alert, since this is where presentation really STARTS
            NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
            NSString *alertTitle = [[getPresentationData dataShared] getLocalName: lang forKey: @"alertNoQuiz"];
            NSString *alertBody = [[getPresentationData dataShared] getLocalName: lang forKey: @"alertPleaseAnother"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }
    }
    else if ([menuSelection isEqual: @"reviewFlags"]){
        nextController = @"reviewFlagsContID";
    }
    
    // if the button returned a valid slide/view to jump to, jumpt to it
    // will do nothing if e.g. seect jump to quiz and no quiz slides in presentation
    if (![nextController isEqual: @"nil"]){
        slideController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:nextController];
        [self.navigationController pushViewController:nextView animated:YES];
    }
}


/*
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

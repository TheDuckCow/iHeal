//
//  conditionMenuTableViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "conditionMenuTableViewController.h"
#import "getPresentationData.h"
#import "slideInfoController.h"
//#import "slideQuizController.h"

@interface conditionMenuTableViewController ()
@property NSArray *menuTitles;
@property NSArray *menuKeys;
@end

@implementation conditionMenuTableViewController


- (IBAction)unwindToConditionMenu:(UIStoryboardSegue *)segue
{
    // ie unwinded from the add item view controller
    //XYZAddToDoItemViewController *source = [segue sourceViewController];
    
    //Retrieve the controller’s presentation array...
    
    // set the continue presentation array...
    
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
    
    // get the menu titles, from according plist
    self.menuTitles = [[NSMutableArray alloc] init];
    self.menuKeys = [[NSMutableArray alloc]init];
    NSDictionary *menuDict = [getPresentationData dataShared].getMenuTitles;
    //self.self.menuTitles = [getPresentationData dataShared].getMenuTitles;
    
    self.self.menuTitles = [menuDict objectForKey:@"titles"];
    self.self.menuKeys = [menuDict objectForKey:@"keys"];
    
    // set background image
    UIImage *image = [UIImage imageNamed:@"background_1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    // need to make the image NOT stretched!
    //[tableView setContentMode:UIViewContentModeScaleAspectFit]; // does nothing..
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    // generated lines
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Get the label for the cell
    NSString *menuSelection = [self.menuTitles objectAtIndex:indexPath.row];
    cell.textLabel.text = menuSelection;
    
    // set transparent background color
    UIColor *transparent = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    cell.backgroundColor = transparent;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // now determine which view to go to based on what you clicked..
    // i.e. do the slides array calculations etc and then just check type to go to next
    // and load that view controller!
    
    // determine which option was selected
    
    // since "Start Presentation" is first element of table, but not represented in the plist
    // first entry in plist typically "continue", which will be index 0
    int usableIndex =indexPath.row;
    
    NSString *menuSelection = [self.menuKeys objectAtIndex:usableIndex];
    if ([menuSelection  isEqual: @"startPresentation"]){
        // special case, if it is "Start Presentation", always first entry
        [[getPresentationData dataShared] setPresentationSlide:0];
    }
    else if ([menuSelection  isEqual: @"continue"]){
        // do nothing, the correct slide should already be set! > unless later to read from menu.../save
        NSLog(@"");
    }
    else if ([menuSelection  isEqual: @"jumpInfo"]){
        NSLog(@"jumpInfo");
    }
    
    
    // ## determine here which is the next slide type to start....
    // can be quiz type, e.g.
    
    NSString *slideType = [getPresentationData dataShared].getSlideType;
    if ([slideType isEqual:@"info"]){
        slideInfoController *slideInfo =[self.storyboard instantiateViewControllerWithIdentifier:@"slideInfoID"];
        [self.navigationController pushViewController:slideInfo animated:YES];
    }
    // for quiz/other types of slides...
    /*
    else if([slideType isEqual:@"quiz"]){
        slideQuizController *quizInfo =[self.storyboard instantiateViewControllerWithIdentifier:@"slideQuizID"];
        [self.navigationController pushViewController:quizInfo animated:YES];
    }
    */
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

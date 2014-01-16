//
//  conditionMenuTableViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "conditionMenuTableViewController.h"

@interface conditionMenuTableViewController ()
@property NSMutableArray *menuTitles;

@end

@implementation conditionMenuTableViewController


- (IBAction)unwindToConditionMenu:(UIStoryboardSegue *)segue
{
    // ie unwinded from the add item view controller
    //XYZAddToDoItemViewController *source = [segue sourceViewController];
    
    //Retrieve the controller’s presentation array...
    
    // set the continue presentation array...
    
}


- (NSArray *)pastalColorArray
{
    UIColor *pastalOrange =     [UIColor colorWithRed:254/255.0 green:235/255.0 blue:201/255.0 alpha:1];
    UIColor *pastalYellow =     [UIColor colorWithRed:255/255.0 green:255/255.0 blue:176/255.0 alpha:1];
    UIColor *pastalGreen =      [UIColor colorWithRed:224/255.0 green:243/255.0 blue:176/255.0 alpha:1];
    UIColor *pastalCyan =       [UIColor colorWithRed:179/255.0 green:226/255.0 blue:221/255.0 alpha:1];
    UIColor *pastalBlue =       [UIColor colorWithRed:191/255.0 green:213/255.0 blue:232/255.0 alpha:1];
    UIColor *pastalMagenta =    [UIColor colorWithRed:221/255.0 green:212/255.0 blue:232/255.0 alpha:1];
    
    NSArray *colorArray = @[pastalOrange,pastalYellow,pastalGreen,pastalCyan,pastalBlue,pastalMagenta];
    
    return colorArray;
}

- (void) loadMenuTitles {
    
    [self.menuTitles addObject:@"Start Presentation"];
    [self.menuTitles addObject:@"Continue Presentation"];
    [self.menuTitles addObject:@"Jumo to slide x/x: 'title'"];
    [self.menuTitles addObject:@"Jump to first quiz slide"];
    
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
    self.menuTitles = [[NSMutableArray alloc] init]; // need to allocate memory for the array itself!!
    [self loadMenuTitles];
    
    
    //self.conditionMenuTableViewController.backgroundView = nil;
    //[self.backgroundcolor = [UIColor colorWithRed:221/255.0 green:212/255.0 blue:232/255.0 alpha:1]];
    // >> trying to find out how to set the background color...
    // http://stackoverflow.com/questions/6724243/uitableview-background-color
    
    
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
    // but I want it to change.. first cell should be startPresID, second should be cellID
    NSString *CellIdentifier = @"cellID";
    
    // special size/font for the first cell
    if (indexPath.row==0){
        CellIdentifier = @"startPresID";
    }
    
    // tends to crash on this (... generated...) line.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get the name of the cell
    NSString *menuSelection = [self.menuTitles objectAtIndex:indexPath.row];
    cell.textLabel.text = menuSelection;
    
    NSArray *colorArray = [self pastalColorArray];
    
    int modInt = indexPath.row % [colorArray count];
    cell.backgroundColor = colorArray[[colorArray count]-modInt-1];
    
    return cell;
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

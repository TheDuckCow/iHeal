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

@interface conditionMenuTableViewController ()
@property NSArray *menuTitles;
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
    self.menuTitles = [[NSMutableArray alloc] init]; // need to allocate memory for the array itself!!
    //self.menuTitles = self.dataObj.getMenuTitles;
    self.self.menuTitles = [getPresentationData dataShared].getMenuTitles;
    
    
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
    
    // tends to crash on this (... generated...) line.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Get the label for the cell
    NSString *menuSelection = [self.menuTitles objectAtIndex:indexPath.row];
    cell.textLabel.text = menuSelection;
    
    // set transparent background color
    UIColor *transparent = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    cell.backgroundColor = transparent;
    
    
    
    // OLD code that was used to 'randomly' set the background color of the table.
    /*
    // get the color array from the singleton
    NSArray *colorArray = [getPresentationData dataShared].getPastalColorArray;
    
    int modInt = indexPath.row % [colorArray count];
    cell.backgroundColor = colorArray[[colorArray count]-modInt-1];
     */
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // now determine which view to go to based on what you clicked..
    // i.e. do the slides array calculations etc and then just check type to go to next
    // and load that view controller!
    
    
    slideInfoController *slideInfo =[self.storyboard instantiateViewControllerWithIdentifier:@"slideInfoID"];
    [self.navigationController pushViewController:slideInfo animated:YES];
    
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

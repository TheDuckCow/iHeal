//
//  conditionListTableViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "conditionListTableViewController.h"
#import "getPresentationData.h"

@interface conditionListTableViewController ()

@property NSMutableArray *conditionsList;

@end

@implementation conditionListTableViewController


- (IBAction)unwindToConditionList:(UIStoryboardSegue *)segue
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
    self.conditionsList = [[NSMutableArray alloc] init]; // need to allocate memory for the array itself!!
    
    // get the shared list data from the singleton
    self.conditionsList = [getPresentationData dataShared].conditionsList;
    
    /*
    // Add the TEST label object to the view
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
    testLabel.text = @"random test label, please ignore"; // original, works
    [self.view addSubview:testLabel];
    */
    
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
    // one section to return.. actually, 2 sections would be good for the info stuff
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // number of presentationts (rows) plus extra info row
    return [self.conditionsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get the name of the cell and set colors
    NSString *condition = [self.conditionsList objectAtIndex:indexPath.row];
    
    
    //NSString *condition = [[getPresentationData shared].conditionsList;
    cell.textLabel.text = condition;
    
    
    // get the color array from the singleton
    NSArray *colorArray = [getPresentationData dataShared].getPastalColorArray;
    
    // set the color of the current slide by mod function
    int modInt = indexPath.row % [colorArray count];
    cell.backgroundColor = colorArray[modInt];
    
     
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

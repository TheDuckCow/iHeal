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

    
    // set background image
    UIImage *image = [UIImage imageNamed:@"background_1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    // need to make the image NOT stretched!
    //[tableView setContentMode:UIViewContentModeScaleAspectFit]; // does nothing..
    
    UIColor *skyeBlue =    [UIColor colorWithRed:78/255.0 green:193/255.0 blue:239/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = skyeBlue;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
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
    // one section to return.. actually, 2 sections would be good for the info stuff/credits
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
    
    UIColor *transparent = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    cell.backgroundColor = transparent;
    
    
    // OLD code to 'randomly' set color of the cell, no variance now.
    /*
    // get the color array from the singleton
    NSArray *colorArray = [getPresentationData dataShared].getPastalColorArray;
    
    // set the color of the current slide by mod function
    int modInt = indexPath.row % [colorArray count];
    cell.backgroundColor = colorArray[modInt];
    */
    
    // have right-aligned stuff, need custom cell view layout to do this!
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    // CONVERT THIS TO BE DONE IN DATA CLASS
    // just pass in the string here to set which one.... assume english for now?
    
    NSString *plistName = @"Asthma.english"; // should get this/parse from indexPath.row of array.
    // option for combining strings:
    //[NSString stringWithFormat:@"%@/%@/%@", three, two, one];
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *attr = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSLog(@"check key>> %@", attr[@"testString"]);
    [getPresentationData replacePresentation:attr[@"slides"]];
    
    
    
    
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

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
    // for setting white color for status bar [do one or the other of the below]
    self.conditionsList = [[NSMutableArray alloc] init]; // need to allocate memory for the array itself!!
    
    // get the shared list data from the singleton
    self.conditionsList = [getPresentationData dataShared].conditionsList;
     
    // set background image
    UIImage *image = [UIImage imageNamed:@"background_1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    
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

    NSString *conditionKey = [self.conditionsList objectAtIndex:indexPath.row];
    
    if ( [conditionKey isEqual: @"aboutPageTitle"]){
        // last case, is the about page
        cell.textLabel.text = [[getPresentationData dataShared] getLocalName: @"english" forKey: conditionKey];
    }
    else{
        // normal get condition proper name (not just programming key name)
        cell.textLabel.text = [[getPresentationData dataShared] getTitleForPresentationKey:conditionKey];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (NO){//indexPath.row == [self.conditionsList count]-1){

        [[getPresentationData dataShared] setActiveLanguage: @"asthma.english"];
        UIViewController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"appInfoPageID"];
        [self.navigationController pushViewController:nextView animated:YES];
    }
    else{
        // load the according languages
        self.conditionsList = [getPresentationData dataShared].getPresentationsList;
        // Load the presentation with an according language
        NSString *presentation = self.conditionsList[indexPath.row];
        
        // reload the presentaiton based on this
        //NSLog(@"CondListContr> hard coded assuming english pres exists..  need to use existing plist at first!");
        [[getPresentationData dataShared] replacePresentation:[NSString stringWithFormat:@"%@.english",presentation]];
        
        [getPresentationData dataShared].activeConditionName = self.conditionsList[indexPath.row];
        
        // go to the next view
        UIViewController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"slideContID"];
        [self.navigationController pushViewController:nextView animated:YES];
    }
}



- (IBAction)unwindToConditionList:(UIStoryboardSegue *)segue
{
    // ie unwinded from the add item view controller
    //XYZAddToDoItemViewController *source = [segue sourceViewController];
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

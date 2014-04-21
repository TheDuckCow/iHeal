//
//  IHHReviewSlidesTableViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 3/26/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "IHHReviewSlidesTableViewController.h"
#import "getPresentationData.h"
#import "slideController.h"

@interface IHHReviewSlidesTableViewController ()
@property NSMutableArray *flagList;
@end

@implementation IHHReviewSlidesTableViewController

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
    
    self.flagList = [[NSMutableArray alloc]init];
    self.title = @"Review Flagged Slides";
    UIImage *image = [UIImage imageNamed:@"background_1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    
    UITableView *tableView = (UITableView*)self.view;
    tableView.backgroundView = imageView;
    
    
    // get flagged slides information
    //[self.flagList removeAllObjects];
    //self.flagList = [[getPresentationData dataShared] getFlagedSlides];
    //NSLog(@"THINGS: %@",self.flagList);
    
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.flagList count];
}

- (void) viewWillAppear:(BOOL)animated{
    [self.flagList removeAllObjects];
    // -2 case adds the "Clear flags" option
    [self.flagList addObject:[NSNumber numberWithInt:-2]];
    
    // do the rest, check if empty
    NSMutableArray *tmp = [[getPresentationData dataShared] getFlagedSlides];
    for (int i=0; i< [tmp count]; i++){
        NSNumber *n=tmp[i];
        [self.flagList addObject:n];
    }
    if (self.flagList==NULL){
        [self.flagList addObject:[NSNumber numberWithInt:-1]];
    }
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"reviewFlagCell";
    
    // link the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSNumber *num = self.flagList[indexPath.row];
    NSString *label;
    if (num.integerValue==-1){
        // empty list case
        label = @"No flagged slides!"; // never reached... but if did, need to localize it
    }
    else if (num.integerValue == -2){
        
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        label = [[getPresentationData dataShared] getLocalName: lang forKey: @"clearAllFlags"];
        CellIdentifier = @"reviewFlagCellStart";
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.backgroundColor = [UIColor colorWithRed:254/255.0 green:235/255.0 blue:201/255.0 alpha:0.25];
    }
    else{
        // typical case
        [[getPresentationData dataShared] setPresentationSlide: (int)num.integerValue];
        label = [[getPresentationData dataShared] getSlideTitle];
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    }
    
    
    cell.textLabel.text = label;
    
    
    return cell;
}


- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 140;
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *num = self.flagList[indexPath.row];
    if (num.integerValue >= 0){
        [[getPresentationData dataShared] setPresentationSlide:(int)num.integerValue];
        
        // sets how the "next" and "previous" slides funciton
        [getPresentationData dataShared].presentationFlowMode = @"flagCheck";
        
        slideController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"slideContID"];
        [self.navigationController pushViewController:nextView animated:YES];
    }
    else if (num.integerValue==-2){
        [[getPresentationData dataShared] clearFlaggedSlides];
        [self.navigationController popViewControllerAnimated:YES];
    }
    // else, no slides were flagged! do nothing...
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
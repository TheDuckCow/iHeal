//
//  languageSelectViewController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "languageSelectViewController.h"
#import "getPresentationData.h"

@interface languageSelectViewController ()
- (IBAction)BYPASSBUTTON:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableOfLangs;
@property NSArray *languageChoices;
@end

@implementation languageSelectViewController


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
    self.languageChoices = [getPresentationData dataShared].getLanguageChoices;
    
    
    self.languageChoices = [[NSMutableArray alloc] init]; // need to allocate memory for the array itself!!
    
    // get the shared list data from the singleton
    self.languageChoices = [getPresentationData dataShared].conditionsList;
    
    // call the table setup method, which gets languages etc
    //[self tableSetup:tableOfLangs];
    
    //[self tableSetup:(UITableView *) cellForRowAtIndexPath:<#(NSIndexPath *)#>];
    //self.tableSetup(* );
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // one section to return.. actually, 2 sections would be good for the info stuff
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // number of presentationts (rows) plus extra info row
    return [self.languageChoices count];
}

- (UITableViewCell *)tableSetup:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get the name of the cell and set colors
    NSString *lang = [self.languageChoices objectAtIndex:indexPath.row];
    
    //NSString *condition = [[getPresentationData shared].conditionsList;
    cell.textLabel.text = lang;
    
    
    
    return cell;
}



// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //[segue conditionMenuTableViewController]
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BYPASSBUTTON:(UIButton *)sender {
    //techncially the contents of this is what each
    //row of languages would do, but for
    // the according selected langauge.
    
    
    // #### CAN't seem to figure out how to call the singlton function here..
    // this may be the thing where it needs to be a + instead of -.. but screws everything up!
    //[[getPresentationData dataShared].replacePresentation @"Asthma.english.plist"];
    //[getPresentationData.replacePresentation: @"Asthma.english.plist"];
    
    
}
@end

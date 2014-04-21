//
//  slideController.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 3/21/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "slideController.h"
#import "slideInfo.h"
#import "slideQuiz.h"
#import "slideIntro.h"
#import "getPresentationData.h"

@interface slideController ()

// the background view for the views themselves
@property (nonatomic,weak) UIView * backgroundView;
@property (strong, nonatomic) IBOutlet UIButton *UInextButton;
@property (strong, nonatomic) IBOutlet UIButton *UIpreviousButton;

// property for allowing to press next button
@property bool allowNext;

// section for intro slide
@property (strong, nonatomic) NSMutableArray *introLangOptions;
@property (strong, nonatomic) IBOutlet UITableView *introTableLangs;

//section for info type slides
@property (strong, nonatomic) IBOutlet UIImageView *infoImage;
@property (strong, nonatomic) IBOutlet UITextView *infoText;

//section for quiz type slides
@property (strong, nonatomic) IBOutlet UILabel *quizQuestion;
@property (strong, nonatomic) IBOutlet UIImageView *quizImageBG;
@property (strong, nonatomic) IBOutlet UITableView *quizAnswerTable;

@property (strong, nonatomic) IBOutlet UITextView *quizExplanation;
@property (strong, nonatomic) IBOutlet UILabel *quizIncorrectLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteBox;

@property (strong, nonatomic) IBOutlet UILabel *quizIncorrectResponse;
@property (strong, nonatomic) IBOutlet UIButton *quizTryAgainOutlet;
@property (strong, nonatomic) IBOutlet UIButton *quizGotoInfoOutlet;
@property (strong, nonatomic) NSMutableArray *answerArray;
@property int quizCorrectSolutionIndex;
@property int gotoInfo;
@property (strong, nonatomic) NSMutableArray *quizTableLabelHeights;

- (IBAction)quizTryAgain:(UIButton *)sender;
- (IBAction)quizGotoInfo:(UIButton *)sender;
// delete later once table is implemented
- (IBAction)correctAnswerBypass:(UIButton *)sender;
- (IBAction)wrongAnswerBypass:(UIButton *)sender;


// general slide/actions
@property (strong, nonatomic) IBOutlet UIButton *flagButton;
@property (strong, nonatomic) IBOutlet UILabel *colorBox;
- (IBAction)nextSlideButton:(UIButton *)sender;
- (IBAction)previousSlideButton:(UIButton *)sender;

- (IBAction)infoButton:(UIButton *)sender;
- (IBAction)languageButton:(UIButton *)sender;
- (IBAction)flagToggle:(UIButton *)sender;

- (void) nextSlide;
- (void) previousSlide;

@end

@implementation slideController

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
    
    self.answerArray = [[NSMutableArray alloc] init];
    
    // set the current slide
    [self setSlide];
    
    
    // setup gestures
    // setup right
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    // setup left
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    
    [self.quizAnswerTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
}


- (void) setSlide{
    
    // set the name of the slide/navigation view number:
    self.title = [getPresentationData dataShared].getSlideTitle;
    
    // assume CAN'T continue until told otherwise
    self.allowNext = FALSE;
    
    //assume there is a next & previous slide
    // (but do check here for beginning or end of presentation
    if ([[getPresentationData dataShared] getCurrentSlideIndex] == 0){
        [self.UIpreviousButton setBackgroundImage:[UIImage imageNamed:@"UI_arrowLeft_end"] forState:UIControlStateNormal];
    }
    else{
        [self.UIpreviousButton setBackgroundImage:[UIImage imageNamed:@"UI_arrowLeft_full"] forState:UIControlStateNormal];
    }
    // set right arrow end or not
    if ( [[getPresentationData dataShared] getCurrentSlideIndex] == [[getPresentationData dataShared] getNumberOfSLides] -1){
        [self.UInextButton setBackgroundImage:[UIImage imageNamed:@"UI_arrowRight_end"] forState:UIControlStateNormal];
    }
    else{
        [self.UInextButton setBackgroundImage:[UIImage imageNamed:@"UI_arrowRight_full"] forState:UIControlStateNormal];
    }
    
    
    // set the flag properly:
    bool flagState = [getPresentationData dataShared].getCurrentSlideFlag;
    //NSLog(@"currentFlag: %i",flagState);  // SOME ISSUES STILL, but toggle works fine..
    if (flagState){
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagSet.png"] forState:UIControlStateNormal];
    }
    else{
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagClear.png"] forState:UIControlStateNormal];
    }
    
    //this checks if there is already a current one; remove it if exists
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
    }
    
    // get the slide type
    NSString *slideType = [getPresentationData dataShared].getSlideType;
    
    // set the information of the slide accordingly
    if ([slideType  isEqual: @"info"]){
        // always allow to select next on info slide;
        self.allowNext=TRUE;
        
        //set the view
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"slideInfoView" owner:self options:nil][0];
        self.backgroundView = view;
        [self.view  insertSubview:view atIndex:0];
        
        // get the infoSlide data
        slideInfo *infoSlide = [getPresentationData dataShared].getCurrentSlideInfo;
        
        
        //
        // only set image if one is supplied (non nill read-in)
        if (infoSlide.image != nil){
            self.infoImage.image = [UIImage imageNamed:infoSlide.image];
            self.infoImage.alpha = 1;
        }
        else{
            self.quizImageBG.alpha = 0;
        }

        
        self.infoText.text = infoSlide.text;
        self.colorBox.backgroundColor = [UIColor colorWithRed:225/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
        
        
    }
    else if ([slideType  isEqual: @"quiz"]){
        
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"slideQuizView" owner:self options:nil][0];
        self.backgroundView = view;
        [self.view  insertSubview:view atIndex:0];
        
        slideQuiz *quizSlide = [getPresentationData dataShared].getCurrentSlideQuiz;
        
        [self.answerArray removeAllObjects];
        for (int i=0; i< [quizSlide.answers count]; i++){
            [self.answerArray addObject: quizSlide.answers[i]];
            //NSLog(@"> ZN: %@, %@\nE:",quizSlide.answers[i],self.answerArray);
        }
        //reload table.. later move into else clause (when it would be visible)
        [self.quizAnswerTable reloadData];
        
        self.gotoInfo = quizSlide.slideRef;
        self.quizQuestion.text = quizSlide.question;
        
        // only set image if one is supplied (non nill read-in)
        if (quizSlide.image != nil){
            self.quizImageBG.image = [UIImage imageNamed:quizSlide.image];
            self.quizImageBG.alpha = 1;
        }
        else{
            self.quizImageBG.alpha = 0;
        }
        self.quizCorrectSolutionIndex = quizSlide.solution;
        
        self.allowNext = quizSlide.didAnswerCorrect;    //false by initalization
        // these two only show up iff user gave incorrect answer on, after interacting
        self.quizTryAgainOutlet.alpha = 0;
        self.quizGotoInfoOutlet.alpha = 0;
        self.quizIncorrectResponse.alpha = 0;
        self.whiteBox.alpha = 0;
        
        // set the try again/goto titles
        // set reandom strings that only need setting once
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        NSString *str;
        str = [[getPresentationData dataShared] getLocalName: lang forKey:@"quizTryAgain"];
        [self.quizTryAgainOutlet setTitle: str forState:UIControlStateNormal];
        [self.quizTryAgainOutlet setTitle: str forState:UIControlStateSelected];
        str = [[getPresentationData dataShared] getLocalName: lang forKey:@"quizReturnToInfo"];
        [self.quizGotoInfoOutlet setTitle: str forState:UIControlStateNormal];
        [self.quizGotoInfoOutlet setTitle: str forState:UIControlStateSelected];
        str = [[getPresentationData dataShared] getLocalName: lang forKey:@"quizIncorrect"];
        self.quizIncorrectResponse.text = str;
        self.quizIncorrectResponse.text =str;
        
        
        
        if (self.allowNext==TRUE){
             //NSLog(@"past correct answer");
            // already answered correctly once
            self.quizExplanation.text = quizSlide.explanation;
            self.quizExplanation.alpha = 1;
            self.quizAnswerTable.alpha = 0;
            
            // set color transparent backgorund of thing to pastel green
            self.colorBox.backgroundColor = [UIColor colorWithRed:224/255.0 green:243/255.0 blue:176/255.0 alpha:0.5];
            
        }
        else{
            // did not answer correctly yet/not yet answered, set next arrow accordingly
            [self.UInextButton setBackgroundImage:[UIImage imageNamed:@"UI_arrowRight_empty"] forState:UIControlStateNormal];
            
            self.quizExplanation.alpha = 0;
            self.quizAnswerTable.alpha = 1;
            
            //fill table with info...
            // set color of transparent background thing to neutral
            self.colorBox.backgroundColor = [UIColor colorWithRed:225/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
            
            
        }
        
        // moar things..
        // table reload...

    }
    else if ([slideType  isEqual: @"intro"]){
        
        // always allow to select next on info slide;
        self.allowNext=TRUE;
        
        // get the view data
        slideIntro *introSlide = [getPresentationData dataShared].getCurrentSlideIntro;
        
        // set the background view
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"slideIntroView" owner:self options:nil][0];
        self.backgroundView = view;
        [self.view  insertSubview:view atIndex:0];
        
        // do the setup stuff
        [self.introLangOptions removeAllObjects];
        for (int i=0; i< [introSlide.langOptions count]; i++){
            [self.introLangOptions addObject: introSlide.langOptions[i]];
            //NSLog(@"> ZN: %@, %@\nE:",quizSlide.answers[i],self.answerArray);
        }
        //reload table.. later move into else clause (when it would be visible)
        [self.introTableLangs reloadData];
        
    }
    // else if another type of slide, add here..
    
    
}


- (IBAction)previousSlideButton:(UIButton *)sender {
    
    [self previousSlide];
}

- (IBAction)nextSlideButton:(UIButton *)sender {
    
    [self nextSlide];
}



- (IBAction)infoButton:(UIButton *)sender {
    // push the info view controller
    UIViewController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"appInfoPageID"];
    [self.navigationController pushViewController:nextView animated:YES];
    
}

- (IBAction)languageButton:(UIButton *)sender {
    //[self.navigationController popToViewController:@"languageSelectViewController" animated:YES];
    // setup in storyboard to unwind to languages controller
    // by control dragging button to green exit on self viewController,
    // and then selecting which one to unwind to
    
}

- (IBAction)flagToggle:(UIButton *)sender {
    // flag is toggled to this state below
    bool flagState = [getPresentationData dataShared].toggleCurrentSlideFlag;
    
    if (flagState){
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagSet.png"] forState:UIControlStateNormal];
    }
    else{
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagClear.png"] forState:UIControlStateNormal];
    }
}

- (void) flagSet:(bool)state{
    // flag is toggled to this state below
    [[getPresentationData dataShared] setCurrentSlideFlag:state];
    
    if (state){
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagSet.png"] forState:UIControlStateNormal];
    }
    else{
        [self.flagButton setBackgroundImage:[UIImage imageNamed:@"UI_flagClear.png"] forState:UIControlStateNormal];
    }
    
}




/////////////////////////////////////////////////////////////////////////////////
// declare stuff for the UITable in the quiz table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // one section to return
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // number of presentationts (rows) plus extra info row
    //[self setSlide]; // otherwise won't get the info right...
    return [self.answerArray count];
}

- (UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cell";
    
    // this generates the cell identifier, not in storyboard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSArray *letters = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",nil];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",letters[indexPath.row],self.answerArray[indexPath.row]];;
    [self.quizTableLabelHeights addObject: [NSNumber numberWithInteger:cell.textLabel.numberOfLines]];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:25];
    
    
    
     // technically should do this to be safe, in case number is 0
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // make background transparent
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.3];
    
    return cell;
     
}





- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dynamic height stuff
    //tableView width - left border width - accessory indicator - right border width
    CGFloat width = tableView.frame.size.width - 15 - 30 - 15;
    UIFont *font = [UIFont systemFontOfSize:26];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.answerArray[indexPath.row] attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    size.height = ceilf(size.height);
    size.width  = ceilf(size.width);
    return size.height + 24;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // check the current object to see if it's the right one,
    int tmp = self.quizCorrectSolutionIndex;
    bool correct=NO;
    if (indexPath.row == tmp){
        correct=YES;
    }
    
    if (correct){
        // case that they answered correctly, show explanation,
        [self quizDidAnswerCorrect];
    }
    else {
        [self quizDidAnswerIncorrect];
    }
    
}



- (void) quizDidAnswerCorrect{
    
    // answered correctly, allow next to appear
    self.allowNext = [[getPresentationData dataShared] quizDidAnswerCorrect];
    [self setSlide];
}

- (void) quizDidAnswerIncorrect{
    
    // answered incorrectly
    self.colorBox.backgroundColor = [UIColor colorWithRed:254/255.0 green:235/255.0 blue:201/255.0 alpha:0.5];
    self.quizExplanation.alpha = 0;
    self.quizAnswerTable.alpha = 0;
    self.whiteBox.alpha = 1;

    self.quizTryAgainOutlet.alpha = 1;
    self.quizGotoInfoOutlet.alpha = 1;
    self.quizIncorrectResponse.alpha = 1;
    
    
    [self flagSet:YES];
}


- (void)nextSlide{
    
    // case that you CAN press for the next slide
    if (self.allowNext==TRUE){
        int result = [getPresentationData dataShared].setNextSlide;
        if (result == 0){
            [self setSlide];
        }
        else{
            // result -1, reached end of presentation
            //NSLog(@"Return to menu!");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    // case that you CAN'T press for the next slide, show notificaiton
    else{
        //NSLog(@"ALTERTVIEW: you must attempt to answer quiz question first\n");
    }
}


- (void)previousSlide {
    
    // decrement the slide index, then check that
    int result = [getPresentationData dataShared].setPreviousSlide;
    if (result == 0){
        // set the slide
        [self setSlide];
    }
    else{
        // -1, we reached the beginning of the presentation, return to menu
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self nextSlide];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self previousSlide];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)correctAnswerBypass:(UIButton *)sender {
    // sets the didAnswerCorrect quiz object field to true, returns it
    [self quizDidAnswerCorrect];
}

- (IBAction)wrongAnswerBypass:(UIButton *)sender {
    // show incorrect view thing
    [self quizDidAnswerIncorrect];
}

- (IBAction)quizTryAgain:(UIButton *)sender {
    
    [self setSlide];
}
- (IBAction)quizGotoInfo:(UIButton *)sender {
    [[getPresentationData dataShared] setPresentationSlide:self.gotoInfo];
    [self setSlide];
}
@end

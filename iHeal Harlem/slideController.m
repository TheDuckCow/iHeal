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
#import "slideOutro.h"
#import "getPresentationData.h"

@interface slideController ()

// the background view for the views themselves
@property (nonatomic,weak) UIView * backgroundView;
@property (strong, nonatomic) IBOutlet UIButton *UInextButton;
@property (strong, nonatomic) IBOutlet UIButton *UIpreviousButton;

// property for allowing to press next button
@property bool allowNext;

// section for intro slide
@property (strong, nonatomic) IBOutlet UILabel *introWelcomeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *introDemoAnimation;
@property (strong, nonatomic) IBOutlet UITextView *introTextUsage;
@property (strong, nonatomic) IBOutlet UIImageView *introImgseqA;
@property (strong, nonatomic) IBOutlet UIImageView *introImgseqB;
@property (strong, nonatomic) IBOutlet UIImageView *introImgseqC;
@property (strong, nonatomic) IBOutlet UILabel *introLabelLeft;
@property (strong, nonatomic) IBOutlet UILabel *introLabelCenter;
@property (strong, nonatomic) IBOutlet UILabel *introLabelRight;



//section for info type slides
@property (strong, nonatomic) IBOutlet UIImageView *infoImage;
@property (strong, nonatomic) IBOutlet UITextView *infoText;

//section for quiz type slides
@property (strong, nonatomic) IBOutlet UILabel *quizQuestion;
@property (strong, nonatomic) IBOutlet UIImageView *quizImageBG;
@property (strong, nonatomic) IBOutlet UITableView *quizAnswerTable;
@property (strong, nonatomic) IBOutlet UITextView *quizExplanation;
@property (strong, nonatomic) IBOutlet UIButton *quizGotoInfoOutlet;
@property (strong, nonatomic) NSMutableArray *answerArray;
@property int quizCorrectSolutionIndex;
@property (strong, nonatomic) IBOutlet UITextView *showCorrectLabel;
@property int gotoInfo;
@property (strong, nonatomic) NSMutableArray *quizTableLabelHeights;

- (IBAction)quizGotoInfo:(UIButton *)sender;
// delete later once table is implemented
- (IBAction)correctAnswerBypass:(UIButton *)sender;
- (IBAction)wrongAnswerBypass:(UIButton *)sender;


// for outro slide
@property (strong, nonatomic) IBOutlet UILabel *outroCongratsLabel;
@property (strong, nonatomic) IBOutlet UITextView *outroEndText;
@property (strong, nonatomic) IBOutlet UIButton *outroFlagReviewButton;
@property (strong, nonatomic) IBOutlet UIButton *returnToMenuButton;
@property (strong, nonatomic) IBOutlet UIImageView *outroImage;
- (IBAction)outroReviewFlags:(UIButton *)sender;
- (IBAction)returnToMenu:(UIButton *)sender;


// general slide/actions
@property (strong, nonatomic) IBOutlet UIButton *flagButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UIImageView *blinkHighlightForward;
@property (strong, nonatomic) IBOutlet UIButton *UIworldButton;
@property (strong, nonatomic) IBOutlet UILabel *colorBox;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UIButton *clearFlagBannerButton;
@property (strong, nonatomic) IBOutlet UIImageView *blinkHighlightNextImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)nextSlideButton:(UIButton *)sender;
- (IBAction)previousSlideButton:(UIButton *)sender;
- (void) nextSlide;
- (void) previousSlide;

- (IBAction)infoButton:(UIButton *)sender;
- (IBAction)languageButton:(UIButton *)sender;
- (IBAction)flagToggle:(UIButton *)sender;
- (IBAction)forward:(UIButton *)sender;
- (IBAction)clearFlagBanner:(UIButton *)sender;
@property int jumpBackTo;

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
    
    // initialize the correct "empty" highlight animation frames (random ones set in storybaord for ease)
    self.blinkHighlightNextImage.image = [UIImage imageNamed: @"blinkHighlight_0000.png"];
    self.blinkHighlightForward.image = [UIImage imageNamed: @"blinkHighlight_0000.png"];
    self.jumpBackTo = -1;
    
    
    // set the current slide
    [self setSlide];
}


- (void)viewWillAppear:(BOOL)animated{
    [self setSlide];
    
}

- (void) setSlide{
    //self.blinkHighlightNextImage.image = [UIImage imageNamed: @"blinkHighlight_0000.png"];
    //self.blinkHighlightForward.image = [UIImage imageNamed: @"blinkHighlight_0000.png"];
    
    if (self.jumpBackTo == [[getPresentationData dataShared] getCurrentSlideIndex]){
        [self runBlinkForward];
        self.forwardButton.alpha = 0;
        self.jumpBackTo = -1;
    }
    
    if (self.jumpBackTo != -1){
        self.forwardButton.alpha = 1;
    }
    else{
        self.forwardButton.alpha = 0;
    }
    
    // if the state is reviewFlag, then make invisible a few things!
    if ([[getPresentationData dataShared] getReviewFlagState]){
        self.aboutButton.alpha = 0;
        self.UInextButton.alpha = 0;
        self.UIpreviousButton.alpha = 0;
        self.UIworldButton.alpha = 0;
        self.flagButton.alpha = 0;
        
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        NSString *str = [[getPresentationData dataShared] getLocalName: lang forKey: @"clearFlag"];
        [self.clearFlagBannerButton setTitle: str forState:UIControlStateNormal];
        [self.clearFlagBannerButton setTitle: str forState:UIControlStateSelected];
        self.clearFlagBannerButton.alpha = 1;
    }
    else{
        
        self.aboutButton.alpha = 1;
        self.UInextButton.alpha = 1;
        self.UIpreviousButton.alpha = 1;
        self.UIworldButton.alpha = 1;
        self.flagButton.alpha = 1;
        self.clearFlagBannerButton.alpha = 0;
    }
    
    //NSLog(@"get state: %i",[[getPresentationData dataShared] getReviewFlagState]);
    
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
        UIView *view;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"slideInfoView" owner:self options:nil][0];
        }
        else{
            view = [[NSBundle mainBundle] loadNibNamed:@"slideInfoView_iP" owner:self options:nil][0];
        }
        
        self.backgroundView = view;
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view  insertSubview:view atIndex:1];
        
        // get the infoSlide data
        slideInfo *infoSlide = [getPresentationData dataShared].getCurrentSlideInfo;
        
        // only set image if one is supplied (non nill read-in)
        if (infoSlide.image != nil){
            self.infoImage.image = [UIImage imageNamed:infoSlide.image];
            self.infoImage.alpha = 1;
        }
        else{
            self.quizImageBG.alpha = 0; // wait.. why quiz BG here..?
        }
        
        self.infoText.text = infoSlide.text;
        //self.infoText.font = 22;
        self.colorBox.backgroundColor = [UIColor colorWithRed:225/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
        
    }
    else if ([slideType  isEqual: @"quiz"]){
        
        //set the view
        UIView *view;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"slideQuizView" owner:self options:nil][0];
        }
        else{
            view = [[NSBundle mainBundle] loadNibNamed:@"slideQuizView_iP" owner:self options:nil][0];
        }
        
        self.backgroundView = view;
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view  insertSubview:view atIndex:1];
        
        slideQuiz *quizSlide = [getPresentationData dataShared].getCurrentSlideQuiz;
        
        [self.answerArray removeAllObjects];
        for (int i=0; i< [quizSlide.answers count]; i++){
            [self.answerArray addObject: quizSlide.answers[i]];
            //NSLog(@"> ZN: %@, %@\nE:",quizSlide.answers[i],self.answerArray);
        }
        //reload table.. later move into else clause (when it would be visible)
        [self.quizAnswerTable reloadData];
        
        // set the correct answer label (shown on selecting correctly)
        NSString *correctString = [NSString stringWithFormat:@"'' %@ ''",self.answerArray[quizSlide.solution]];
        self.showCorrectLabel.text = correctString;
        
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

        
        // set the try again/goto titles
        // set reandom strings that only need setting once
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        NSString *str;

        str = [[getPresentationData dataShared] getLocalName: lang forKey:@"quizReturnToInfo"];
        [self.quizGotoInfoOutlet setTitle: str forState:UIControlStateNormal];
        [self.quizGotoInfoOutlet setTitle: str forState:UIControlStateSelected];
        
        
        
        if (self.allowNext==TRUE && ![[getPresentationData dataShared] getReviewFlagState]){
             //NSLog(@"past correct answer");
            // already answered correctly once
            self.quizExplanation.text = quizSlide.explanation;
            self.quizExplanation.alpha = 1;
            self.quizAnswerTable.alpha = 0;
            self.quizGotoInfoOutlet.alpha = 0;
            self.showCorrectLabel.alpha = 1;
            
            // set color transparent backgorund of thing to pastel green
            // starting point
            self.colorBox.backgroundColor = [UIColor colorWithRed:225/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
            
            UIColor *color = [UIColor colorWithRed:224/255.0 green:243/255.0 blue:176/255.0 alpha:0.5];
            [UIView animateWithDuration:1.0
                             animations:^{
                                 self.colorBox.backgroundColor = color;
                             }];
        }
        else if ([[getPresentationData dataShared] getReviewFlagState]){
            
            self.quizExplanation.alpha = 0;
            self.quizAnswerTable.alpha = 1;
            self.showCorrectLabel.alpha = 0;
            
            self.quizGotoInfoOutlet.alpha = 0;
            
            
            //fill table with info...
            // set color of transparent background thing to neutral
            self.colorBox.backgroundColor = [UIColor colorWithRed:225/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
        }
        else{
            // did not answer correctly yet/not yet answered, set next arrow accordingly
            [self.UInextButton setBackgroundImage:[UIImage imageNamed:@"UI_arrowRight_empty"] forState:UIControlStateNormal];
            
            self.quizExplanation.alpha = 0;
            self.quizAnswerTable.alpha = 1;
            self.showCorrectLabel.alpha = 0;
            
            //fill table with info...
            // set color of transparent background thing to neutral
            self.colorBox.backgroundColor = [UIColor colorWithRed:225/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
            
            
        }

    }
    else if ([slideType  isEqual: @"intro"]){
        
        // always allow to select next on info slide;
        self.allowNext=TRUE;
        
        // set the background view
        UIView *view;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"slideIntroView" owner:self options:nil][0];
        }
        else{
             view = [[NSBundle mainBundle] loadNibNamed:@"slideIntroView_iP" owner:self options:nil][0];
        }
        self.backgroundView = view;
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view  insertSubview:view atIndex:1];
        
        // get the view data
        slideIntro *introSlide = [getPresentationData dataShared].getCurrentSlideIntro;
        self.introWelcomeLabel.text = introSlide.welcome;
        
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        self.introTextUsage.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"introUsage"];
        self.introLabelLeft.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"introLeft"];
        self.introLabelCenter.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"introCenter"];
        self.introLabelRight.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"introRight"];
        
        // settup the repeating animations
        
        [self.introImgseqA stopAnimating];
        [self.introImgseqB stopAnimating];
        [self.introImgseqC stopAnimating];
        
        NSMutableArray *seqA = [[NSMutableArray alloc] init];
        for (int i=0;i<79;i++){
            UIImage *tmp = [UIImage imageNamed: [NSString stringWithFormat:@"navSlides_%04d.png",i]];
            [seqA addObject:tmp];
        }
        
        NSMutableArray *seqB = [[NSMutableArray alloc] init];
        for (int i=0;i<119;i++){
            UIImage *tmp = [UIImage imageNamed: [NSString stringWithFormat:@"navQuiz_%04d.png",i]];
            [seqB addObject:tmp];
        }
        
        NSMutableArray *seqC = [[NSMutableArray alloc] init];
        for (int i=0;i<79;i++){
            UIImage *tmp = [UIImage imageNamed: [NSString stringWithFormat:@"flagButton_%04d.png",i]];
            [seqC addObject:tmp];
        }
        
        self.introImgseqA.animationImages = seqA;
        self.introImgseqA.animationRepeatCount = 0;
        self.introImgseqA.animationDuration = 80/24*1.0;
        [self.introImgseqA startAnimating];
        
        self.introImgseqB.animationImages = seqB;
        self.introImgseqB.animationRepeatCount = 0;
        self.introImgseqB.animationDuration = 119/24*1.5;
        [self.introImgseqB startAnimating];
        
        self.introImgseqC.animationImages = seqC;
        self.introImgseqC.animationRepeatCount = 0;
        self.introImgseqC.animationDuration = 78/24*1.0;
        [self.introImgseqC startAnimating];

    }
    else if ([slideType  isEqual: @"slideOutro"]){
        // always allow to select next on info slide;
        self.allowNext=TRUE;
        
        // set the background view
        UIView *view;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"slideOutroView" owner:self options:nil][0];
        }
        else{
            view = [[NSBundle mainBundle] loadNibNamed:@"slideOutroView_iP" owner:self options:nil][0];
        }
        self.backgroundView = view;
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view  insertSubview:view atIndex:1];
        
        // get the view data
        slideOutro *introOutro = [getPresentationData dataShared].getCurrentSlideOutro;
        self.outroEndText.text = introOutro.text;
        
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        self.outroCongratsLabel.text = [[getPresentationData dataShared] getLocalName: lang forKey: @"outrLabel"];
        
        // set localized buttons...
        NSString *str = [[getPresentationData dataShared] getLocalName: lang forKey:@"jumpFirstSlide"];
        str = [[getPresentationData dataShared] getLocalName: lang forKey:@"reviewSlides"];
        [self.outroFlagReviewButton setTitle: str forState:UIControlStateNormal];
        [self.outroFlagReviewButton setTitle: str forState:UIControlStateSelected];
        
        str = [[getPresentationData dataShared] getLocalName: lang forKey:@"goMenu"];
        [self.returnToMenuButton setTitle: str forState:UIControlStateNormal];
        [self.returnToMenuButton setTitle: str forState:UIControlStateSelected];
        
        
        //animation thumb
        
        [self.outroImage stopAnimating];
        
        NSMutableArray *thumb = [[NSMutableArray alloc] init];
        for (int i=0;i<48;i++){
            UIImage *tmp = [UIImage imageNamed: [NSString stringWithFormat:@"thumbs_%04d.png",i]];
            [thumb addObject:tmp];
        }
        
        self.outroImage.animationImages = thumb;
        self.outroImage.animationRepeatCount = 0;
        self.outroImage.animationDuration = 47/24*2;
        [self.outroImage startAnimating];
        
        
        // don't let them flag this slide!
        self.flagButton.alpha = 0;
        
        
    }
    
    // else if another type of slide, add here..
    
    
    
    
    // stuff to make the views ACTUALLY fit the screen. Because xibs are stupid, apparently.
    [[self.view.subviews objectAtIndex:1] setFrame: [[UIScreen mainScreen] applicationFrame]];
    
    
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
    //[self presentViewController:nextView animated:YES completion:nil];
    
}

- (IBAction)languageButton:(UIButton *)sender {
    
    UIViewController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"languageSelectID"];
    [self presentViewController:nextView animated:YES completion:nil];
    
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


-(void) runBlinkAnimation: (NSString *) location{
    
    //NSLog(@">> location: %@",location);
    // don't run blink animation if in flag review, they can't move to new slides anyways!!
    if ([[getPresentationData dataShared] getReviewFlagState]){
        return;
    }
    
    [self.blinkHighlightNextImage stopAnimating];
    
    NSMutableArray *blinkAnimation = [[NSMutableArray alloc] init];
    for (int i=0;i<23;i++){
        UIImage *tmp = [UIImage imageNamed: [NSString stringWithFormat:@"blinkHighlight_%04d.png",i]];
        [blinkAnimation addObject:tmp];
    }
    
    
    self.blinkHighlightNextImage.animationImages = blinkAnimation;
    self.blinkHighlightNextImage.animationRepeatCount = 1;
    self.blinkHighlightNextImage.animationDuration = 1;
    [self.blinkHighlightNextImage startAnimating];
    
}

-(void) runBlinkForward{
    
    [self.blinkHighlightForward stopAnimating];
    
    NSMutableArray *blinkAnimation = [[NSMutableArray alloc] init];
    for (int i=0;i<23;i++){
        UIImage *tmp = [UIImage imageNamed: [NSString stringWithFormat:@"blinkHighlight_%04d.png",i]];
        [blinkAnimation addObject:tmp];
    }
    
    
    self.blinkHighlightForward.animationImages = blinkAnimation;
    self.blinkHighlightForward.animationRepeatCount = 1;
    self.blinkHighlightForward.animationDuration = 1;
    [self.blinkHighlightForward startAnimating];
    
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
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        cell.textLabel.font = [UIFont systemFontOfSize:25];
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    
    
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
    UIFont *font;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        font = [UIFont systemFontOfSize:26];
    }
    else{
        font = [UIFont systemFontOfSize:15];
    }
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.answerArray[indexPath.row] attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    size.height = ceilf(size.height);
    size.width  = ceilf(size.width);
    
    int extraBuffer;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        extraBuffer = 24;
    }
    else{
        extraBuffer = 14;
    }
    return size.height + extraBuffer;
    
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
    
    //toast
    NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
    NSString *str = [[getPresentationData dataShared] getLocalName: lang forKey:@"quizCorrectAnswer"];
    
    UIColor *color = [UIColor colorWithRed:224/255.0 green:243/255.0 blue:176/255.0 alpha:0.9];
    
    [self toastMessage:str atPosition:@"top" withColor:color];
    // do the animation, indicating one can continue
    [self runBlinkAnimation:@"left"];
}

- (void) quizDidAnswerIncorrect{
    
    // answered incorrectly
    
    UIColor *color = [UIColor colorWithRed:255/255.0 green:235/255.0 blue:201/255.0 alpha:0.9];
    
    self.quizExplanation.alpha = 0;
    
    // toast
    NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
    NSString *str = [[getPresentationData dataShared] getLocalName: lang forKey:@"quizWrongAnswer"];
    
    [self toastMessage:str atPosition:@"top" withColor:color];
    
    //set flag
    [self flagSet:YES];
}




/////////////////////////////////////////////////////////////////////////////////
// stuff for the TOAST like things

- (void) toastMessage:(NSString *)message atPosition:(NSString *)position withColor:(UIColor *)color{
    
    
    
    //extra constraints based on iPhone vs iPad
    int fontSize;
    int topHeight;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        fontSize = 26;
        topHeight = 100;
    }
    else{
        fontSize = 18;
        topHeight = 80;
        
    }
    
    // remove existing ones
    UILabel *tempLabel = (UILabel *)[self.view viewWithTag:142];
    if(tempLabel)
        [tempLabel removeFromSuperview];
    
    // get box/position parameters
    
    int selfHeight = [[UIScreen mainScreen] bounds].size.height;
    int selfWidth = [[UIScreen mainScreen] bounds].size.width;
    int width,height,x,y;
    // defaults
    x = 20;
    y = selfHeight-150;
    width = selfWidth-40; // or selfWidth*.8
    height = 50;
    
    if ([position isEqual:@"top"]){
        x = 20;
        y = 80;
        height = topHeight;
        
    }
    else if ([position isEqual:@"bottom"]){
        
    }
    else{
        //NSLog(@"ELSE toast");
    }
    
    UILabel  * toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    toastLabel.backgroundColor = color;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.textColor=[UIColor blackColor];
    toastLabel.text = message;
    toastLabel.numberOfLines = 2;
    toastLabel.font = [UIFont systemFontOfSize:fontSize]; // make it bold??
    [self.view addSubview:toastLabel];
    toastLabel.tag = 142;
    
    
    
    
    //[toastLabel setHidden:TRUE];
    [toastLabel setAlpha:1.0];
    CGPoint location;
    location.x = selfWidth/2;
    location.y = y;
    toastLabel.center = location;
    location.x = selfWidth/2;
    location.y = y+20;
    //[toastLabel setHidden:FALSE];
    
    
    [UIView animateWithDuration:0.5
                          delay: 2.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         toastLabel.alpha = 0.0;
                         toastLabel.center = location;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.8 animations:^{
                             toastLabel.alpha = 0.0;
                             
                         }];
                     }];
    
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
        NSString *lang = [[getPresentationData dataShared] getCurrentLanguage];
        NSString *str = [[getPresentationData dataShared] getLocalName: lang forKey:@"answerToAdvance"];
        
        //UIColor *color = [UIColor colorWithRed:255/255.0 green:235/255.0 blue:201/255.0 alpha:0.8];
        UIColor *color = [UIColor colorWithRed:78/255.0 green:193/255.0 blue:239/255.0 alpha:0.9];
        [self toastMessage:str atPosition:@"top" withColor:color];
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

- (IBAction)forward:(UIButton *)sender {
    
    // method for when the forward button clicked, jumping back to previous jumped-from
    // quiz slide
    
    [self runBlinkForward];
    self.forwardButton.alpha = 0;
    
    // shouldn't ever happen, but just in case
    if (self.jumpBackTo==-1){
        self.jumpBackTo=0;
    }
    
    // do the actual jump
    [[getPresentationData dataShared] setPresentationSlide: self.jumpBackTo];
    //self.jumpBackTo = -1;
    [self setSlide];
}

- (IBAction)clearFlagBanner:(UIButton *)sender {
    
    [[getPresentationData dataShared] setCurrentSlideFlag:NO];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //[self runBlinkAnimation:@"right"];
    if (![[getPresentationData dataShared] getReviewFlagState]){
        [self nextSlide];
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //[self runBlinkAnimation:@"left"];
    if (![[getPresentationData dataShared] getReviewFlagState]){
        [self previousSlide];
    }
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

- (IBAction)quizGotoInfo:(UIButton *)sender {
    self.jumpBackTo = [[getPresentationData dataShared] getCurrentSlideIndex];
    //run the animation blink, as it will appear with the new slide being set
    [self runBlinkForward];
    [[getPresentationData dataShared] setPresentationSlide:self.gotoInfo];
    [self setSlide];
}
- (IBAction)outroReviewFlags:(UIButton *)sender {
    
    // push the info view controller
    UIViewController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"reviewFlagsContID"];
    //[self presentViewController:nextView animated:YES completion:nil];
    [self.navigationController pushViewController:nextView animated:YES];
    // WOULD BE BETTER IF MODAL bu whatev
}

- (IBAction)returnToMenu:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

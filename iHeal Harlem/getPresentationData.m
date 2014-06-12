//
//  getPresentationData.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/19/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

// This class is a SINGLETON, only one object exists in the app
// all the presentation data is held/loaded/changed here.

// data hard coded for now
// eventually read from plist, one per presentation

#import "getPresentationData.h"

 
@implementation getPresentationData

@synthesize conditionsList;
@synthesize menuTitles;
@synthesize menuKeys;
@synthesize languageChoices;
@synthesize languageUINames;
@synthesize slides;
@synthesize slidesType;
@synthesize activePlist;
@synthesize activeConditionName;
@synthesize activeConditionUIName;
// FlowModes: "linear", "flagCheck", 
@synthesize presentationFlowMode;

- (void) test {
    
    NSLog(@"testing singleton");
}


+ (getPresentationData *)dataShared
{
    static dispatch_once_t pred;
    static getPresentationData *shared = nil;
    
    // instance the class only the first time
    dispatch_once(&pred, ^{
        shared = [[getPresentationData alloc] init];
        
        shared.conditionsList = [[NSMutableArray alloc]init];
        shared.menuTitles =[[NSMutableArray alloc]init];
        shared.menuKeys = [[NSMutableArray alloc]init];
        shared.languageChoices = [[NSMutableArray alloc]init];
        shared.languageUINames = [[NSMutableArray alloc]init];
        shared.activePlist = [[NSString alloc]init];
        shared.activeConditionName = [[NSString alloc]init];
        shared.activeConditionUIName = [[NSString alloc]init];
        shared.presentationFlowMode = [[NSString alloc]init];
        
        // together, the slides/slide-type array make up all info of a presentation
        shared.slides = [[NSMutableArray alloc]init];
        shared.slidesType = [[NSMutableArray alloc]init];
        
        
        // now initialize the values...
        [shared getPresentationsList];
        //[shared getLanguageChoices];
        
        ///////////////////////////////////////////////////////////////////////////////////
        // technically should NOT INITIALIZE THIS, only set once presentation selected...
        //shared.activePlist = @"Asthma.english";
        shared.activePlist = @"";
        //[shared replacePresentation: shared.activePlist];
        shared->currentSlideIndex = 0;
        shared->jumpSlideIndex = 0;
        shared->holdIndexForReview = -1;
        shared.presentationFlowMode = @"linear";
        shared->reviewingFlags = NO;
        
    });
        
    return shared;
}


//  the file structure to get presentation handles
- (NSMutableArray *) getPresentationsList {
    
    /*
    NSFileManager *filemgr;
    NSString *currentpath;
    NSArray *filelist;
    NSUInteger count;
    int i;
    filemgr = [NSFileManager defaultManager];
    currentpath = [filemgr currentDirectoryPath];
    */
     
    //filelist = [filemgr contentsOfDirectoryAtPath: currentpath error: nil];

    

    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSMutableArray *conditionsArray = [[NSMutableArray alloc] init];
    conditionsArray = [appInfo objectForKey:@"conditionsArray"];
    //NSLog(@" ** %@",conditionsArray);

    // Will delete contents of array and then populate based on read-in plist
    [self.conditionsList removeAllObjects];
    NSString *conditionKey;
    for (int i=0;i<[conditionsArray count]; i++){
        conditionKey = conditionsArray[i];
        [self.conditionsList addObject:conditionKey];
    }
    
    //[self.conditionsList addObject:@"aboutPageTitle"];
    
    return self.conditionsList;
    
}


///////////////////////////////////////////////////////////////////////////
// this returns current slide, called assuming it is type "slideInfo"
// need to creat one method of this style for EACH type of return,
// this is ONLy called within the slide of the according type itself
- (slideInfo *) getCurrentSlideInfo{
    
    slideInfo *currentSlide = [[slideInfo alloc] init];
    currentSlide = self.slides[self->currentSlideIndex];
    //NSLog(@"printing slide index: %i",self->currentSlideIndex);
    return currentSlide;
}

- (slideQuiz *) getCurrentSlideQuiz{
    slideQuiz *currentSlide = [[slideQuiz alloc] init];
    currentSlide = self.slides[self->currentSlideIndex];
    //NSLog(@"printing slide index: %i",self->currentSlideIndex);
    return currentSlide;
}

- (slideIntro *) getCurrentSlideIntro{
    slideIntro *currentSlide = [[slideIntro alloc] init];
    currentSlide = self.slides[self->currentSlideIndex];
    //NSLog(@"printing slide index: %i",self->currentSlideIndex);
    return currentSlide;
}

- (slideOutro *) getCurrentSlideOutro{
    slideOutro *currentSlide = [[slideOutro alloc] init];
    currentSlide = self.slides[self->currentSlideIndex];
    //NSLog(@"printing slide index: %i",self->currentSlideIndex);
    return currentSlide;
}

- (void) replacePresentation:(NSString*) plist flags: (BOOL) keepFlags{
    
    // this method takes a presentation list read-in plist
    // and replaces the currently loaded presentation with
    // this (1 specific language, 1 condition)
    
    // this is done when the language is selected in the
    // main intro screen, or if the language is dynamically changed
    
    // now initialize the values...
    [self getPresentationsList];
    [self getLanguageChoices];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *presPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *presArray = [[NSMutableArray alloc] init];
    presArray = [presPlist objectForKey:@"slides"];
    
    // safe guard, in case presentation reload plist invalid.
    if ([presArray count] == 0){
        return;
    }
    
    // now assumed to be valid, declare new active plist
    NSString *previousPlist = self.activePlist;
    self.activePlist = plist;
    int i=0;
    
    
    // next, grab all of the flag states and store them if keepFlags is true
    NSMutableArray *flagList = [[NSMutableArray alloc] init];
    NSMutableArray *correctQuizes = [[NSMutableArray alloc] init];
    if (keepFlags){
        for (i=0;i<[self.slides count];i++){
            
            // for preserving quiz correct answers, intially add false
            NSNumber *tmpQUizNo = [[NSNumber alloc] initWithBool:NO];
            [correctQuizes addObject: tmpQUizNo];
            
            if ([self.slidesType[i]  isEqual: @"info"]){
                slideInfo *tmp = self.slides[i];
                NSNumber *tmpNm = [[NSNumber alloc] initWithBool:tmp.flagSet];
                [flagList addObject: tmpNm];
            }
            else if ([self.slidesType[i]  isEqual: @"quiz"]){
                slideQuiz *tmp = self.slides[i];
                NSNumber *tmpNm = [[NSNumber alloc] initWithBool:tmp.flagSet];
                [flagList addObject: tmpNm];
                
                if (tmp.didAnswerCorrect){
                    correctQuizes[i] = [[NSNumber alloc] initWithBool:YES];
                }
            }
            else if ([self.slidesType[i]  isEqual: @"intro"]){
                slideIntro *tmp = self.slides[i];
                NSNumber *tmpNm = [[NSNumber alloc] initWithBool:tmp.flagSet];
                [flagList addObject: tmpNm];
            }
            else if ([self.slidesType[i]  isEqual: @"outro"]){
                slideOutro *tmp = self.slides[i];
                NSNumber *tmpNm = [[NSNumber alloc] initWithBool:tmp.flagSet];
                [flagList addObject: tmpNm];
            }
            else{
                NSNumber *tmpNm = [[NSNumber alloc] initWithBool:NO];
                [flagList addObject: tmpNm];
            }
        }
    }
    
    // thing to parse for PREVIOUS condition name
    NSString *previousName;
    i = 0;
    while (i<previousPlist.length){
        if ([previousPlist characterAtIndex:i]=='.'){
            previousName = [previousPlist substringToIndex:i];
            break;
        }
        i++;
    }
    
    // thing to parse for NEW condition name
    NSString *newName = [[NSString alloc]init];
    newName = [plist componentsSeparatedByString:@"."][0];

    
    // only change the current slide index if the base presentation name changed
        // technically now with keepFlags, we don't need the first comparison
    //if (![newName isEqual: previousName] || keepFlags==NO){
    if (keepFlags==NO){
        self->currentSlideIndex = 0;
    }
    else{
        // else, different presentation – change the name!
        self.activeConditionName = previousName;
    }
    
    // should be redundant.. delete below
    self.activeConditionName = newName;
    self.activeConditionUIName = [[presPlist objectForKey:@"attributes"] objectForKey:@"conditionName"];
    
    // first remove all entries of previous presentation
    [self.slides removeAllObjects];
    [self.slidesType removeAllObjects];
    
    // now populate it with new entries
    // must check each time for what kind of object to construct
    for (int i=0;i<[presArray count];i++){
        NSDictionary *temp = presArray[i]; //presPlist[i];
        NSString *strTemp = temp[@"slide"];
        
        if ([strTemp isEqual:@"info"]){
            //NSLog(@"info type: INFO");
            slideInfo *tempSlideInfo = [[slideInfo alloc]init];
            tempSlideInfo.text = temp[@"text"];
            tempSlideInfo.image = temp[@"image"];
            tempSlideInfo.title = temp[@"title"];
            
            
            //BOOL thing is read in as NSNumber, must cast it
            if (keepFlags){
                NSNumber *tempNS = flagList[i];
                tempSlideInfo.flagSet = tempNS.boolValue;
            }
            else{
                NSNumber *tempNS = temp[@"flagSet"];
                tempSlideInfo.flagSet = tempNS.boolValue;
            }
            
            //NSLog(@"getPresDat: read flag %i, %i",t,tempSlideInfo.flagSet);
            [self.slides addObject:tempSlideInfo];
            [self.slidesType addObject:@"info"];
        }
        else if([strTemp isEqual:@"quiz"]){
            //NSLog(@"info type: QUIZ");
            slideQuiz *tempSlideQuiz = [[slideQuiz alloc]init];
            tempSlideQuiz.question = temp[@"question"];
            tempSlideQuiz.image = temp[@"image"];
            // ARRAY arg.
            NSNumber *ubertmp = temp[@"solution"];
            tempSlideQuiz.solution = ubertmp.intValue;
            tempSlideQuiz.explanation = temp[@"explanation"];
            
            //BOOL thing is read in as NSNumber, must cast it
            if (keepFlags){
                NSNumber *tempNS = flagList[i];
                tempSlideQuiz.flagSet = tempNS.boolValue;
            }
            else{
                NSNumber *tempNS = temp[@"flagSet"];
                tempSlideQuiz.flagSet = tempNS.boolValue;
            }
            
            
            tempSlideQuiz.didAnswerCorrect = FALSE;
            if (keepFlags){
                NSNumber *tmpCheck = correctQuizes[i];
                if (tmpCheck.boolValue){
                    tempSlideQuiz.didAnswerCorrect = TRUE;
                }
                else{
                    tempSlideQuiz.didAnswerCorrect = FALSE;
                }
            }
            tempSlideQuiz.answers = temp[@"answers"];
            ubertmp = temp[@"slideRef"];
            if (ubertmp==nil){
                tempSlideQuiz.slideRef = 0;
                NSLog(@"no slide ref?");
            }
            else{
                tempSlideQuiz.slideRef = (int)ubertmp.integerValue;
            }
            
            
            [self.slidesType addObject:@"quiz"];
            [self.slides addObject:tempSlideQuiz];
        }
        else if([strTemp isEqual:@"intro"]){
            // intro type slide, -should- always be the first one in a presentation
            slideIntro *tempSlideIntro = [[slideIntro alloc]init];
            tempSlideIntro.welcome = temp[@"welcome"];
            tempSlideIntro.imgGesture = temp[@"imgGesture"];
            
            
            
            [self.slides addObject:tempSlideIntro];
            [self.slidesType addObject:@"intro"];
            
        }
        else if([strTemp isEqual:@"outro"]){
            // outro type slide, -should- always be the last one in a presentation
            slideOutro *tempSlideOutro = [[slideOutro alloc]init];
            tempSlideOutro.text = temp[@"text"];
            tempSlideOutro.image = temp[@"image"];
            
            //BOOL thing is read in as NSNumber, must cast it
            NSNumber *tempNS = temp[@"flagSet"];
            tempSlideOutro.flagSet = tempNS.boolValue;
            
            [self.slides addObject:tempSlideOutro];
            [self.slidesType addObject:@"slideOutro"];
        }
    }
    
}


// this should be a hard coded array of pastel colors used for menu items and other schemes
- (NSArray *)getPastalColorArray
{
    UIColor *pastalOrange =     [UIColor colorWithRed:254/255.0 green:235/255.0 blue:201/255.0 alpha:1];
    UIColor *pastalYellow =     [UIColor colorWithRed:255/255.0 green:255/255.0 blue:176/255.0 alpha:1];
    UIColor *pastalGreen =      [UIColor colorWithRed:224/255.0 green:243/255.0 blue:176/255.0 alpha:1];
    UIColor *pastalCyan =       [UIColor colorWithRed:179/255.0 green:226/255.0 blue:221/255.0 alpha:1];
    UIColor *pastalBlue =       [UIColor colorWithRed:191/255.0 green:213/255.0 blue:232/255.0 alpha:1];
    UIColor *pastalMagenta =    [UIColor colorWithRed:221/255.0 green:212/255.0 blue:232/255.0 alpha:1];
    UIColor *skyeBlue =         [UIColor colorWithRed:78/255.0 green:193/255.0 blue:239/255.0 alpha:1];
    //UIColor *transparent =      [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    //UIColor *skyeBlue =    [UIColor colorWithRed:78/255.0 green:193/255.0 blue:239/255.0 alpha:1];
    
    NSArray *colorArray = @[pastalOrange,pastalYellow,pastalGreen,pastalCyan,pastalBlue,pastalMagenta,skyeBlue];
    //NSLog(@"colorObj: %@", colorArray);
    return colorArray;
}


- (NSDictionary *) getMenuTitles {
    
    NSString *plistName = self.activePlist;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *attr = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *attributes = [[NSDictionary alloc] init];
    attributes = [attr objectForKey:@"attributes"];

    NSMutableArray *plistMenuTitles = [attributes objectForKey:@"menuLocalized"];
    NSMutableArray *plistMenuKeys = [attributes objectForKey:@"menuTitles"];
    
    // add the menu options to the menu titles, index + 1 (start presentation ALWAYS first)
    for (int i=0; i< [plistMenuTitles count]; i++){
        self.menuTitles[i]=plistMenuTitles[i];
        self.menuKeys[i]=plistMenuKeys[i];
    }
    NSDictionary *menuDict = [[NSDictionary alloc]initWithObjectsAndKeys: self.menuTitles, @"titles", self.menuKeys, @"keys", nil];
    return menuDict;
    
}

- (NSMutableArray *) getLanguageChoices {
    
    return self.languageChoices;
}

- (void) setLanguageNames{
    
    // set the languages based on the newly set activePresentation
    
    // do the memory clear thing
    // read these from plsit files
    [self.languageChoices removeAllObjects];
    
    // read these from individual plist's condition name, localized
    [self.languageUINames removeAllObjects];
    
    NSString *filename = [[NSString alloc] init];
    //NSMutableArray *base = [[NSMutableArray alloc] init];
    NSArray *namesArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"plist" inDirectory:@""];
    
    for (int i=0;i<[namesArray count];i++){
        
        filename = [namesArray[i] lastPathComponent];
        NSArray *base = [[NSMutableArray alloc] init];
        base = [filename componentsSeparatedByString:@"."];
        if ([base[0] isEqual: self.activeConditionName]){
            //
            // here add it to language choices, then LOAD plist and get UI name..
            [self.languageChoices addObject:base[1]];
            // now get the localized language name
            NSString *plistName = [NSString stringWithFormat:@"%@.%@",base[0],base[1]];
            
            NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
            // do check for path== nil? that's how it can fail
            NSDictionary *attr = [NSDictionary dictionaryWithContentsOfFile:path];
            NSDictionary *attributes = [[NSDictionary alloc] init];
            attributes = [attr objectForKey:@"attributes"];
            
            NSMutableArray *langLocal = [attributes objectForKey:@"languageLocalized"];
            
            [self.languageUINames addObject:langLocal];
            
        }
    }

}

- (NSMutableArray *) getLanguageUINames {
    
    return self.languageUINames;
}


- (NSArray *) getSlides {
    
    return self.slides;
}


- (NSArray *) getInfoSlide {
    NSArray *slide;
    return slide;
}


- (BOOL) toggleCurrentSlideFlag{
    // will toggle the CURRENT slide's flag state.
    
    NSString *currentType = self.slidesType[self->currentSlideIndex];
    if ([currentType isEqual: @"quiz"]){
        slideQuiz *qzlide = self.slides[self->currentSlideIndex];
        if(qzlide.flagSet){
            qzlide.flagSet = NO;
        }
        else{
            qzlide.flagSet = YES;
        }
        self.slides[self->currentSlideIndex] = qzlide;
        return qzlide.flagSet;
    }
    else{
        slideInfo *cslide = self.slides[self->currentSlideIndex];
        if(cslide.flagSet){
            cslide.flagSet = NO;
        }
        else{
            cslide.flagSet = YES;
        }
        self.slides[self->currentSlideIndex] = cslide;
        return cslide.flagSet;

    }
    // this is the general syntax for saving back to the plist...
    // but it must be the same as the ENTIRE PLIST data...
    // so honestly, probably should just re-read it in,
    // then parse through and save the according position???
    //[plistdict writeToFile:filePath atomically:YES];
    
    // RECALL to save it as.. an NSNumber? cast it yo

}

- (BOOL) setCurrentSlideFlag:(bool)state{
    
    NSString *currentType = self.slidesType[self->currentSlideIndex];
    if ([currentType isEqual: @"quiz"]){
        slideQuiz *qzlide = self.slides[self->currentSlideIndex];
        qzlide.flagSet = state;
        
        self.slides[self->currentSlideIndex] = qzlide;
        return qzlide.flagSet;
    }
    else {
        // will set the CURRENT slide's flag state.
        slideInfo *cslide = self.slides[self->currentSlideIndex];
        cslide.flagSet = state;
        
        self.slides[self->currentSlideIndex] = cslide;
        
        // this is the general syntax for saving back to the plist...
        // but it must be the same as the ENTIRE PLIST data...
        // so honestly, probably should just re-read it in,
        // then parse through and save the according position???
        //[plistdict writeToFile:filePath atomically:YES];
        
        // RECALL to save it as.. an NSNumber? cast it yo
        
        return cslide.flagSet;
    }
}



- (BOOL) getCurrentSlideFlag{
    // here would check parallel array for typedef
    
    NSString *currentType = self.slidesType[self->currentSlideIndex];
    if ([currentType isEqual: @"quiz"]){
        slideQuiz *qzlide = self.slides[self->currentSlideIndex];
        bool tmp = qzlide.flagSet;
        return tmp;
    }
    else {
        // case @"info" slide, default.. should this be "defualt"?
        slideInfo *cslide = self.slides[self->currentSlideIndex];
        bool tmp = cslide.flagSet;
        return tmp;
    }
}

- (int) setNextSlide{
    // case for flagFlow // TECHNICALLY should just delete this, since no flow for flags now
    if ([self.presentationFlowMode  isEqual: @"flagCheck"]){
        while (self->currentSlideIndex < [self.slides count]-1){
            self->currentSlideIndex+=1;
            if ([self getCurrentSlideFlag]){
                return 0;
            }
        }
        self->currentSlideIndex=0;
        return 1;
    }
    // defualt case "linear"
    else{
        if (self->currentSlideIndex+1 == [self.slides count]){
            // condition met for last slide,
            self->currentSlideIndex=0;
            return 1;
        }
        self->currentSlideIndex+=1;
    }
    
    return 0;
}

- (int) setPreviousSlide{
    
    // case for flagFlow // TECHNICALLY should just delete this, since no flow for flags now
    if ([self.presentationFlowMode  isEqual: @"flagCheck"]){
        while (self->currentSlideIndex > 0){
            self->currentSlideIndex-=1;
            if ([self getCurrentSlideFlag]){
                return 0;
            }
        }
        self->currentSlideIndex=0;
        return -1;
    }
    // defualt case "linear"
    else{
        if (self->currentSlideIndex-1 < 0){
            // condition met for first slide,
            self->currentSlideIndex=0;
            return -1;
        }
        self->currentSlideIndex-=1;
        return 0;
    }
}


- (NSString *)getSlideType{
    
    return slidesType[self->currentSlideIndex];
}

- (void) setPresentationSlide: (int) slide{
    self->currentSlideIndex=slide;
}


- (int) jumpToFirstQuizSlide{
    
    int i=0;
    while (![self.slidesType[i]  isEqual: @"quiz"]){
        i++;
        if (i==[self.slidesType count]){
            NSLog(@"No quiz slide in presentation");
            return -1;
        }
    }
    
    [self setPresentationSlide:i];
    return 0;
}

- (int) getCurrentSlideIndex{
    return self->currentSlideIndex;
}

- (NSString *) getPresentationKeyname{
    //NSLog(@"DShared, need to actually grab presentaiton from current..");
    
    return self.activeConditionName;//@"Asthma";
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


- (NSString *) getSlideTitle{
    
    return [NSString stringWithFormat:@"%@ %i/%lu",self.activeConditionUIName,self->currentSlideIndex+1,(unsigned long)[self.slidesType count]];
}

- (bool) quizDidAnswerCorrect{
    // specific to quiz slide, answered correct so set according option
    slideQuiz *tmp = self.slides[self->currentSlideIndex];
    tmp.didAnswerCorrect = TRUE;
    self.slides[self->currentSlideIndex] = tmp;
    return TRUE;    // technically would be more robust/failsafe if we returned re-declareobject from slides...
    
}

- (NSMutableArray *) getFlagedSlides{
    NSMutableArray *flagedSlides = [[NSMutableArray alloc] init];
    bool state;
    int savePast = self->currentSlideIndex;
    for (int i=0; i<[self.slides count]; i++){
        
        [self setPresentationSlide:i];
        state = [self getCurrentSlideFlag];
        // SHT&, the above SHOULDN'T WORK, as getCurrentSlideFlag hasn't been generalized to
        // work for quiz types as well! but I can make it do that...
        if (state==YES){
            [flagedSlides addObject:[NSNumber numberWithInt:i]];
        }
    }
    [self setPresentationSlide:savePast];
    //self->currentSlideIndex = savePast; // the above does literally this, why? why exist this method??
    
    return flagedSlides;
}

- (void) clearFlaggedSlides{
    // iterate through, set flage to zero..
    int savePast = self->currentSlideIndex;
    for (int i=0; i< [self.slidesType count]; i++){
        [self setPresentationSlide:i];
        [self setCurrentSlideFlag:FALSE];
    }
    [self setPresentationSlide:savePast];
    
}

- (int) getNumberOfSLides{
    
    return (int)[self.slides count];
}


- (NSString *) getLocalName: (NSString *) language forKey:(NSString *) key{
    
    // load the general plist
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *stringDict = [[[appInfo objectForKey:@"LOCALIZATION"] objectForKey:language] objectForKey:key];
    return stringDict;
}

- (NSString *) getCurrentLanguage{
    return [self.activePlist componentsSeparatedByString:@"."][1];;
}

- (void) setActiveLanguage:(NSString *) plist{
    
    self.activePlist = plist;
}

- (NSString *) getTitleForPresentationKey: (NSString *) conditionKey{
    

    
    NSString* path;// = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *presPlist;// = [NSDictionary dictionaryWithContentsOfFile:path];

    conditionKey = [NSString stringWithFormat: @"%@.english",conditionKey];
    path = [[NSBundle mainBundle] pathForResource:conditionKey ofType:@"plist"];
    presPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    conditionKey = [[presPlist objectForKey: @"attributes"] objectForKey: @"conditionName"];
    return conditionKey;
    
}

-(void) setHoldIndex{
    self->holdIndexForReview = self->currentSlideIndex;
}
-(void) returnToHoldIndex{
    self->currentSlideIndex = self->holdIndexForReview;
}

-(int) getHoldIndex{
    return self->holdIndexForReview;
}

-(void) stateFlagReview: (BOOL) state{
    self->reviewingFlags = state;
}

-(BOOL) getReviewFlagState{
    return self->reviewingFlags;
}


@end

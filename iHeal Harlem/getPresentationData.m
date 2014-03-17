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
@synthesize slides;
@synthesize slidesType;
@synthesize activePlist;


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
        shared.activePlist = [[NSString alloc]init];
        
        // together, the slides/slide-type array make up all info of a presentation
        shared.slides = [[NSMutableArray alloc]init];
        shared.slidesType = [[NSMutableArray alloc]init];
        
        
        // now initialize the values...
        [shared getPresentationsList];
        [shared getLanguageChoices];
        
        ///////////////////////////////////////////////////////////////////////////////////
        // technically should NOT INITIALIZE THIS, only set once presentation selected...
        shared.activePlist = @"Asthma.english";
        
        [shared replacePresentation: shared.activePlist];
        shared->currentSlideIndex = 0;
        
    });
        
    return shared;
}


//  the file structure to get presentation handles
- (void) getPresentationsList {
    
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

    /*
    // GET the list of actual presentations this way! Possibly... or at least languages
    NSArray *namesArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"plist" inDirectory:@""];
    for (i=0;i<namesArray.count;i++){
        NSLog(@"from getPresData:\n%@",namesArray[i]);
    }
     */
    
     
    
    // Will delete contents of array and then populate based on read-in plists.. maybe
    [self.conditionsList removeAllObjects];
    // hard coding them for now...
    [self.conditionsList addObject:@"Asthma"];
    [self.conditionsList addObject:@"Nutrition"];
    [self.conditionsList addObject:@"placeHolder"];
    [self.conditionsList addObject:@"placeHolder"];
    
    [self.conditionsList addObject:@"Info/Usage"];
    //self.conditionsList = @[@"Asthma",@"Nutrition",@"placeHolder",@"Info/Usage"];
    
    // debug
    //NSLog(@"dataObj: %@", self.conditionsList);
    
}

// this returns current slide, called assuming it is type "slideInfo"
// need to creat one method of this style for EACH type of return,
// this is ONLy called within the slide of the according type itself
- (slideInfo *) getCurrentSlideInfo{
    
    slideInfo *currentSlide = [[slideInfo alloc] init];
    currentSlide = self.slides[self->currentSlideIndex];
    //NSLog(@"printing slide index: %i",self->currentSlideIndex);
    return currentSlide;
}


- (void) replacePresentation:(NSString*) plist{
    
    // this method takes a presentation list read-in plist
    // and replaces the currently loaded presentation with
    // this (1 specific language, 1 condition)
    
    // this is done when the language is selected in the
    // main intro screen, or if the language is dynamically changed
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *presPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *presArray = [[NSMutableArray alloc] init];
    presArray = [presPlist objectForKey:@"slides"];
    
    // first remove all entries of previous presentation
    [self.slides removeAllObjects];
    
    
    // now populate it with new entries
    // must check each time for what kind of object to construct!
    // >> make in parallel the string "typeslide" array *to be done
    for (int i=0;i<[presArray count];i++){
        NSDictionary *temp = presArray[i]; //presPlist[i];
        NSString *strTemp = temp[@"slide"];
        //NSLog(@"slide type %@", strTemp);
        
        if ([strTemp isEqual:@"info"]){
            //NSLog(@"info type: INFO");
            slideInfo *tempSlideInfo = [[slideInfo alloc]init];
            tempSlideInfo.text = temp[@"text"];
            tempSlideInfo.image = temp[@"image"];
            tempSlideInfo.title = temp[@"title"];
            
            
            //HACK fix.. cuz it was reading ANY bool value in plist as a 1
            // "25760592" == YES, "25760600" == NO, for some reason..
            int t = temp[@"flagSet"]; // #ignore warning?
            if (t==25760592){
                tempSlideInfo.flagSet = YES;
            }
            else{
                tempSlideInfo.flagSet = NO;
            }
            //NSLog(@"getPresDat: read flag %i, %i",t,tempSlideInfo.flagSet);
            [self.slides addObject:tempSlideInfo];
            [self.slidesType addObject:@"info"];
        }
        else if([strTemp isEqual:@"quiz"]){
            //NSLog(@"info type: QUIZ");
            NSLog(@"DO THE QUIZ THING");
            
            //[self.slidesType addObject:@"quiz"];
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
    //UIColor *transparent =      [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    //UIColor *skyeBlue =    [UIColor colorWithRed:78/255.0 green:193/255.0 blue:239/255.0 alpha:1];
    
    NSArray *colorArray = @[pastalOrange,pastalYellow,pastalGreen,pastalCyan,pastalBlue,pastalMagenta];
    //NSLog(@"colorObj: %@", colorArray);
    return colorArray;
}


- (NSDictionary *) getMenuTitles {
    
    ////////////////////////////////////////////////////////////////////////
    // NEED TO PROGRAMATICALLY GET THE NAME, store globally?
    // should get this/parse from indexPath.row of array.
    
    //NSString *plistName = @"Asthma.english";
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
    
    // here do some fancy file parsing to get list of plists/lanugaes from plist listing matching
    // first part of name of {conditionname, e.g. Asthma}
    
    // for now, placeholders
    [self.languageChoices addObject:@"English"];
    [self.languageChoices addObject:@"French"];
    [self.languageChoices addObject:@"Spanish"];
    
    return self.languageChoices;
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
    //
    
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

- (BOOL) getCurrentSlideFlag{
    // here would check parallel array for typedef
    slideInfo *cslide = self.slides[self->currentSlideIndex];
    bool tmp = cslide.flagSet;
    return tmp;
}

- (int) setNextSlide{
    //NSLog(@"number of slides: %i",[self.slides count]);
    if (self->currentSlideIndex+1 == [self.slides count]){
        // condition met for last slide,
        self->currentSlideIndex=0;
        return 1;
    }
    self->currentSlideIndex+=1;
    
    return 0;
}

- (int) setPreviousSlide{
    if (self->currentSlideIndex-1 < 0){
        // condition met for first slide,
        self->currentSlideIndex=0;
        return -1;
    }
    self->currentSlideIndex-=1;
    return 0;
}


- (NSString *)getSlideType{
    
    return slidesType[self->currentSlideIndex];
}

- (void) setPresentationSlide: (int) slide{
    self->currentSlideIndex=slide;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end

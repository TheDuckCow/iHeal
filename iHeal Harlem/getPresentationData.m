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
// eventually implement text parsing structure
// just return single arrays

#import "getPresentationData.h"

 
@implementation getPresentationData

@synthesize conditionsList;
@synthesize menuTitles;
@synthesize languageChoices;
@synthesize slides;
//@synthesize currentSlideIndex;



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
        [shared.menuTitles addObject:@"Start Presentation\n"];
        shared.languageChoices = [[NSMutableArray alloc]init];
        shared.slides = [[NSMutableArray alloc]init];
        //shared.currentSlideIndex = [[int alloc]init]; // gah I need just an int, not an object!!
        
        // now initialize the values...
        [shared getPresentationsList];
        [shared getLanguageChoices];
        //shared.getPresentationsList;
        //shared.getLanguageChoices;
        
        
    });
        
    return shared;
}


// parses the file structure to get presentation handles
- (void) getPresentationsList {
    
    NSLog(@"######### A");
    
    NSFileManager *filemgr;
    NSString *currentpath;
    NSArray *filelist;
    int count;
    int i;
    filemgr = [NSFileManager defaultManager];
    currentpath = [filemgr currentDirectoryPath];
    
    filelist = [filemgr contentsOfDirectoryAtPath: currentpath error: nil];
    //filelist = [filemgr contentsOfDirectoryAtPath: @"/presentations" error: nil];
    
    count = [filelist count];
    NSLog(@"%d",count);
    
    for (i = 0; i < count; i++)
        //NSLog(@"#########");
        NSLog (@"%@", [filelist objectAtIndex: i]);
    
    
    // lists images....... .. . .  .    .       .
    NSArray *namesArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@""];
    for (i=0;i<namesArray.count;i++){
        NSLog(@"%@",namesArray[i]);
    }
    
    // everytime you call it.. it will add more.. need to REPLACE the array
    [self.conditionsList addObject:@"Asthma"];
    [self.conditionsList addObject:@"Nutrition"];
    [self.conditionsList addObject:@"placeHolder"];
    [self.conditionsList addObject:@"placeHolder"];
    [self.conditionsList addObject:@"placeHolder"];
    
    [self.conditionsList addObject:@"Info/Usage"];
    //self.conditionsList = @[@"Asthma",@"Nutrition",@"placeHolder",@"Info/Usage"];
    
    // debug
    //NSLog(@"dataObj: %@", self.conditionsList);
    
}

// this returns current slide, called assuming it is type "slideInfo"
- (slideInfo *) getCurrentSlideInfo{
    // later.. get it from the self.currentSlideIndex
    
    slideInfo *currentSlide = [[slideInfo alloc] init];
    currentSlide.image = @"asthma_01.jpg";
    currentSlide.text = @"static preloaded stuff repeatz?";
    currentSlide.title = @"TITLEYO";
    
    return currentSlide;
}


+ (void) replacePresentation:(NSMutableArray*) presPlist{
    
    // this method takes a presentation list read-in plist
    // and replaces the currently loaded presentation with
    // this (1 specific language, 1 condition)
    
    for (int i=0;i<[presPlist count];i++){
        NSDictionary *temp = presPlist[i];
        NSString *strTemp = temp[@"slide"];
        NSLog(@"slide type %@", strTemp);
    }
    
    //self->slides = presPlist;
    //self.slides = &presPlist;
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


- (NSMutableArray *) getMenuTitles {
    // NEED TO PROGRAMATICALLY GET THE NAME, store globally?
    // and furthermroe, should NOT do in the view controllers...
    
    
    NSString *plistName = @"Asthma.english"; // should get this/parse from indexPath.row of array.

    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *attr = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *attributes = [[NSDictionary alloc] init];
    attributes = [attr objectForKey:@"attributes"];
    //NSLog(@"dictionary = %@", attr);

    NSMutableArray *plistMenuTitles = [attributes objectForKey:@"menuTitles"];

    
    
    // add the menu options to the menu titles, index + 1 (start presentation ALWAYS first)
    for (int i=0; i< [plistMenuTitles count]; i++){
        self.menuTitles[1+i]=plistMenuTitles[i];
    }

    return self.menuTitles;
    
}

- (NSMutableArray *) getLanguageChoices {
    
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


- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end

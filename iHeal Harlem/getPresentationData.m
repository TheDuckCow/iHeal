//
//  getPresentationData.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/19/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//



// data hard coded for now
// eventually implement text parsing structure
// just return single arrays

#import "getPresentationData.h"

 
@implementation getPresentationData

@synthesize conditionsList;
@synthesize menuTitles;
@synthesize languageChoices;
@synthesize slides;



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
        shared.languageChoices = [[NSMutableArray alloc]init];
        shared.slides = [[NSMutableArray alloc]init];
        
        // now initialize the values...
        [shared getPresentationsList];
        [shared getLanguageChoices];
        //shared.getPresentationsList;
        //shared.getLanguageChoices;
        
        
    });
        
    return shared;
}


- (void) getPresentationsList {
    
    
    // everytime you call it.. it will add more.. need to REPLACE the array
    [self.conditionsList addObject:@"Asthma"];
    [self.conditionsList addObject:@"Nutrition"];
    [self.conditionsList addObject:@"placeHolder"];
    [self.conditionsList addObject:@"placeHolder"];
    [self.conditionsList addObject:@"placeHolder"];
    [self.conditionsList addObject:@"placeHolder"];
    
    [self.conditionsList addObject:@"Info/Usage"];
    //self.conditionsList = @[@"Asthma",@"Nutrition",@"placeHolder",@"Info/Usage"];
    
    // debug
    NSLog(@"dataObj: %@", self.conditionsList);
    
    
}


- (NSArray *)getPastalColorArray
{
    UIColor *pastalOrange =     [UIColor colorWithRed:254/255.0 green:235/255.0 blue:201/255.0 alpha:1];
    UIColor *pastalYellow =     [UIColor colorWithRed:255/255.0 green:255/255.0 blue:176/255.0 alpha:1];
    UIColor *pastalGreen =      [UIColor colorWithRed:224/255.0 green:243/255.0 blue:176/255.0 alpha:1];
    UIColor *pastalCyan =       [UIColor colorWithRed:179/255.0 green:226/255.0 blue:221/255.0 alpha:1];
    UIColor *pastalBlue =       [UIColor colorWithRed:191/255.0 green:213/255.0 blue:232/255.0 alpha:1];
    UIColor *pastalMagenta =    [UIColor colorWithRed:221/255.0 green:212/255.0 blue:232/255.0 alpha:1];
    
    NSArray *colorArray = @[pastalOrange,pastalYellow,pastalGreen,pastalCyan,pastalBlue,pastalMagenta];
    //NSLog(@"colorObj: %@", colorArray);
    return colorArray;
}


- (NSMutableArray *) getMenuTitles {
    
    [self.menuTitles addObject:@"Start Presentation"];
    [self.menuTitles addObject:@"Continue Presentation"];
    [self.menuTitles addObject:@"Jumo to slide x/x: 'title'"];
    [self.menuTitles addObject:@"Jump to first quiz slide"];
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

@end

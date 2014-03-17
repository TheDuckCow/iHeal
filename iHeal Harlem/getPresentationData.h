//
//  getPresentationData.h
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/19/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "slideInfo.h"
#import "slideQuiz.h"

@interface getPresentationData : NSObject {
    
    int currentSlideIndex;
}

// wait... these.. these should not be in the interface...
@property (nonatomic, strong) NSMutableArray *conditionsList;
@property (nonatomic, strong) NSMutableArray *menuTitles;
@property (nonatomic, strong) NSMutableArray *menuKeys;
@property (nonatomic, strong) NSMutableArray *languageChoices;
@property (nonatomic, strong) NSMutableArray *slides;
@property (nonatomic, strong) NSMutableArray *slidesType;
@property (nonatomic, strong) NSString *activePlist;
//@property int *currentSlideIndex;


+ (getPresentationData *) dataShared;

- (void) test;

- (void) getPresentationsList;

- (void) replacePresentation:(NSString*) plist;
//- (void) repl racePresentation:(NSMutableArray*) presPlist;

- (NSArray *) getPastalColorArray;

- (NSDictionary *) getMenuTitles;

- (NSMutableArray *) getLanguageChoices;

- (NSMutableArray *) getSlides;

- (slideInfo *) getCurrentSlideInfo;

- (NSMutableArray *) getInfoSlide;

- (BOOL) toggleCurrentSlideFlag;

- (BOOL) getCurrentSlideFlag;

- (int) setNextSlide;
- (int) setPreviousSlide;

- (NSString *) getSlideType;

- (void) setPresentationSlide: (int) slide;


@end

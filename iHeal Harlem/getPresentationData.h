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
#import "slideIntro.h"
#import "slideOutro.h"

@interface getPresentationData : NSObject {
    
    int currentSlideIndex;
    int jumpSlideIndex;
    int holdIndexForReview;
    BOOL reviewingFlags;
}

// wait... these.. these should not be in the interface...
// I access as least one of the variables directly at some point
@property (nonatomic, strong) NSMutableArray *conditionsList;
@property (nonatomic, strong) NSMutableArray *menuTitles;
@property (nonatomic, strong) NSMutableArray *menuKeys;
@property (nonatomic, strong) NSMutableArray *languageChoices;
@property (nonatomic, strong) NSMutableArray *languageUINames;
@property (nonatomic, strong) NSMutableArray *slides;
@property (nonatomic, strong) NSMutableArray *slidesType;
@property (nonatomic, strong) NSString *activePlist;
@property (nonatomic, strong) NSString *activeConditionName;
@property (nonatomic, strong) NSString *activeConditionUIName;
// FlowModes: "linear", "flagCheck",
@property (nonatomic, strong) NSString *presentationFlowMode;


+ (getPresentationData *) dataShared;

- (void) test;

- (NSMutableArray *) getPresentationsList;

- (void) replacePresentation:(NSString*) plist flags: (BOOL) keepFlags;

- (NSArray *) getPastalColorArray;

- (NSDictionary *) getMenuTitles;

- (NSMutableArray *) getLanguageChoices;

- (NSMutableArray *) getLanguageUINames;

- (NSMutableArray *) getSlides;

- (slideInfo *) getCurrentSlideInfo;
- (slideQuiz *) getCurrentSlideQuiz;
- (slideIntro *) getCurrentSlideIntro;
- (slideOutro *) getCurrentSlideOutro;


- (BOOL) toggleCurrentSlideFlag;
- (BOOL) setCurrentSlideFlag:(bool)state;

- (BOOL) getCurrentSlideFlag;

- (int) setNextSlide;

- (int) setPreviousSlide;

- (NSString *) getSlideType;

- (void) setPresentationSlide: (int) slide;

- (int) jumpToFirstQuizSlide;

- (int) getCurrentSlideIndex;

- (NSString *) getPresentationKeyname;

- (NSString *) getSlideTitle;

- (void) setLanguageNames;
- (bool) quizDidAnswerCorrect;

- (NSMutableArray *) getFlagedSlides;
- (void) clearFlaggedSlides;

- (int) getNumberOfSLides;

- (NSString *) getLocalName: (NSString *) language forKey:(NSString *) key;

- (NSString *) getCurrentLanguage;

- (void) setActiveLanguage:(NSString *) plist;
- (NSString *) getTitleForPresentationKey: (NSString *) conditionKey;

-(void) setHoldIndex;
-(void) returnToHoldIndex;
-(int) getHoldIndex;

-(void) stateFlagReview: (BOOL) state;
-(BOOL) getReviewFlagState;


@end

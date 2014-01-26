//
//  getPresentationData.h
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/19/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getPresentationData : NSObject {
}


@property (nonatomic, strong) NSMutableArray *conditionsList;
@property (nonatomic, strong) NSMutableArray *menuTitles;
@property (nonatomic, strong) NSMutableArray *languageChoices;
@property (nonatomic, strong) NSMutableArray *slides;


+ (getPresentationData *) dataShared;

- (void) test;

- (void) getPresentationsList;

- (NSArray *) getPastalColorArray;

- (NSMutableArray *) getMenuTitles;

- (NSMutableArray *) getLanguageChoices;

- (NSMutableArray *) getSlides;

- (NSMutableArray *) getInfoSlide;


@end

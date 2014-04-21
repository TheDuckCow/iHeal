//
//  slideIntro.h
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 4/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface slideIntro : NSObject

@property NSMutableArray *langOptions;
@property NSString *welcome;
@property BOOL flagSet;

// less significant or can be missing
@property NSString *imgGesture;

@end

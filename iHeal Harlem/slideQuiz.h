//
//  slideQuiz.h
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface slideQuiz : NSObject

@property NSString *question;
@property NSMutableArray *answers;
@property int solution;
@property NSString *explanation;
@property NSString *title;
@property BOOL didAnswerCorrect;
@property BOOL flagSet;
@property int slideRef;


// less significant or can be missing
@property NSString *image;

@end

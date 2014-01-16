//
//  slideQuiz.h
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "slide.h"

@interface slideQuiz : slide

@property NSString *question;
@property NSMutableArray *solutions;
@property NSString *correctSolution;
@property NSString *explanation;
@property BOOL didAnswerCorrect;

-(void)didAnswer:(NSString *)choice;

// less significant or can be missing
@property NSString *pictureURL;

@end

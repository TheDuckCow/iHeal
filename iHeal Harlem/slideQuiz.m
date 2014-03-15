//
//  slideQuiz.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "slideQuiz.h"



@implementation slideQuiz



-(void)didAnswer:(NSString *)choice{
    
    if (choice == self.solution){
        self.didAnswerCorrect=YES;
    }
}


@end

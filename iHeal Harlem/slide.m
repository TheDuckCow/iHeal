//
//  slide.m
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import "slide.h"

@implementation slide

+(void) incrementSlide {
    // if they were object (-) and not class
    // functions, self.currentSLide would work..
    // but this, this doesn't. Need to find out
    // how to make class wide properties.
    
    //self.currentSlide = 1; // problem
    
    // this function WON'T set/start the segue (separate data from views), but this number will ALWAYS be used as the index for which slide/data is chosen thereafter
}


+(void) decrementSlide {
    
}

/*
+(void)incrementSlide{
    if (self.currentSlide==self.slideCount){
        //end of presentation!
        self.currentSlide = 0;
    }
    else{
        self.currentSlide+=1;
    }
}
 */

@end

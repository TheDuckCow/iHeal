//
//  slide.h
//  iHeal Harlem
//
//  Created by Patrick W. Crawford on 1/14/14.
//  Copyright (c) 2014 Harlem Hospital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface slide : NSObject

//@property (readonly) NSString *name;

// really only purpose of this is to have the class-wide controlled slide number value
@property (readonly) int slideCount;
@property int currentSlide;

+(void)incrementSlide;
+(void)decrementSlide;

@end

//
//  CGEventCreateScrollWheelEvent.m
//  multipeer connectivity osx
//
//  Created by Brabeeba Wang on 12/15/14.
//  Copyright (c) 2014 Brabeeba Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "multipeer connectivity osx-Bridging-Header.h"

@implementation CustomObject

- (void) someMethod:(int32_t) a{
    CGEventRef scroll = CGEventCreateScrollWheelEvent(NULL,
                                                      kCGScrollEventUnitLine,
                                                      1,
                                                      a);
    CGEventPost(kCGHIDEventTap, scroll);
    CFRelease(scroll);
}

@end
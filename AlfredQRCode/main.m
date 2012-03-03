//
//  main.m
//  AlfredQRCode
//
//  Created by Seraph on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
        [NSApp setDelegate:[AppDelegate new]];
        [NSApp activateIgnoringOtherApps:YES];
        [NSApp run];
    }
    return 0;
}


//
//  AppDelegate.m
//  AlfredQRCode
//
//  Created by Seraph on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "QSQRShowImage.h"
#import "QSQRCodeRenderer.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *text;
    NSImage *image;
    NSArray *arguments;
    
    arguments = [[NSProcessInfo processInfo] arguments];
    if ([arguments count] > 1) {
        text = [arguments objectAtIndex:1];
        // If the text input is from Alfred argument
        if ([text length]) {
            image = QRRenderCodeFor(text);
            [QSQRShowImage showImage:image]; 
        }
        // If the argument from Alfred is empty, read from the clipboard
        else {
            NSPasteboard *thePasteboard = [NSPasteboard generalPasteboard];
            text = [thePasteboard stringForType:NSStringPboardType];
            if ([text length]) {
                NSImage *image = QRRenderCodeFor(text);
                [QSQRShowImage showImage:image]; 
            } else {
                [NSApp terminate:nil];
            }
        }
    }
}

@end

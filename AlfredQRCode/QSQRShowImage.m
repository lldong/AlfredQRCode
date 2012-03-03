//
//  QSQRShowImage.m
//  QSQRCode
//
//  Created by Eric Doughty-Papassideris on 4/01/10.
//  Copyright 2010 FWA. All rights reserved.
//

#import "QSQRShowImage.h"


/* Function copied from Adam Maxwell
   http://code.google.com/p/mactlmgr/source/browse/trunk/TLMStatusWindow.m?spec=svn569&r=569
*/
static void CenterRectInRect(NSRect *toCenter, NSRect enclosingRect)
{
    CGFloat halfWidth = NSWidth(*toCenter) / 2.0;
    CGFloat halfHeight = NSHeight(*toCenter) / 2.0;
    NSPoint centerPoint = NSMakePoint(NSMidX(enclosingRect), NSMidY(enclosingRect));
    centerPoint.x -= halfWidth;
    centerPoint.y -= halfHeight;
    toCenter->origin = centerPoint;
}

@implementation QSQRShowImage

+ (void)showImage:(NSImage *)image 
{
	NSRect visibleRect = [[NSScreen mainScreen] visibleFrame];
	NSSize size = [image size];
	NSSize maxCodeSize = NSMakeSize(visibleRect.size.width * 0.85, visibleRect.size.height * 0.85);
    
	if (size.width > maxCodeSize.width) {
		size.height = size.height * (maxCodeSize.width / size.width);
		size.width = maxCodeSize.width;
	}
    
	if (size.height > maxCodeSize.height) {
		size.width = size.width * (maxCodeSize.height / size.height);
		size.height = maxCodeSize.height;
	}
    
	NSRect imageRect = NSMakeRect(0, 0, size.width, size.height);
	NSRect frameRect = NSMakeRect(0, 0, size.width, size.height);
    
	NSImageView *imageView;
    imageView = [[[NSImageView alloc] initWithFrame:imageRect] autorelease];
	[imageView setImage:image];
	[imageView setEditable:NO];
	[imageView setImageScaling:NSImageScaleProportionallyUpOrDown];

	CenterRectInRect(&frameRect, visibleRect);
    
	NSWindow *largeTypeWindow;
    largeTypeWindow = [[QSQRShowImage alloc] 
                        initWithContentRect:imageRect 
                                  styleMask:NSBorderlessWindowMask |
                                            NSNonactivatingPanelMask 
                                    backing:NSBackingStoreBuffered 
                                      defer:NO];
    
	[largeTypeWindow setFrame:frameRect display:YES];
	[largeTypeWindow setIgnoresMouseEvents:YES];
	[largeTypeWindow setOpaque:YES];
	[largeTypeWindow setLevel:NSFloatingWindowLevel];
	[largeTypeWindow setBackgroundColor:[NSColor clearColor]];
	[largeTypeWindow setHidesOnDeactivate:NO];
	[largeTypeWindow setContentView:imageView];
	[largeTypeWindow makeKeyAndOrderFront:nil];
	[largeTypeWindow setInitialFirstResponder:imageView];
	[[largeTypeWindow contentView] display];
}

- (id)initWithContentRect:(NSRect)contentRect 
                styleMask:(NSUInteger)aStyle 
                  backing:(NSBackingStoreType)bufferingType 
                    defer:(BOOL)flag 
{
	if (self = [super initWithContentRect:contentRect 
                                styleMask:aStyle 
                                  backing:bufferingType 
                                    defer:flag]) {
		[self setReleasedWhenClosed:YES];
	}
    
	return self;
}

- (IBAction)copy:(id)sender 
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
	[pb setString:[(NSTextField *)[self initialFirstResponder] stringValue] 
          forType:NSStringPboardType];
}

- (BOOL)canBecomeKeyWindow { return YES; }

- (void)keyDown:(NSEvent *)theEvent
{
    [self close];
    [NSApp terminate:nil];
}

- (void)resignKeyWindow 
{
	[super resignKeyWindow];
	if ([self isVisible]) {
		[self close];
        [NSApp terminate:nil];
	}
}

@end

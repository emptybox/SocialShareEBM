/**
 * ShareImage
 *
 * Created by Empty Box Media
 * Copyright (c) 2024 Empty Box Media. All rights reserved.
 */

#import "ComEbmShareimageModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "ShareImageModule.h"
#import "TiBlob.h"
#import "TiApp.h"

@implementation ComEbmShareimageModule

#pragma mark Internal

// This is generated for your module, please do not change it
- (id)moduleGUID
{
  return @"a177a0dd-bc91-4fe7-8abb-d869240544e8";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
  return @"com.ebm.shareimage";
}

#pragma mark Lifecycle

- (void)startup
{
  // This method is called when the module is first loaded
  // You *must* call the superclass
  [super startup];
  DebugLog(@"[DEBUG] %@ loaded", self);
}

- (void)share:(id)args {
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *text = [TiUtils stringValue:@"text" properties:args];
    TiBlob *imageBlob = [args objectForKey:@"image"];
    KrollCallback *callback = [args objectForKey:@"callback"];
    
    UIImage *image = [imageBlob image];
    NSArray *activityItems = @[text, image];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [[TiApp app] controller];
        while (rootViewController.presentedViewController) {
            rootViewController = rootViewController.presentedViewController;
        }

        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

        activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList];

        activityViewController.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            if (callback != nil) {
                NSDictionary *event = @{@"success": @(completed)};
                [self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:nil];
            }
        };

        [rootViewController presentViewController:activityViewController animated:YES completion:nil];
    });
}

@end

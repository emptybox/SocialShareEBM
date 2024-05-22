//
//  ShareImageModule.m
//  ShareImage
//
//  Created by Unoma Haus on 5/22/24.
//

#import "ShareImageModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"
#import "TiApp.h"

@implementation ShareImageModule

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

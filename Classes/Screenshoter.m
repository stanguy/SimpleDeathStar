//
//  Screenshoter.m
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 2/16/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import "Screenshoter.h"

CGImageRef UIGetScreenImage(); //private API for getting an image of the entire screen

@implementation Screenshoter

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self performSelector:@selector(takeScreenshot:) withObject:[[viewController class] description] afterDelay:0.5];
}

-(void)takeScreenshot:(NSString*)name
{
    //Get image with status bar cropped out
    CGFloat StatusBarHeight = [[UIScreen mainScreen] scale] == 1 ? 20 : 40;
    CGImageRef CGImage = UIGetScreenImage();
    CGRect imageRect = CGRectMake(0, StatusBarHeight, CGImageGetWidth(CGImage), CGImageGetHeight(CGImage) - StatusBarHeight);
    CGImage = CGImageCreateWithImageInRect(CGImage, imageRect);
    
    UIImage *image = [UIImage imageWithCGImage:CGImage];
    NSData *data = UIImagePNGRepresentation(image);
    NSString *file = [NSString stringWithFormat:@"%@-%.0f-%@.png", [[NSLocale currentLocale] localeIdentifier], CGRectGetHeight([[UIScreen mainScreen] bounds]), name];
    NSString *path = [@"/tmp/" stringByAppendingPathComponent:file];
    
    
    if ( [data writeToFile:path atomically:YES] ) {
        NSLog(@"Saving screenshot: %@", path);
    } else {
        NSLog(@"failed to save screenshot: %@", path);
    }

}

@end

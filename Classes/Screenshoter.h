//
//  Screenshoter.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 2/16/13.
//  Copyright (c) 2013 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Screenshoter : NSObject <UINavigationControllerDelegate>

-(void)takeScreenshot:(NSString*)name;

@end

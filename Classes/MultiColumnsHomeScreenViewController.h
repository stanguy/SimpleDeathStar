//
//  MultiColumnsHomeScreenViewController.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 11/17/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import "ISColumnsController.h"

#import "ADViewComposer.h"

@interface MultiColumnsHomeScreenViewController : ISColumnsController {
@private
    ADViewComposer* viewComposer;
}

- (void)reloadByTimer;

@end

//
//  FavoritesSection.h
//  SimpleDeathStar
//
//  Created by Sebastien Tanguy on 10/21/12.
//  Copyright (c) 2012 dthg.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TimePresenterSection.h"

@interface FavoritesHomeSection : TimePresenterSection {
    int cachedFavoritesCount;
}

@property (retain) NSArray* topFavorites;
@property (retain) NSArray* favoriteTimes;

- (NSInteger)numberOfElements;
- (NSString*)title;


@end

//
//  UIScrollView+HLZInfinite.h
//  HLZInfiniteScroll
//
//  Created by Hu Lizhen on 6/8/16.
//  Copyright © 2016 hulz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HLZInfinite)

@property (nonatomic, getter=isInfinite) BOOL infinite;
@property (nonatomic, strong) NSArray *contentViews;

@end

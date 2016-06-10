//
//  UIScrollView+HLZInfinite.h
//  HLZInfiniteScroll
//
//  Created by Hu Lizhen on 6/8/16.
//  Copyright © 2016 hulz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HLZInfinite)

/** A Boolean value that determines whether infinite scrolling is enabled for the scroll view.
 
 If the value of this property is YES, the scroll view can be scrolled infinitely and show the views in the `infiniteViews` infinitely when the user scrolls.
 
 The default value is NO. */
@property (nonatomic, getter=isInfinite) BOOL infinite;

/** The views array which you want to show in the scroll view horizontally and to be scrolled infinitely. */
@property (nonatomic, strong) NSArray *infiniteViews;

@end

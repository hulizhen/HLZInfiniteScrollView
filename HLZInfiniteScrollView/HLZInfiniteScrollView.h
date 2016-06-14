//
//  HLZInfiniteScrollView.h
//  HLZInfiniteScrollView
//
//  Created by Hu Lizhen on 6/14/16.
//  Copyright © 2016 hulizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLZInfiniteScrollView : UIScrollView

@property (nonatomic, copy) NSArray *contentViews;
@property (nonatomic, getter=isInfiniteScrollEnabled) BOOL infiniteScrollEnabled;

@end

//
//  UIScrollView+HLZInfinite.m
//  HLZInfiniteScroll
//
//  Created by Hu Lizhen on 6/8/16.
//  Copyright © 2016 hulz. All rights reserved.
//

#import "UIScrollView+HLZInfinite.h"
#import <objc/runtime.h>


// Only use three pages to hold views in the scroll view.
// They are for left/center/right view, respectively.

@implementation UIScrollView (HLZInfinite)

#pragma mark - Private Variables

static NSInteger viewCount;
static NSInteger leftViewIndex;
static NSInteger centerViewIndex;
static NSInteger rightViewIndex;

static UIView *leftView;
static UIView *centerView;
static UIView *rightView;

#pragma mark - Setups

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(hlz_layoutSubviews));
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

#pragma mark - Accessors

- (void)setInfinite:(BOOL)infinite {
    NSNumber *number = [NSNumber numberWithBool:infinite];
    objc_setAssociatedObject(self, @selector(isInfinite), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isInfinite {
    NSNumber *number = objc_getAssociatedObject(self, @selector(isInfinite));
    return [number boolValue];
}

- (void)setContentViews:(NSArray *)contentViews {
    objc_setAssociatedObject(self, @selector(contentViews), contentViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    viewCount = self.contentViews.count;
    if (viewCount <= 0) {
        return;
    }
    
    // The message `shiftToLeft` will be sent to `self` when the first time `layoutSubviews` is called,
    // because the `self.contentOffset.x` is zero at first.
    // So we put the center one, which is supposed to in the middle, at the left in advance.
    leftViewIndex = 0;
    centerViewIndex = 1;
    rightViewIndex = 2;
    
    leftView = contentViews[leftViewIndex];
    centerView = contentViews[centerViewIndex];
    rightView = contentViews[rightViewIndex];
    
    [self addSubview:leftView];
    [self addSubview:centerView];
    [self addSubview:rightView];
}

- (NSArray *)contentViews {
    return objc_getAssociatedObject(self, @selector(contentViews));
}

- (void)hlz_layoutSubviews {
    [self hlz_layoutSubviews];
    
    if (!self.isInfinite || viewCount <= 0) {
        return;
    }
    
    [self recenter];
}

#pragma mark - Helpers

- (NSInteger)increaseViewIndex:(NSInteger)index {
    ++index;
    return (index >= viewCount) ? index %= viewCount : index;
}

- (NSInteger)decreaseViewIndex:(NSInteger)index {
    --index;
    return (index < 0) ? index += viewCount : index;
}

- (void)shiftToLeft {
}

- (void)shiftToRight {
}

// Show the center one in the middle of scroll view's content.
- (void)recenter {
    if (self.contentOffset.x >= self.bounds.size.width / 4 &&
        self.contentOffset.x <= self.bounds.size.width * 7/4) {
        return;
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    
    if (self.contentOffset.x < self.bounds.size.width / 4) {
        [rightView removeFromSuperview];
        
        leftViewIndex = [self decreaseViewIndex:leftViewIndex];
        centerViewIndex = [self decreaseViewIndex:centerViewIndex];
        rightViewIndex = [self decreaseViewIndex:rightViewIndex];
        
        rightView = centerView;
        centerView = leftView;
        leftView = self.contentViews[leftViewIndex];
        
        [self addSubview:leftView];
        
        self.contentOffset = CGPointMake(self.contentOffset.x + self.bounds.size.width, 0);
    } else {
        [leftView removeFromSuperview];
        
        leftViewIndex = [self increaseViewIndex:leftViewIndex];
        centerViewIndex = [self increaseViewIndex:centerViewIndex];
        rightViewIndex = [self increaseViewIndex:rightViewIndex];
        
        leftView = centerView;
        centerView = rightView;
        rightView = self.contentViews[rightViewIndex];
        
        [self addSubview:rightView];
        
        self.contentOffset = CGPointMake(self.contentOffset.x - self.bounds.size.width, 0);
    }
    
    leftView.frame = self.frame;
    centerView.frame = CGRectOffset(leftView.frame, self.frame.size.width, 0);
    rightView.frame = CGRectOffset(centerView.frame, self.frame.size.width, 0);
    
}

@end

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

static UIView *leftContentView;
static UIView *centerContentView;
static UIView *rightContentView;

#pragma mark - Lifecycle

+ (void)load {
    // Swizzle the `layoutSubviews` method.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(hlz_layoutSubviews));
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)hlz_layoutSubviews {
    [self hlz_layoutSubviews];
    
    if (!self.isInfinite || viewCount <= 0) {
        return;
    }
    
    [self reassignViews];
}

#pragma mark - Accessors

- (void)setInfinite:(BOOL)infinite {
    NSNumber *number = [NSNumber numberWithBool:infinite];
    objc_setAssociatedObject(self, @selector(isInfinite), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isInfinite {
    NSNumber *number = objc_getAssociatedObject(self, @selector(isInfinite));
    if (number == nil) {
        // Set a default value.
        number = [NSNumber numberWithBool:NO];
        objc_setAssociatedObject(self, @selector(isInfinite), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [number boolValue];
}

- (void)setInfiniteViews:(NSArray *)infiniteViews {
    objc_setAssociatedObject(self, @selector(infiniteViews), infiniteViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    viewCount = self.infiniteViews.count;
    if (viewCount <= 0) {
        leftContentView = nil;
        centerContentView = nil;
        rightContentView = nil;
        return;
    } else {
        // The message `shiftToLeft` will be sent to `self` when the first time `layoutSubviews` is called,
        // because the `self.contentOffset.x` is zero at first.
        // So we put the center one, which is supposed to in the middle, at the left in advance.
        leftViewIndex = 0;
        centerViewIndex = 1;
        rightViewIndex = 2;
        
        [self configureContentViews];
    }
}

- (NSArray *)infiniteViews {
    return objc_getAssociatedObject(self, @selector(infiniteViews));
}

#pragma mark - Helpers

- (void)configureContentViews {
    leftContentView = [[UIView alloc] init];
    centerContentView = [[UIView alloc] init];
    rightContentView = [[UIView alloc] init];
    
    [self addSubview:leftContentView];
    [self addSubview:centerContentView];
    [self addSubview:rightContentView];
    
    leftContentView.translatesAutoresizingMaskIntoConstraints = NO;
    centerContentView.translatesAutoresizingMaskIntoConstraints = NO;
    rightContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set constraints between the scroll view and the content views.
    [NSLayoutConstraint activateConstraints:@[[leftContentView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                                              [leftContentView.rightAnchor constraintEqualToAnchor:centerContentView.leftAnchor],
                                              [leftContentView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                              [leftContentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                                              [leftContentView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
                                              [leftContentView.heightAnchor constraintEqualToAnchor:self.heightAnchor]]];
    [NSLayoutConstraint activateConstraints:@[[centerContentView.leftAnchor constraintEqualToAnchor:leftContentView.rightAnchor],
                                              [centerContentView.rightAnchor constraintEqualToAnchor:rightContentView.leftAnchor],
                                              [centerContentView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                              [centerContentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                                              [centerContentView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
                                              [centerContentView.heightAnchor constraintEqualToAnchor:self.heightAnchor]]];
    [NSLayoutConstraint activateConstraints:@[[rightContentView.leftAnchor constraintEqualToAnchor:centerContentView.rightAnchor],
                                              [rightContentView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                              [rightContentView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                              [rightContentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                                              [rightContentView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
                                              [rightContentView.heightAnchor constraintEqualToAnchor:self.heightAnchor]]];
}

- (void)reassignViews {
    if (self.contentOffset.x >= self.bounds.size.width / 4 &&
        self.contentOffset.x <= self.bounds.size.width * 7/4) {
        // It's not the time to reassign views to content views, do nothing.
        return;
    }
    
    UIView *leftView = self.infiniteViews[leftViewIndex];
    UIView *centerView = self.infiniteViews[centerViewIndex];
    UIView *rightView = self.infiniteViews[rightViewIndex];
    
    self.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    
    [leftView removeFromSuperview];
    [centerView removeFromSuperview];
    [rightView removeFromSuperview];
    
    // Update the contentOffset of scroll view and indexes of views.
    if (self.contentOffset.x < self.bounds.size.width / 4) {
        // Shift to the left.
        self.contentOffset = CGPointMake(self.contentOffset.x + self.bounds.size.width, 0);
        
        leftViewIndex = [self decreaseViewIndex:leftViewIndex];
        centerViewIndex = [self decreaseViewIndex:centerViewIndex];
        rightViewIndex = [self decreaseViewIndex:rightViewIndex];
    } else {
        // Shift to the right.
        self.contentOffset = CGPointMake(self.contentOffset.x - self.bounds.size.width, 0);
        
        leftViewIndex = [self increaseViewIndex:leftViewIndex];
        centerViewIndex = [self increaseViewIndex:centerViewIndex];
        rightViewIndex = [self increaseViewIndex:rightViewIndex];
    }
    
    leftView = self.infiniteViews[leftViewIndex];
    centerView = self.infiniteViews[centerViewIndex];
    rightView = self.infiniteViews[rightViewIndex];
    
    [leftContentView addSubview:self.infiniteViews[leftViewIndex]];
    [centerContentView addSubview:self.infiniteViews[centerViewIndex]];
    [rightContentView addSubview:self.infiniteViews[rightViewIndex]];
    
    // Set the views' frame.
    leftView.frame = leftContentView.bounds;
    centerView.frame = centerContentView.bounds;
    rightView.frame = rightContentView.bounds;
    
    // Translates autoresizing mask into constraints.
    leftView.translatesAutoresizingMaskIntoConstraints = YES;
    centerView.translatesAutoresizingMaskIntoConstraints = YES;
    rightView.translatesAutoresizingMaskIntoConstraints = YES;
    
    // Resize the views' width and height according to their superviews.
    leftView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    centerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    rightView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (NSInteger)increaseViewIndex:(NSInteger)index {
    ++index;
    return (index >= viewCount) ? index %= viewCount : index;
}

- (NSInteger)decreaseViewIndex:(NSInteger)index {
    --index;
    return (index < 0) ? index += viewCount : index;
}

@end

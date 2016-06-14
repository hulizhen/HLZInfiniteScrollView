//
//  HLZInfiniteScrollView.m
//  HLZInfiniteScrollView
//
//  Created by Hu Lizhen on 6/14/16.
//  Copyright © 2016 hulizhen. All rights reserved.
//

#import "HLZInfiniteScrollView.h"

@interface HLZInfiniteScrollView ()

@property (nonatomic, assign) NSInteger leftViewIndex;
@property (nonatomic, assign) NSInteger centerViewIndex;
@property (nonatomic, assign) NSInteger rightViewIndex;

@end

@implementation HLZInfiniteScrollView

#pragma mark - Private Variables

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reassignViews];
}

#pragma mark - Accessors

- (void)setContentViews:(NSArray *)contentViews {
    _contentViews = contentViews;
}

#pragma mark - Helpers

- (void)setUp {
    self.leftViewIndex = 0;
    self.centerViewIndex = 1;
    self.rightViewIndex = 2;
}

- (NSInteger)increaseViewIndex:(NSInteger)index {
    ++index;
    return (index >= self.contentViews.count) ? index %= self.contentViews.count : index;
}

- (NSInteger)decreaseViewIndex:(NSInteger)index {
    --index;
    return (index < 0) ? index += self.contentViews.count : index;
}

- (void)reassignViews {
    if (self.contentOffset.x >= self.bounds.size.width / 4 &&
        self.contentOffset.x <= self.bounds.size.width * 7/4) {
        // It's not the time to reassign views to container views, do nothing.
        return;
    }
    
    UIView *leftView = self.contentViews[self.leftViewIndex];
    UIView *centerView = self.contentViews[self.centerViewIndex];
    UIView *rightView = self.contentViews[self.rightViewIndex];
    
    [leftView removeFromSuperview];
    [centerView removeFromSuperview];
    [rightView removeFromSuperview];
    
    // Update the contentOffset of scroll view and indexes of views.
    if (self.contentOffset.x < self.bounds.size.width / 4) {
        self.contentOffset = CGPointMake(self.contentOffset.x + self.bounds.size.width, 0);
        
        self.leftViewIndex = [self decreaseViewIndex:self.leftViewIndex];
        self.centerViewIndex = [self decreaseViewIndex:self.centerViewIndex];
        self.rightViewIndex = [self decreaseViewIndex:self.rightViewIndex];
    } else {
        self.contentOffset = CGPointMake(self.contentOffset.x - self.bounds.size.width, 0);
        
        self.leftViewIndex = [self increaseViewIndex:self.leftViewIndex];
        self.centerViewIndex = [self increaseViewIndex:self.centerViewIndex];
        self.rightViewIndex = [self increaseViewIndex:self.rightViewIndex];
    }
    
    leftView = self.contentViews[self.leftViewIndex];
    centerView = self.contentViews[self.centerViewIndex];
    rightView = self.contentViews[self.rightViewIndex];
    
    [self addSubview:self.contentViews[self.leftViewIndex]];
    [self addSubview:self.contentViews[self.centerViewIndex]];
    [self addSubview:self.contentViews[self.rightViewIndex]];
    
    // Set the views' frame.
    CGSize size = self.bounds.size;
    leftView.frame = CGRectMake(0, 0, size.width, size.height);
    centerView.frame = CGRectOffset(leftView.frame, size.width, 0);
    rightView.frame = CGRectOffset(centerView.frame, size.width, 0);
}

@end

//
//  HLZInfiniteScrollView.m
//  HLZInfiniteScrollView
//
//  Created by Hu Lizhen on 6/14/16.
//  Copyright © 2016 hulizhen. All rights reserved.
//

#import "HLZInfiniteScrollView.h"

@interface HLZInfiniteScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger leftViewIndex;
@property (nonatomic, assign) NSInteger centerViewIndex;
@property (nonatomic, assign) NSInteger rightViewIndex;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) id<HLZInfiniteScrollViewDelegate> userDelegate;

@end

@implementation HLZInfiniteScrollView

@dynamic delegate;

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
    
    if (!self.isInfiniteScrollEnabled) {
        return;
    }
    
    if (self.contentOffset.x < self.bounds.size.width / 4) {
        [self reassignViews:YES];
    } else if (self.contentOffset.x > self.bounds.size.width * 7/4) {
        [self reassignViews:NO];
    }
}

#pragma mark - Accessors

- (void)setContentViews:(NSArray *)contentViews {
    _contentViews = contentViews;
}

- (void)setAutoScrollTimerInterval:(NSTimeInterval)autoScrollTimerInterval {
    _autoScrollTimerInterval = autoScrollTimerInterval;
    
    [self resetTimer];
}

- (void)setDelegate:(id<HLZInfiniteScrollViewDelegate>)delegate {
    _userDelegate = delegate;
}

- (id<HLZInfiniteScrollViewDelegate>)delegate {
    return _userDelegate;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self resetTimer];
    
    if ([self.userDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.userDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark - Message Forwarding

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.userDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.userDelegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [(NSObject *)self.userDelegate methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [[self class] instancesRespondToSelector:(aSelector)] || [self.userDelegate respondsToSelector:aSelector];
}

#pragma mark - Helpers

- (void)setUp {
    self.leftViewIndex = 0;
    self.centerViewIndex = 1;
    self.rightViewIndex = 2;
    
    self.autoScrollTimerInterval = 5.0;
    self.autoScrollAnimationDuration = 0.5;
    self.autoScrollLeftShift = YES;
    
    self.pagingEnabled = YES;
    
    super.delegate = self;
    
    [self resetTimer];
}

- (void)resetTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimerInterval target:self selector:@selector(shiftViews) userInfo:nil repeats:YES];
}

- (NSInteger)increaseViewIndex:(NSInteger)index {
    ++index;
    return (index >= self.contentViews.count) ? index %= self.contentViews.count : index;
}

- (NSInteger)decreaseViewIndex:(NSInteger)index {
    --index;
    return (index < 0) ? index += self.contentViews.count : index;
}

- (void)reassignViews:(BOOL)leftShift {
    UIView *leftView = self.contentViews[self.leftViewIndex];
    UIView *centerView = self.contentViews[self.centerViewIndex];
    UIView *rightView = self.contentViews[self.rightViewIndex];
    
    [leftView removeFromSuperview];
    [centerView removeFromSuperview];
    [rightView removeFromSuperview];
    
    // Update the contentOffset of scroll view and indexes of views.
    if (leftShift) {
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
    
    CGSize size = self.bounds.size;
    leftView.frame = CGRectMake(0, 0, size.width, size.height);
    centerView.frame = CGRectOffset(leftView.frame, size.width, 0);
    rightView.frame = CGRectOffset(centerView.frame, size.width, 0);
}

- (void)shiftViews {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake(self.bounds.size.width * 2, self.contentOffset.y);
//        self.contentOffset = CGPointMake(0, self.contentOffset.y);
    }];
}

@end

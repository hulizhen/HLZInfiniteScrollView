//
//  ViewController.m
//  HLZInfiniteScrollView
//
//  Created by Hu Lizhen on 6/9/16.
//  Copyright © 2016 hulizhen. All rights reserved.
//

#import "ViewController.h"
#import "HLZInfiniteScrollView.h"

@interface ViewController () <HLZInfiniteScrollViewDelegate>

@property (nonatomic, weak) IBOutlet HLZInfiniteScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; ++i) {
        // Get Image
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Image%d", i]];
        
        // Add Number label to imageView.
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d", i];
        [label setFont:[UIFont fontWithName:@"Noteworthy-Light" size:80]];
        
        [imageView addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[label.centerXAnchor constraintEqualToAnchor:imageView.centerXAnchor],
                                                  [label.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor]]];
        
        [imageViews addObject:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 220);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.infiniteScrollEnabled = YES;
    self.scrollView.contentViews = imageViews;
    self.scrollView.autoScrollEnabled = YES;
    self.scrollView.autoScrollTimerInterval = 1.0;
    self.scrollView.autoScrollLeftShift = YES;
}

@end

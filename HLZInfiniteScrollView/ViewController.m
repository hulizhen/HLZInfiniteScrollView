//
//  ViewController.m
//  HLZInfiniteScrollView
//
//  Created by Hu Lizhen on 6/9/16.
//  Copyright © 2016 hulizhen. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+HLZInfinite.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

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
    
    self.scrollView.contentViews = imageViews;
    self.scrollView.infinite = YES;
}

@end

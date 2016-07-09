
HLZInfiniteScrollView
---------------------
This library provides a scroll view, which can be scrolled infinitely and automatically, by making use of UICollectionView.

![hlzinfinitescrollview](https://cloud.githubusercontent.com/assets/2831422/16691969/7bef5aec-4561-11e6-9163-2dae603c0635.gif)

How To Use
----------
Copy the interface and implementation files into your project and include the `HLZInfiniteScrollView.h`.

```objective-c
#import "HLZInfiniteScrollView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet HLZInfiniteScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < N; ++i) {
        UIView *view = [[UIView alloc] init];
        
        ...
                
        [views addObject:view];
    }

    self.scrollView.pageControlEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.autoScrollEnabled = YES;
    self.scrollView.autoScrollTimerInterval = 5.0;
    self.scrollView.autoScrollDirection = AutoScrollDirectionRight;
    self.scrollView.contentViews = imageViews;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.scrollView.currentPage = 0;
}

@end
```

Check out the demo project to see the details.

HLZInfiniteScrollView
---------------------
This library provides a subclass of UIScrollView with support for being scrolled infinitely and automatically.
![hlzinfinitescrollview](https://cloud.githubusercontent.com/assets/2831422/16170851/b47d475e-3592-11e6-8bbf-5a49ccd06e62.gif)

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

    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 220);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.infiniteScrollEnabled = YES;
    self.scrollView.contentViews = imageViews;
    self.scrollView.autoScrollEnabled = YES;
    self.scrollView.autoScrollTimerInterval = 0.3;
    self.scrollView.autoScrollLeftShift = YES;
}

@end
```

Check out the demo project to see the details.

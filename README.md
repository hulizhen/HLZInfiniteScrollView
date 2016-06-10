HLZInfiniteScrollView
---------------------
This library provides a category for UIScrollView with support for being scrolled infinitely.
![hlzinfinitescrollview](https://cloud.githubusercontent.com/assets/2831422/15956191/63a934e8-2f19-11e6-92c2-b2e615d7957c.gif)

How To Use
----------
Copy the interface and implementation files of the category into your project and include the `UIScrollView+HLZInfinite.h`.

```objective-c
#import "UIScrollView+HLZInfinite.h"

...

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < N; ++i) {
        UIView *view = [[UIView alloc] init];
        
        ...
                
        [views addObject:view];
    }

    self.scrollView.infinite = YES;     
    self.scrollView.infiniteViews = views;
}
```

Check out the demo project to see the details.

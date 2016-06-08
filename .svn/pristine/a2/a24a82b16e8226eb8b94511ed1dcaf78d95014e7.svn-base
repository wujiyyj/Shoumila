//
//  RYGSegmentedViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSegmentedViewController.h"

@interface RYGSegmentedViewController ()

@end

@implementation RYGSegmentedViewController

@synthesize selectedViewController;
@synthesize selectedViewControllerIndex;
@synthesize segmentedControl;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!segmentedControl) {
        segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 140.0f, 26.0f)];
        segmentedControl.tintColor = [UIColor whiteColor];
//        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.navigationItem.titleView = segmentedControl;
    } else {
        [segmentedControl removeAllSegments];
    }
    [segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
}

- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles
{
    if ([segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:titles[i]];
    }
    [segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if ([segmentedControl numberOfSegments] > 0) {
        return;
    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:[viewControllers[i] title]];
    }
    [segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController title:viewController.title];
}
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
{
    [segmentedControl insertSegmentWithTitle:title atIndex:segmentedControl.numberOfSegments animated:NO];
    [self addChildViewController:viewController];
//    [segmentedControl sizeToFit];
}

- (void)segmentedControlSelected:(id)sender
{
    self.selectedViewControllerIndex = segmentedControl.selectedSegmentIndex;
}

- (void)setSelectedViewControllerIndex:(NSInteger)index
{
    if (!selectedViewController) {
        selectedViewController = self.childViewControllers[index];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            CGFloat deltaTop = 20.0f;
            if (self.navigationController && !self.navigationController.navigationBar.translucent) {
                deltaTop = self.navigationController.navigationBar.frame.size.height;
            }
            CGRect frame = self.view.frame;
            [selectedViewController view].frame = CGRectMake(frame.origin.x, frame.origin.y - deltaTop, frame.size.width, frame.size.height);
            //            [[_selectedViewController view] sizeToFit];
        } else {
            [selectedViewController view].frame = self.view.frame;
        }
        [self.view addSubview:[selectedViewController view]];
        [selectedViewController didMoveToParentViewController:self];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            [self.childViewControllers[index] view].frame = self.view.frame;
        }
        [self transitionFromViewController:selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            selectedViewController = self.childViewControllers[index];
            selectedViewControllerIndex = index;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

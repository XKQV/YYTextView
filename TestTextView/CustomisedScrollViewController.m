//
//  CustomisedScrollViewController.m
//  TestTextView
//
//  Created by Zhiwei on 2019/7/31.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import "CustomisedScrollViewController.h"

@interface CustomisedScrollViewController ()

@end

@implementation CustomisedScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *scrollView = [[UIView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    CAGradientLayer *cagLayer = [CAGradientLayer layer];
    cagLayer.frame = scrollView.frame;
    cagLayer.startPoint = CGPointMake(0, 0);
    cagLayer.endPoint = CGPointMake(0, 1);
    cagLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor, (id)[UIColor yellowColor].CGColor];
    [scrollView.layer addSublayer:cagLayer];
    [self.view addSubview:scrollView];
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

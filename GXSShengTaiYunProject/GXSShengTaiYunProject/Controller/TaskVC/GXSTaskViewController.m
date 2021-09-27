//
//  GXSTaskViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

#import "GXSTaskViewController.h"

@interface GXSTaskViewController ()

@end

@implementation GXSTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Super
- (BOOL)isRootViewController {
    return YES;
}
- (NSString *)tabBarItemTitle {
    return @"任务";
}

- (UIImage *)tabBarItemImage {
    return @"tab_message".image;
}

- (UIImage *)tabBarItemSelectedImage {
    return @"tab_message_selected".image;
}

- (MNContentEdges)contentEdges {
    return MNContentEdgeBottom;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGRect)emptyViewFrame {
    return UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(self.view.top_mn, 0.f, 0.f, 0.f));
}

@end

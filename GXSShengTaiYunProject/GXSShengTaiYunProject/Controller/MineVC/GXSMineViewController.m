//
//  GXSMineViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

#import "GXSMineViewController.h"

@interface GXSMineViewController ()

@end

@implementation GXSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Super
- (BOOL)isRootViewController {
    return YES;
}

- (NSString *)tabBarItemTitle {
    return @"我的";
}

- (UIImage *)tabBarItemImage {
    return @"tab_mine".image;
}

- (UIImage *)tabBarItemSelectedImage {
    return @"tab_mine_selected".image;
}


@end

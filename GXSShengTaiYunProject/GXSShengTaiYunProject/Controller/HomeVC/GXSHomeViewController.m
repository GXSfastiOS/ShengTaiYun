//
//  GXSHomeViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

#import "GXSHomeViewController.h"

@interface GXSHomeViewController ()

@end

@implementation GXSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


#pragma mark - Super
- (BOOL)isRootViewController {
    return YES;
}

- (NSString *)tabBarItemTitle {
    return @"首页";
}

//- (UIImage *)tabBarItemImage {
//    return @"tab_dynamic".image;
//}
//
//- (UIImage *)tabBarItemSelectedImage {
//    return @"tab_dynamic_selected".image;
//}

- (MNContentEdges)contentEdges {
    return MNContentEdgeNone;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGRect)emptyViewFrame {
    return UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
}


@end

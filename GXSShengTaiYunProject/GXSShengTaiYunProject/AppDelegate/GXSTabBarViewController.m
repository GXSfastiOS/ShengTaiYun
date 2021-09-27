//
//  GXSTabBarViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/27.
//

#import "GXSTabBarViewController.h"

@interface GXSTabBarViewController ()

@end

static GXSTabBarViewController *_tabBarController;

@implementation GXSTabBarViewController

+ (GXSTabBarViewController *)tabBarController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tabBarController = [[GXSTabBarViewController alloc] init];
    });
    return _tabBarController;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tabBarController = [super allocWithZone:zone];
    });
    return _tabBarController;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tabBarController = [super init];
    });
    return _tabBarController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    MNTabBar *tabBar = self.tabView;
    tabBar.itemSize = CGSizeMake(70.f, 46.f);
    [MNTabBarItem  appearance].titleFont=[UIFont systemFontOfSize:18.f];
    [MNTabBarItem  appearance].otherViewStyte=YES;
    [[MNTabBarItem appearance] setImage:nil];
    [[MNTabBarItem appearance] setTitleColor:UIColor.grayColor];
    [[MNTabBarItem appearance] setSelectedTitleColor:GXS_THEME_COLOR];
    [[MNTabBarItem appearance] setTitleOffset:UIOffsetMake(0.f, -20.f)];
}



@end

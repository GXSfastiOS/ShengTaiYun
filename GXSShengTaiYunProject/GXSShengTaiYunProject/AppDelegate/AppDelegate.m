//
//  AppDelegate.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "GXSHomeViewController.h"
#import "GXSTaskViewController.h"
#import "GXSMineViewController.h"
#import "MNTabBarController.h"
#import "GXSTabBarViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong) GXSTabBarViewController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    //加载启动图
//    UIStoryboard *launchScreenStory = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
//    UIViewController *startControll = [launchScreenStory instantiateViewControllerWithIdentifier:@"GXSLaunchView"];
//    self.window.rootViewController = startControll;
    // 要使用百度地图，请先启动BaiduMapManager
//    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
//    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
//    BOOL ret = [mapManager start:@"在此处输入您的授权AK"  generalDelegate:nil];
//    if (!ret) {
//        NSLog(@"启动引擎失败");
//    }
    //加载主页面
    [self initViewController];
    return YES;
}


- (void)initViewController{
    self.window.rootViewController = self.tabBarController;
}

#pragma mark -lazy

- (GXSTabBarViewController *)tabBarController{
    if (!_tabBarController) {
        _tabBarController=GXSTabBarViewController.tabBarController;
        _tabBarController.controllers=@[@"GXSHomeViewController",@"GXSTaskViewController",@"GXSMineViewController"];
    }
    return  _tabBarController;
}

@end

//
//  AppDelegate.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

#import "AppDelegate.h"
#import "GXSHomeViewController.h"
#import "GXSTaskViewController.h"
#import "GXSMineViewController.h"
#import "MNTabBarController.h"

@interface AppDelegate ()
@property (nonatomic,strong) MNTabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    //加载启动图
//    UIStoryboard *launchScreenStory = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
//    UIViewController *startControll = [launchScreenStory instantiateViewControllerWithIdentifier:@"GXSLaunchView"];
//    self.window.rootViewController = startControll;
    
    //加载主页面
    [self initViewController];
    return YES;
}


- (void)initViewController{
    self.window.rootViewController = self.tabBarController;
}

#pragma mark -lazy

- (MNTabBarController *)tabBarController{
    if (!_tabBarController) {
        _tabBarController=[[MNTabBarController alloc]init];
        _tabBarController.controllers=@[@"GXSHomeViewController",@"GXSTaskViewController",@"GXSMineViewController"];
    }
    return  _tabBarController;
}

@end

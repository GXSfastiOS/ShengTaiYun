//
//  GXSShaixuanAlertView.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/29.
//

#import "GXSShaixuanAlertView.h"


@interface GXSShaixuanAlertView ()
@property (nonatomic,strong)UIView *showView;
@end

@implementation GXSShaixuanAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.frame              = [UIScreen mainScreen].bounds;
        self.backgroundColor    = MN_R_G_B_A(0.0, 0.0, 0.0, 0.4);
        [self setUpView];
    }
    return  self;
}

-  (void)setUpView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(80.f, 0.f, self.width_mn-80.f, self.height_mn)];
    view.backgroundColor=UIColor.whiteColor;
    [self addSubview:view];
}

/// 移除弹窗手势
-(void)removeSelfFromSuperview {
    [self removeFromSuperview];
}

@end

//
//  GXSShaixuanAlertView.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/29.
//

#import "GXSShaixuanAlertView.h"


@interface GXSShaixuanAlertView ()<UITextFieldDelegate>
@property (nonatomic,strong)UIView *showView;
@property (nonatomic,strong)UITextField *qiyeName;
@property (nonatomic,strong)UIView *otherKey;
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
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(self.width_mn, 0.f, self.width_mn-40.f, self.height_mn)];
    view.backgroundColor=UIColor.whiteColor;
    [self addSubview:view];
    self.showView=view;
    
    UILabel *oneJi=[UILabel labelWithFrame:CGRectMake(10.f, 100.f, 130.f, 20.f) text:@"一级大网格" textColor:UIColor.blackColor font:UIFontSystem(20.f)];
    [view addSubview:oneJi];
    
    UILabel *oneSearchLab=[UILabel labelWithFrame:CGRectMake(10.f, oneJi.bottom_mn+10.f, view.width_mn-30.f, 40.f) text:@"----请选择网格----" textColor:UIColor.grayColor font:UIFontSystem(15)];
    oneSearchLab.backgroundColor=[UIColor colorWithHex:@"#F6F6F6"];
    oneSearchLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:oneSearchLab];
    oneSearchLab.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectClick)];
    [oneSearchLab addGestureRecognizer:tap];
    
    UILabel *twoJi=[UILabel labelWithFrame:CGRectMake(10.f, oneSearchLab.bottom_mn+20.f, 130.f, 20.f) text:@"二级大网格" textColor:UIColor.blackColor font:UIFontSystem(20.f)];
    [view addSubview:twoJi];
    
    UILabel *twoSearchLab=[UILabel labelWithFrame:CGRectMake(10.f, twoJi.bottom_mn+10.f, view.width_mn-30.f, 40.f) text:@"----请选择网格----" textColor:UIColor.grayColor font:UIFontSystem(15)];
    twoSearchLab.backgroundColor=[UIColor colorWithHex:@"#F6F6F6"];
    twoSearchLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:twoSearchLab];
    
    UILabel *wanggeyuan=[UILabel labelWithFrame:CGRectMake(10.f, twoSearchLab.bottom_mn+20.f, 100.f, 20.f) text:@"网格员" textColor:UIColor.blackColor font:UIFontSystem(20.f)];
    [view addSubview:wanggeyuan];
    
    UILabel *wanggeyuanSearchLab=[UILabel labelWithFrame:CGRectMake(10.f, wanggeyuan.bottom_mn+10.f, view.width_mn-30.f, 40.f) text:@"----请选择网格员姓名----" textColor:UIColor.grayColor font:UIFontSystem(15)];
    wanggeyuanSearchLab.backgroundColor=[UIColor colorWithHex:@"#F6F6F6"];
    wanggeyuanSearchLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:wanggeyuanSearchLab];
    
    UILabel *fenguan=[UILabel labelWithFrame:CGRectMake(10.f, wanggeyuanSearchLab.bottom_mn+20.f, 100.f, 20.f) text:@"分管领导" textColor:UIColor.blackColor font:UIFontSystem(20.f)];
    [view addSubview:fenguan];
    
    UILabel *fenguanSearchLab=[UILabel labelWithFrame:CGRectMake(10.f, fenguan.bottom_mn+10.f, view.width_mn-30.f, 40.f) text:@"----请选择分管领导----" textColor:UIColor.grayColor font:UIFontSystem(15)];
    fenguanSearchLab.backgroundColor=[UIColor colorWithHex:@"#F6F6F6"];
    fenguanSearchLab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:fenguanSearchLab];
    
    UILabel *qiyeName=[UILabel labelWithFrame:CGRectMake(10.f, fenguanSearchLab.bottom_mn+20.f, 100.f, 20.f) text:@"企业名称" textColor:UIColor.blackColor font:UIFontSystem(20.f)];
    [view addSubview:qiyeName];
    
    UITextField *qiyeText=[UITextField textFieldWithFrame:CGRectMake(10.f, qiyeName.bottom_mn+10.f, view.width_mn-30.f, 30.f) font:UIFontSystem(17.f) placeholder:@"请输入企业名称" delegate:self];
    [view addSubview:qiyeText];
    self.qiyeName=qiyeText;
    
    UILabel *otherKey=[UILabel labelWithFrame:CGRectMake(10.f, qiyeText.bottom_mn+20.f, 130.f, 20.f) text:@"其他关键词" textColor:UIColor.blackColor font:UIFontSystem(20.f)];
    [view addSubview:otherKey];
    
    UITextField *otherKeyText=[UITextField textFieldWithFrame:CGRectMake(10.f, otherKey.bottom_mn+10.f, view.width_mn-30.f, 30.f) font:UIFontSystem(17.f) placeholder:@"请输入关键词搜索" delegate:self];
    [view addSubview:otherKeyText];
    self.otherKey=otherKeyText;
    
    UIButton *clearBtn=[UIButton buttonWithFrame:CGRectMake(10.f, view.height_mn-70.f, (view.width_mn-30.f)/2, 44.f) image:nil title:@"重置" titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(18.f)];
    [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius=22.f;
    clearBtn.layer.borderWidth=1.f;
    clearBtn.layer.borderColor=GXS_THEME_COLOR.CGColor;
    [view addSubview:clearBtn];
    
    UIButton *sumbitBtn=[UIButton buttonWithFrame:CGRectMake(clearBtn.right_mn+10.f, clearBtn.top_mn, (view.width_mn-30.f)/2, 44.f) image:nil title:@"确定" titleColor:UIColor.whiteColor titleFont:UIFontSystem(18.f)];
    [sumbitBtn addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.layer.cornerRadius=22.f;
    sumbitBtn.backgroundColor=GXS_THEME_COLOR;
    [view addSubview:sumbitBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=self.showView.frame;
        rect.origin.x=40.f;
        self.showView.frame=rect;
    }];
}


- (void)clearClick{
    
}

- (void)sumbitClick{
    [self removeSelfFromSuperview];
}

- (void)selectClick{
//    [MNActionSheet actionSheetWithTitle:@"选择网格" cancelButtonTitle:@"取消" handler:^(MNActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
//
//    } otherButtonTitles:@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格", nil];
    MNActionSheet *sheet=[[MNActionSheet alloc]initWithTitle:@"选择网格" cancelButtonTitle:@"取消" otherButtonTitles:@[@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格",@"选择网格"] handler:^(MNActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        NSLog(@"%@",actionSheet.title);
    }];
    [sheet show];
}

/// 移除弹窗手势
-(void)removeSelfFromSuperview {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=self.showView.frame;
        rect.origin.x=self.width_mn;
        self.showView.frame=rect;
        [self removeFromSuperview];
    }];
 
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==self.qiyeName) {
        
    }else{
        
    }
}


@end

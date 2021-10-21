//
//  ForGetPassworldView.m
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/10/7.
//

#import "ForGetPassworldView.h"

@interface  ForGetPassworldView()
@property (nonatomic, copy) void(^ensureHandler)(NSString *_Nullable,NSString*, NSString *,NSString *);
@property (nonatomic, strong)UITextField *zhangHaoText;
@property (nonatomic, strong)UITextField *oldPassworldText;
@property (nonatomic, strong)UITextField *passworldText;
@property (nonatomic, strong)UITextField *passworldTextTwo;
@end

@implementation ForGetPassworldView

- (instancetype)initWithFrame:(CGRect)frame returnValue:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))returnInfo{
    if (self=[super initWithFrame:frame]) {
        self.ensureHandler=returnInfo;
        [self initView];
    }
    return  self;
}


- (void)initView{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    UIButton *returnBtn=[UIButton buttonWithFrame:CGRectMake(12.f, 12.f, 70.f, 13.f) image:[UIImage imageNamed:@"icon_arrow_left_a"] title:@"返回登录" titleColor:[UIColor colorWithHex:@"#AAAAAA"] titleFont:UIFontSystem(12.f)];
//    returnBtn.titleEdgeInsets=UIEdgeInsetsMake(0.f, 10.f, 0.f, -10.f);
//    returnBtn.imageEdgeInsets=UIEdgeInsetsMake(0.f, -10.f, 0.f, 10.f);
    [returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:returnBtn];
    
    UILabel *changeLab=[UILabel labelWithFrame:CGRectZero text:@"更改密码" textColor:UIColor.blackColor font:UIFontSystem(15.f)];
    changeLab.size_mn=CGSizeMake(70.f,15.f);
    changeLab.top_mn=33.f;
    changeLab.centerX_mn=self.centerX_mn;
    [self addSubview:changeLab];
    //账号
    UIView *zhangHaoView = [[UIView alloc] init];
    zhangHaoView.frame = CGRectMake(18.5f,72.5f,self.width_mn-37.f,45);
    zhangHaoView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    zhangHaoView.layer.cornerRadius = 22.5;
    [self addSubview:zhangHaoView];
    
    UILabel *zhangHaoLab=[UILabel labelWithFrame:CGRectMake(19.f, 16.f, 60.f, 15.f) text:@"设置账号" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [zhangHaoView addSubview:zhangHaoLab];
    
    UITextField *zhangHaoText=[UITextField textFieldWithFrame:CGRectMake(zhangHaoLab.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请输入您的公司全称/身份账号名" delegate:nil];
    zhangHaoText.borderStyle=UITextBorderStyleNone;
    zhangHaoText.centerY_mn=zhangHaoLab.centerY_mn;
    [zhangHaoView addSubview:zhangHaoText];
    self.zhangHaoText=zhangHaoText;
    
    //原来密码
    UIView *oldPassworldView = [[UIView alloc] init];
    oldPassworldView.frame = CGRectMake(18.5f,zhangHaoView.bottom_mn+20.f,self.width_mn-37.f,45);
    oldPassworldView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    oldPassworldView.layer.cornerRadius = 22.5;
    [self addSubview:oldPassworldView];
    
    UILabel *oldPassworldLab=[UILabel labelWithFrame:CGRectMake(19.f, 16.f,60.f, 15.f) text:@"当前密码" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [oldPassworldView addSubview:oldPassworldLab];
    
    UITextField *oldPassworldText=[UITextField textFieldWithFrame:CGRectMake(zhangHaoLab.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请输入当前登录密码" delegate:nil];
    oldPassworldText.borderStyle=UITextBorderStyleNone;
    oldPassworldText.centerY_mn=oldPassworldLab.centerY_mn;
    [oldPassworldView addSubview:oldPassworldText];
    self.oldPassworldText=oldPassworldText;
    
    UILabel *remorkLab=[UILabel labelWithFrame:CGRectZero text:@"注：若忘记当前密码可联系平台021-54887623" textColor:[UIColor colorWithHex:@"#F2BC01"] font:UIFontSystem(11.f)];
    remorkLab.size_mn=CGSizeMake(240.f,15.f);
    remorkLab.top_mn=oldPassworldView.bottom_mn+7.5f;
    remorkLab.left_mn=self.left_mn+22.f;
    [self addSubview:remorkLab];
    
    //密码
    UIView *passworldView = [[UIView alloc] init];
    passworldView.frame = CGRectMake(18.5f,oldPassworldView.bottom_mn+34.5f,self.width_mn-37.f,45);
    passworldView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    passworldView.layer.cornerRadius = 22.5;
    [self addSubview:passworldView];
    
    UILabel *passworldLab=[UILabel labelWithFrame:CGRectMake(19.f, 16.f,60.f, 15.f) text:@"重置密码" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [passworldView addSubview:passworldLab];
    
    UITextField *passworldText=[UITextField textFieldWithFrame:CGRectMake(zhangHaoLab.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请输入新的登录密码" delegate:nil];
    passworldText.borderStyle=UITextBorderStyleNone;
    passworldText.centerY_mn=passworldLab.centerY_mn;
    [passworldView addSubview:passworldText];
    self.passworldText=passworldText;
    
    //确认密码
    UIView *passworldViewTwo = [[UIView alloc] init];
    passworldViewTwo.frame = CGRectMake(18.5f,passworldView.bottom_mn+20.f,self.width_mn-37.f,45);
    passworldViewTwo.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    passworldViewTwo.layer.cornerRadius = 22.5;
    [self addSubview:passworldViewTwo];
    
    UILabel *passworldLabtwo=[UILabel labelWithFrame:CGRectMake(19.f, 16.f, 60.f, 15.f) text:@"确认密码" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [passworldViewTwo addSubview:passworldLabtwo];
    
    UITextField *passworldTextTwo=[UITextField textFieldWithFrame:CGRectMake(passworldLabtwo.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请再次输入新的登录密码" delegate:nil];
    passworldTextTwo.borderStyle=UITextBorderStyleNone;
    passworldTextTwo.centerY_mn=passworldLab.centerY_mn;
    [passworldViewTwo addSubview:passworldTextTwo];
    self.passworldTextTwo=passworldTextTwo;
    
    //注册
    UIButton *changeBtn=[UIButton buttonWithFrame:CGRectZero image:nil title:@"确认更换" titleColor:UIColor.whiteColor titleFont:UIFontSystem(12.f)];
    changeBtn.backgroundColor=GXS_THEME_COLOR;
    changeBtn.height_mn=40.f;
    changeBtn.top_mn=passworldViewTwo.bottom_mn+25.5f;
    changeBtn.left_mn=self.left_mn;
    changeBtn.width_mn=self.width_mn-37.f;
    changeBtn.layer.cornerRadius=20.f;
    [changeBtn addTarget:self action:@selector(changeInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeBtn];
}

- (void)back{
    [self removeFromSuperview];
}


- (void)changeInfo{
    if (self.zhangHaoText.text.length<=0 || self.oldPassworldText.text.length<=0 ||self.passworldTextTwo.text.length<=0) {
        [self showInfoDialog:@"输入不能为空"];
        return;
    }
    if (![self.passworldText.text isEqualToString:self.passworldTextTwo.text]) {
        [self showInfoDialog:@"两次密码输入不一致"];
        return;
    }
    if (self.ensureHandler) {
        self.ensureHandler(self.zhangHaoText.text,self.oldPassworldText.text, self.passworldText.text, self.passworldTextTwo.text);
    }
}

@end

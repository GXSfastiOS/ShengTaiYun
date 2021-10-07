//
//  RegisterView.m
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/10/7.
//

#import "RegisterView.h"

@interface  RegisterView ()<UITextViewDelegate>
@property (nonatomic, copy) void(^ensureHandler)(NSString *_Nullable, NSString *,NSString *);
@property (nonatomic, strong)UITextField *zhangHaoText;
@property (nonatomic, strong)UITextField *passworldText;
@property (nonatomic, strong)UITextField *passworldTextTwo;
@end

@implementation RegisterView

-(instancetype)initWithFrame:(CGRect)frame  returnValue:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))returnInfo{
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
    
    //账号
    UIView *zhangHaoView = [[UIView alloc] init];
    zhangHaoView.frame = CGRectMake(18.5f,72.5f,self.width_mn-37.f,45);
    zhangHaoView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    zhangHaoView.layer.cornerRadius = 22.5;
    [self addSubview:zhangHaoView];
    
    UILabel *zhangHaoLab=[UILabel labelWithFrame:CGRectMake(19.f, 16.f, 60.f, 15.f) text:@"设置账号" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [zhangHaoView addSubview:zhangHaoLab];
    
    UITextField *zhangHaoText=[UITextField textFieldWithFrame:CGRectMake(zhangHaoLab.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请输入您的公司全称/身份账号名" delegate:self];
    zhangHaoText.borderStyle=UITextBorderStyleNone;
    zhangHaoText.centerY_mn=zhangHaoLab.centerY_mn;
    [zhangHaoView addSubview:zhangHaoText];
    self.zhangHaoText=zhangHaoText;
    
    //密码
    UIView *passworldView = [[UIView alloc] init];
    passworldView.frame = CGRectMake(18.5f,zhangHaoView.bottom_mn+20.f,self.width_mn-37.f,45);
    passworldView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    passworldView.layer.cornerRadius = 22.5;
    [self addSubview:passworldView];
    
    UILabel *passworldLab=[UILabel labelWithFrame:CGRectMake(19.f, 16.f,60.f, 15.f) text:@"设置密码" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [passworldView addSubview:passworldLab];
    
    UITextField *passworldText=[UITextField textFieldWithFrame:CGRectMake(zhangHaoLab.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请输入登录密码" delegate:self];
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
    
    UITextField *passworldTextTwo=[UITextField textFieldWithFrame:CGRectMake(passworldLabtwo.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请再次输入登录密码" delegate:self];
    passworldTextTwo.borderStyle=UITextBorderStyleNone;
    passworldTextTwo.centerY_mn=passworldLab.centerY_mn;
    [passworldViewTwo addSubview:passworldTextTwo];
    self.passworldTextTwo=passworldTextTwo;
    
    //注册
    UIButton *registerBtn=[UIButton buttonWithFrame:CGRectZero image:nil title:@"注册" titleColor:UIColor.whiteColor titleFont:UIFontSystem(12.f)];
    registerBtn.backgroundColor=GXS_THEME_COLOR;
    registerBtn.height_mn=40.f;
    registerBtn.top_mn=passworldViewTwo.bottom_mn+36.f;
    registerBtn.left_mn=self.left_mn;
    registerBtn.width_mn=self.width_mn-37.f;
    registerBtn.layer.cornerRadius=20.f;
    [registerBtn addTarget:self action:@selector(registerInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];

    NSString *string = @"注册代表你同意 平台用户协议 与 平台隐私政策 ";
    NSMutableAttributedString *attributedString = string.attributedString.mutableCopy;
    [attributedString addAttribute:NSFontAttributeName value:UIFontSystem(11.f) range:attributedString.rangeOfAll];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#8C9AA8"] range:attributedString.rangeOfAll];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle.copy range:attributedString.rangeOfAll];
    [attributedString addAttribute:NSLinkAttributeName value:TA_USER_LINK range:[string rangeOfString:@"平台用户协议"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:55/255.0 green:150/255.0 blue:144/255.0 alpha:1.0] range:[string rangeOfString:@"平台用户协议"]];
    [attributedString addAttribute:NSFontAttributeName value:UIFontSystem(11.f) range:[string rangeOfString:@"平台用户协议"]];
    [attributedString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[string rangeOfString:@"平台用户协议"]];
    [attributedString addAttribute:NSLinkAttributeName value:TA_PRIVACY_LINK range:[string rangeOfString:@"平台隐私政策"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:55/255.0 green:150/255.0 blue:144/255.0 alpha:1.0] range:[string rangeOfString:@"平台隐私政策"]];
    [attributedString addAttribute:NSFontAttributeName value:UIFontSystem(11.f) range:[string rangeOfString:@"平台隐私政策"]];
    [attributedString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[string rangeOfString:@"平台隐私政策"]];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width_mn/4.f*3.f, 0.f)];
    textView.height_mn =15.f;
    textView.top_mn = registerBtn.bottom_mn+28.f;
    textView.centerX_mn = self.width_mn/2.f;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.delegate =self;
    textView.scrollEnabled = YES;
    textView.attributedText = attributedString.copy;
    textView.performActions = MNTextViewActionNone;
    textView.backgroundColor = UIColor.clearColor;
    textView.textColor = UIColor.darkTextColor;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.tintColor = [UIColor clearColor];
    textView.contentInset = UIEdgeInsetsZero;
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.textContainer.lineFragmentPadding = 0.f;
    textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#379690"]};
    [textView adjustContentInset];
    [self addSubview:textView];
    
}

- (void)back{
    [self removeFromSuperview];
}

- (void)registerInfo{
    if (self.ensureHandler) {
        self.ensureHandler(self.zhangHaoText.text, self.passworldText.text, self.passworldTextTwo.text);
    }
}

#pragma mark - UITextViewDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [self didInteractWithURL:URL];
    return NO;
}
#else
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    [self didInteractWithURL:URL];
    return NO;
}
#endif
#pragma clang diagnostic pop

- (void)didInteractWithURL:(NSURL *)URL {
    MNExtendViewController *view;
    //获取父视图控制器
    for (UIView* next = [self superview]; next; next = next.superview) {
          UIResponder *nextResponder = [next nextResponder];
          if ([nextResponder isKindOfClass:[MNExtendViewController class]]) {
            view=(MNExtendViewController *)nextResponder;
          }
      }
    MNWebViewController *vc = [[MNWebViewController alloc] initWithURL:URL];
    [view.navigationController pushViewController:vc animated:YES];
}

@end

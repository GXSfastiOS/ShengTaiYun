//
//  GXSLoginViewController.m
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/10/6.
//

#import "GXSLoginViewController.h"
#import "RegisterView.h"
#import "ForGetPassworldView.h"

@interface GXSLoginViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
//头视图
@property (nonatomic,strong)MNAdsorbView *headerView;
//登录视图
@property (nonatomic,strong)UIView *loginView;
@end


#pragma make -life cycle

@implementation GXSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)createView{
    [super createView];
    self.navigationBar.hidden=YES;
    UIScrollView *scrollView = [UIScrollView scrollViewWithFrame:self.contentView.bounds delegate:nil];
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor=[UIColor colorWithHex:@"#BDBFC4"];
    
    UIImage *headerImage = [UIImage imageNamed:@"bg"];
//    CGSize headerSize = CGSizeMultiplyToWidth(headerImage.size, scrollView.width_mn);
    MNAdsorbView *headerView = [[MNAdsorbView alloc] initWithFrame:CGRectMake(0.f, 0.f, scrollView.width_mn, 285.f)];
    headerView.imageView.image = headerImage;
    self.headerView=headerView;
    [scrollView addSubview:headerView];
    
    //icon
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(0.f, 85.5f, 88.5f,80.f)];
    icon.image=[UIImage imageNamed:@"icon"];
    icon.centerX_mn=headerView.centerX_mn;
    [headerView addSubview:icon];
    
    //文字
    UILabel *stLab=[[UILabel alloc]initWithFrame:CGRectMake(0.f, icon.bottom_mn+19.5f, 140.f, 18.f)];
    stLab.text=@"生态环境云平台";
    stLab.font=[UIFont systemFontOfSize:19];
    stLab.textColor=[UIColor whiteColor];
    stLab.centerX_mn=headerView.centerX_mn;
    [scrollView addSubview:stLab];
    
    UIView *loginView = [[UIView alloc] init];
    loginView.frame = CGRectMake(17.5,headerView.bottom_mn-50.f,self.view.width_mn-35.f,380);
    loginView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    loginView.layer.cornerRadius = 11.5;
    [scrollView addSubview:loginView];
    self.loginView=loginView;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0.f,0.f,120,20);
    label.top_mn=41.f;
    label.right_mn=loginView.right_mn-39.f;
    label.numberOfLines = 0;
    [self.loginView addSubview:label];
    
    NSMutableAttributedString *zhuceString = [[NSMutableAttributedString alloc] initWithString:@"还没有账号，去注册" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:35/255.0 green:38/255.0 blue:44/255.0 alpha:1.0]}];
    [zhuceString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12]} range:NSMakeRange(0, 6)];
    [zhuceString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:55/255.0 green:150/255.0 blue:144/255.0 alpha:1.0]} range:NSMakeRange(6, 3)];
    [zhuceString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}
                     range:NSMakeRange(6, 3)];
    label.attributedText = zhuceString;
    label.userInteractionEnabled=YES;
    UITapGestureRecognizer *ges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerInfo)];
    [label addGestureRecognizer:ges];
    
    //账号
    UIView *zhangHaoView = [[UIView alloc] init];
    zhangHaoView.frame = CGRectMake(18.5f,72.5f,self.loginView.width_mn-37.f,45);
    zhangHaoView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    zhangHaoView.layer.cornerRadius = 22.5;
    [loginView addSubview:zhangHaoView];
    
    UILabel *zhangHaoLab=[UILabel labelWithFrame:CGRectMake(19.f, 16.f, 30.f, 15.f) text:@"账号" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [zhangHaoView addSubview:zhangHaoLab];
    
    UITextField *zhangHaoText=[UITextField textFieldWithFrame:CGRectMake(zhangHaoLab.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请输入您的公司全称/身份账号名" delegate:self];
    zhangHaoText.borderStyle=UITextBorderStyleNone;
    zhangHaoText.centerY_mn=zhangHaoLab.centerY_mn;
    [zhangHaoView addSubview:zhangHaoText];
    
    //密码
    UIView *passworldView = [[UIView alloc] init];
    passworldView.frame = CGRectMake(18.5f,zhangHaoView.bottom_mn+20.f,self.loginView.width_mn-37.f,45);
    passworldView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:245/255.0 alpha:1.0];
    passworldView.layer.cornerRadius = 22.5;
    [loginView addSubview:passworldView];
    
    UILabel *passworldLab=[UILabel labelWithFrame:CGRectMake(19.f, 16.f, 30.f, 15.f) text:@"密码" textColor:[UIColor colorWithHex:@"#454545"] font:UIFontSystem(14.f)];
    [passworldView addSubview:passworldLab];
    
    UITextField *passworldText=[UITextField textFieldWithFrame:CGRectMake(zhangHaoLab.right_mn+15.f, 16.f, zhangHaoView.width_mn-80.f, 30.f) font:UIFontSystem(12.f) placeholder:@"请输入登录密码" delegate:self];
    passworldText.borderStyle=UITextBorderStyleNone;
    passworldText.centerY_mn=passworldLab.centerY_mn;
    [passworldView addSubview:passworldText];
    
    //记住密码
    UIImageView *remberImg=[[UIImageView alloc]initWithFrame:CGRectMake(37.5f, passworldView.bottom_mn+14.f, 10.5f,10.5f)];
    remberImg.image=[UIImage imageNamed:@"icon"];
    [loginView addSubview:remberImg];
    
    UILabel *remberLab=[UILabel labelWithFrame:CGRectMake(remberImg.right_mn+5.f, passworldView.bottom_mn+14.f, 50.f, 13.f) text:@"记住密码" textColor:[UIColor colorWithHex:@"#A8B2B9"] font:UIFontSystem(12.f)];
    [loginView addSubview:remberLab];
    
    UIButton *changePassworld=[UIButton buttonWithFrame:CGRectZero image:nil title:@"更改密码" titleColor:[UIColor colorWithHex:@"#379690"] titleFont:UIFontSystem(12.f)];
    changePassworld.size_mn=CGSizeMake(50.f, 13.f);
    changePassworld.top_mn=passworldView.bottom_mn+14.f;
    changePassworld.right_mn=loginView.right_mn-35.5f;
    [changePassworld addTarget:self action:@selector(changePassworld) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:changePassworld];
    //登录
    UIButton *loginBtn=[UIButton buttonWithFrame:CGRectZero image:nil title:@"登录" titleColor:UIColor.whiteColor titleFont:UIFontSystem(12.f)];
    loginBtn.backgroundColor=GXS_THEME_COLOR;
    loginBtn.height_mn=40.f;
    loginBtn.top_mn=passworldView.bottom_mn+76.f;
    loginBtn.left_mn=loginView.left_mn;
    loginBtn.width_mn=loginView.width_mn-37.f;
    loginBtn.layer.cornerRadius=20.f;
    [loginBtn addTarget:self action:@selector(loginInfo) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginBtn];
    
    NSString *string = @"登录代表你同意 平台用户协议 与 平台隐私政策 ";
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
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.f, 0.f, scrollView.width_mn/4.f*3.f, 0.f)];
    textView.height_mn =15.f;
    textView.top_mn = loginBtn.bottom_mn+52.5f;
    textView.centerX_mn = loginView.width_mn/2.f;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.delegate = self;
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
    [loginView addSubview:textView];
}

#pragma make -event response

- (void)changePassworld{
    ForGetPassworldView *forgetView=[[ForGetPassworldView alloc]initWithFrame:CGRectMake(17.5,self.headerView.bottom_mn-50.f,self.view.width_mn-35.f,410) returnValue:^(NSString * _Nonnull zhanghao, NSString * _Nonnull oldPassworld, NSString * _Nonnull passworld, NSString * _Nonnull sumbitPassworld) {
        NSLog(@"重置密码事件");
    }];
    forgetView.layer.cornerRadius=11.5f;
    [self.scrollView addSubview:forgetView];
}

- (void)loginInfo{
    
}

-  (void)registerInfo{
    
    RegisterView *regsiter=[[RegisterView alloc]initWithFrame: CGRectMake(17.5,self.headerView.bottom_mn-50.f,self.view.width_mn-35.f,380) returnValue:^(NSString * _Nonnull zhanghao, NSString * _Nonnull passworld, NSString * _Nonnull sumbitPassworld) {
        NSLog(@"注册事件");
    }];
    regsiter.layer.cornerRadius=11.5f;
    [self.scrollView addSubview:regsiter];
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
    MNWebViewController *vc = [[MNWebViewController alloc] initWithURL:URL];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Super
- (MNContentEdges)contentEdges{
    return MNContentEdgeNone;
}

@end

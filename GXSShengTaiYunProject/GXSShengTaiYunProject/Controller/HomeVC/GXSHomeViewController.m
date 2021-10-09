//
//  GXSHomeViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

#import "GXSHomeViewController.h"
#import "GXSGonggaoViewController.h"
#import "GXSAllHuanJingViewController.h"
#import "GXSNewProjectViewController.h"
#import "GXSDanganViewController.h"

@interface GXSHomeViewController ()
//btnArray
@property (nonatomic,strong)NSArray *btnArray;
//功能展示view
@property (nonatomic,strong)UIView *btnView;
//隐藏或展示
@property (nonatomic,assign)BOOL isShow;
@end

@implementation GXSHomeViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewUp];
}

#pragma  mark -mothod

- (void)setViewUp{
//    self.contentView.backgroundColor=UIColor.orangeColor;
    self.isShow=NO;
    UIView *btnView=[[UIView alloc]init];
    btnView.width_mn=self.contentView.width_mn;
    btnView.height_mn=300.f;
    btnView.left_mn=0.f;
    btnView.bottom_mn=self.contentView.bottom_mn+200.f;
    btnView.backgroundColor=UIColor.whiteColor;
    [btnView xg_setCornerRect:UIRectCornerTopLeft | UIRectCornerTopRight radius:10.f];
    [self.contentView addSubview:btnView];
    self.btnView=btnView;
    
    UIButton *topbtn=[UIButton buttonWithFrame:CGRectMake(0.f, 10.f, self.contentView.width_mn, 30.f) image:[UIImage imageNamed:@"icon_arrow_up_b"] title:@"展开" titleColor:UIColor.grayColor titleFont:UIFontSystem(15)];
    topbtn.imageEdgeInsets=UIEdgeInsetsMake(-8.f, 10.f, 8.f, -10.f);
    topbtn.titleEdgeInsets=UIEdgeInsetsMake(8.f, -10.f, -8.f, 10.f);
    [topbtn addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:topbtn];
    
//    UIButton *menmubtn=[UIButton buttonWithFrame:CGRectMake(10.f, topbtn.bottom_mn+10.f, self.contentView.width_mn-20.f, 40.f) image:[UIImage imageNamed:@"icon_arrow_right_c"] title:@"新建企业信息" titleColor:UIColor.whiteColor titleFont:UIFontSystem(15)];
//    menmubtn.layer.cornerRadius=8.f;
//    menmubtn.backgroundColor=GXS_THEME_COLOR;
//    menmubtn.imageEdgeInsets=UIEdgeInsetsMake(0.f, menmubtn.width_mn/2+30.f, 0.f, -menmubtn.width_mn/2-30.f);
//    menmubtn.titleEdgeInsets=UIEdgeInsetsMake(0.f, -menmubtn.width_mn/2+50.f, 0.f, menmubtn.width_mn/2-50.f);
//    [menmubtn addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
//    [btnView addSubview:menmubtn];
    
    for (int i=0; i<self.btnArray.count; i++) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10.f, topbtn.bottom_mn+i*50+10.f, btnView.width_mn-20.f, 40.f)];
        bgView.layer.cornerRadius=8.f;
        bgView.backgroundColor=GXS_THEME_COLOR;
        bgView.tag=i+100;
        bgView.userInteractionEnabled=YES;
        [btnView addSubview:bgView];
        
        
        UILabel *title=[UILabel labelWithFrame:CGRectZero text:self.btnArray[i] textColor:UIColor.whiteColor font:UIFontSystem(15)];
        title.height_mn=18.f;
        title.width_mn=bgView.width_mn-40.f;
        title.left_mn=10.f;
        title.top_mn=11.f;
//        title.centerY_mn=bgView.centerY_mn;
        title.textAlignment=NSTextAlignmentLeft;
        [bgView addSubview:title];

        UIImageView *rightImage=[[UIImageView alloc]init];
        rightImage.image=[UIImage imageNamed:@"icon_arrow_right_c"];
        rightImage.size_mn=CGSizeMake(12.f, 16.f);
        rightImage.left_mn=bgView.right_mn-30.f;
        rightImage.centerY_mn=title.centerY_mn;
        [bgView addSubview:rightImage];
        
        //点击事件
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(nextClick:)];
        [bgView addGestureRecognizer:tap];
    }
}


#pragma  mark -event

- (void)showView:(UIButton *)btn{
    self.isShow=!self.isShow;
    if (self.isShow) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_arrow_down_a"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=self.btnView.frame;
            rect.origin.y-=200.f;
            self.btnView.frame=rect;
        }];
    }else{
        [btn setTitle:@"展开" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_arrow_up_b"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=self.btnView.frame;
            rect.origin.y+=200.f;
            self.btnView.frame=rect;
        }];
    }
}

- (void)nextClick:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",(long)[tap view].tag);
    NSInteger tag=[tap view].tag;
    if (tag==100) {
        GXSNewProjectViewController *new=[[GXSNewProjectViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
    }else if(tag==101){
        GXSAllHuanJingViewController *huangjing=[[GXSAllHuanJingViewController alloc]init];
        [self.navigationController pushViewController:huangjing animated:YES];
    }else if(tag==102){
        GXSDanganViewController *dangan=[[GXSDanganViewController alloc]init];
        [self.navigationController pushViewController:dangan animated:YES];
    }else if(tag==103){
        GXSGonggaoViewController *gonggao=[[GXSGonggaoViewController alloc]init];
        [self.navigationController pushViewController:gonggao animated:YES];
    }
}

#pragma mark - getter and setter

- (NSArray *)btnArray{
    if (!_btnArray) {
        _btnArray=[[NSArray alloc]initWithObjects:@"新建企业信息",@"企业/生态环境要素信息搜索",@"生态环境核查",@"公告",nil];
    }
    return  _btnArray;
}

#pragma mark - Super
- (BOOL)isRootViewController {
    return YES;
}

- (NSString *)tabBarItemTitle {
    return @"首页";
}


- (MNContentEdges)contentEdges {
    return MNContentEdgeBottom;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGRect)emptyViewFrame {
    return UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
}


@end

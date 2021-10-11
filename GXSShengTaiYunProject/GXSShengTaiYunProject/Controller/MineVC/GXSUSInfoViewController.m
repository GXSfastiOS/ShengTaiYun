//
//  GXSUSInfoViewController.m
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/10/10.
//

#import "GXSUSInfoViewController.h"

@interface GXSUSInfoViewController ()

@end

@implementation GXSUSInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView{
    [super createView];
    self.title=@"关于我们";
    //icon
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(0.f, 50.f, 85.f,85.f)];
    icon.image=[UIImage imageNamed:@"icon"];
    icon.clipsToBounds=YES;
    icon.layer.cornerRadius=14.f;
    icon.centerX_mn=self.view.width_mn/2;
    [self.contentView addSubview:icon];
    
    UILabel *tLab=[UILabel labelWithFrame:CGRectMake(15.5, icon.bottom_mn+47.5, self.view.width_mn-31.f, 285) text:@"    华嘉泰(上海)室内游乐有限公司是华夏动漫与日本SEGA联手打造的无与伦比的次世代数码游艺乐园，拥有8200坪的大型室内空间、多项高科技数码游艺设施。独一无二的JOYPOLIS，让你进入真实的梦幻殿堂,虚拟与现实完美结合，带给大家前所未有的游乐体验。\n    JOYPOLIS品牌已有21余年的历史 ，秉承SEGA优良的运营理念及管理，发展足迹遍及东京、上海、青岛等地。超人气的招牌项目“SEGA头文字D”带你体验秋名山漂移的快感，“变形金刚”感受驾驶变形金刚的神奇体验，打破次元壁，这里将是你实现二次元“白日梦”的乐园。" textColor:[UIColor colorWithHex:@"#333333"] font:UIFontMedium(15.f)];
    tLab.numberOfLines=0;
    [self.contentView addSubview:tLab];
    
    UILabel *bottomLab=[UILabel labelWithFrame:CGRectMake(0.f, self.contentView.height_mn-40.f,250.f, 14.f) text:@"Copyright2021-2022 复绿科技有限公司 版权所有" textColor:[UIColor colorWithHex:@"#888888"] font:UIFontMedium(11.f)];
    bottomLab.centerX_mn=self.contentView.width_mn/2;
    [self.contentView addSubview:bottomLab];
    
}

#pragma mark - Super

- (MNContentEdges)contentEdges{
    return MNContentEdgeTop;
}

@end

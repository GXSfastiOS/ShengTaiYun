//
//  GXSTaskTableViewCell.m
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/9/27.
//

#import "GXSTaskTableViewCell.h"

@interface  GXSTaskTableViewCell ()
//问题编号
@property (nonatomic,strong)UILabel *questionIdLab;
//发布时间
@property (nonatomic,strong)UILabel *fubuTimeLab;
//审核人员
@property (nonatomic,strong)UILabel *reviewPresonLab;
//分管领导
@property (nonatomic,strong)UILabel *fenGuanLingDaoLab;
@end

@implementation GXSTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self) {
        self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    self.backgroundColor=UIColor.whiteColor;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(15.f, 10.f,MN_SCREEN_WIDTH-30.f, 124.f)];
    view.layer.cornerRadius=8.f;
    view.layer.borderWidth=0.5f;
    view.layer.borderColor=UIColor.grayColor.CGColor;
    [self addSubview:view];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(5.f, 10.f, 20.f, 20.f)];
    image.image=[UIImage imageNamed:@"icon_archives_small"];
    [view addSubview:image];
    
    UILabel *questionLab=[UILabel labelWithFrame:CGRectMake(image.right_mn+10.f, image.top_mn, view.width_mn-image.right_mn-30.f, 20.f) text:@"问题编号：202102154561" alignment:NSTextAlignmentLeft textColor:UIColor.blackColor font:UIFontSystem(18)];
    [view addSubview:questionLab];
    self.questionIdLab=questionLab;
    
    UILabel *fabuLab=[UILabel labelWithFrame:CGRectMake(image.left_mn, image.bottom_mn+10.f, view.width_mn-30.f, 15.f) text:@"发布时间：202102154561" alignment:NSTextAlignmentLeft textColor:UIColor.grayColor font:UIFontSystem(16)];
    [view addSubview:fabuLab];
    self.fubuTimeLab=fabuLab;
    
    UILabel *reviewLab=[UILabel labelWithFrame:CGRectMake(image.left_mn, fabuLab.bottom_mn+10.f, view.width_mn-30.f, 15.f) text:@"核查人员：李四" alignment:NSTextAlignmentLeft textColor:UIColor.grayColor font:UIFontSystem(15)];
    [view addSubview:reviewLab];
    self.reviewPresonLab=reviewLab;
    
    UILabel *fenguanLab=[UILabel labelWithFrame:CGRectMake(image.left_mn,reviewLab.bottom_mn+10.f, view.width_mn-image.right_mn-30.f, 15.f) text:@"分管领导：张三" alignment:NSTextAlignmentLeft textColor:UIColor.grayColor font:UIFontSystem(15)];
    [view addSubview:fenguanLab];
    self.fenGuanLingDaoLab=fenguanLab;
    
    //查看详情
    UIButton *moreInfoBtn=[UIButton buttonWithFrame:CGRectZero image:nil title:@"查看详情" titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(15.f)];
    moreInfoBtn.size_mn=CGSizeMake(65.f, 15.f);
    moreInfoBtn.right_mn=view.right_mn-35.f;
    moreInfoBtn.bottom_mn=view.bottom_mn-25.f;
    [moreInfoBtn addTarget:self action:@selector(moreInfo) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreInfoBtn];
    
    UIImageView *moreImg=[UIImageView imageViewWithFrame:CGRectMake(moreInfoBtn.right_mn, moreInfoBtn.top_mn, 15.f, 15.f) image:[UIImage imageNamed:@"icon_arrow_right_b"]];
    moreImg.centerY_mn=moreInfoBtn.centerY_mn;
    [view addSubview:moreImg];
}

- (void)setModel:(TaskModel *)model{
    
}


- (void)moreInfo{
    
}

@end

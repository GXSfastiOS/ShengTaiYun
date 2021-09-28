//
//  GXXGonggaoTableViewCell.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/28.
//

#import "GXSGonggaoTableViewCell.h"

@interface GXSGonggaoTableViewCell ()
//公告类型
@property (nonatomic,strong)UILabel *gongGaoTitle;
//展示部分
@property (nonatomic,strong)UILabel *gongGaoMore;
//发布时间
@property (nonatomic,strong)UILabel *gongGaoTime;

@end

@implementation GXSGonggaoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self) {
        self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    self.contentView.backgroundColor=[UIColor colorWithHex:@"F6F6F6"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(15.f, 10.f,MN_SCREEN_WIDTH-30.f, 200.f)];
    view.layer.cornerRadius=8.f;
    view.backgroundColor=UIColor.whiteColor;
    [self addSubview:view];
    
    UILabel *gongGaoTitle=[UILabel labelWithFrame:CGRectMake(15.f, 10.f, view.width_mn-30.f, 20.f) text:@"系统公告" alignment:NSTextAlignmentLeft textColor:UIColor.blackColor font:UIFontSystem(20)];
    [view addSubview:gongGaoTitle];
    self.gongGaoTitle=gongGaoTitle;
    
    UILabel *gongGaomore=[UILabel labelWithFrame:CGRectMake(15.f, gongGaoTitle.bottom_mn+10.f, view.width_mn-20.f, 80.f) text:@"系统公告" alignment:NSTextAlignmentLeft textColor:UIColor.grayColor font:UIFontSystem(16)];
    gongGaomore.numberOfLines=0;
    [view addSubview:gongGaomore];
    self.gongGaoMore=gongGaomore;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15.f, gongGaomore.bottom_mn+10.f,view.width_mn-20.f, 1.f)];
    lineView.backgroundColor=[UIColor colorWithHex:@"F6F6F6"];
    [view addSubview:lineView];
    
    UILabel *gongGaoDetail=[UILabel labelWithFrame:CGRectMake(15.f, lineView.bottom_mn+10.f, 100.f, 20.f) text:@"查看详情" alignment:NSTextAlignmentLeft textColor:UIColor.grayColor font:UIFontSystem(16)];
    gongGaomore.numberOfLines=0;
    [view addSubview:gongGaoDetail];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(view.right_mn-40.f, lineView.bottom_mn+10.f, 15.f, 15.f)];
    image.image=[UIImage imageNamed:@"icon_arrow_right_a"];
    [view addSubview:image];
    
    UILabel *gongGaoTime=[UILabel labelWithFrame:CGRectMake(0.f, view.bottom_mn+10.f, 100.f, 20.f) text:@"12:00" alignment:NSTextAlignmentCenter textColor:UIColor.grayColor font:UIFontSystem(16)];
    gongGaoTime.centerX_mn=view.centerX_mn;
    [view addSubview:gongGaoTime];
    self.gongGaoTime=gongGaoTime;
    
}

@end

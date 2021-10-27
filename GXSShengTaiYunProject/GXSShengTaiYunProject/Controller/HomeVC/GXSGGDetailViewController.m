//
//  GXSGGDetailViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/27.
//

#import "GXSGGDetailViewController.h"

@interface GXSGGDetailViewController ()
@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation GXSGGDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView{
    [super createView];
    self.title=@"公告详情";

    self.scrollView=[[UIScrollView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.scrollView];
    
    UILabel *titleLab=[UILabel labelWithFrame:CGRectMake(25.f, 30.f, self.contentView.width_mn-80.f, 40.f) text:self.model.title textColor:UIColor.blackColor font:UIFontMedium(18)];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.numberOfLines=0;
    [self.scrollView addSubview:titleLab];
    
    CGSize size=[NSString stringSize:self.model.author fontSize:13.f];
    UILabel *authorLab=[UILabel labelWithFrame:CGRectMake(25.f, titleLab.bottom_mn+10.f,size.width, size.height) text:self.model.author textColor:PAGE_COLOR font:UIFontMedium(13)];
    authorLab.textAlignment=NSTextAlignmentCenter;
    authorLab.numberOfLines=0;
    [self.scrollView addSubview:authorLab];
    
    CGSize timeSize=[NSString stringSize:[NSDate dateStringWithTimestamp:self.model.add_time format:@"yyyy-MM-dd HH:mm"] fontSize:13.f];
    UILabel *timeLab=[UILabel labelWithFrame:CGRectMake(authorLab.right_mn+10.f, titleLab.bottom_mn+10.f,timeSize.width+20.f, timeSize.height) text:[NSDate dateStringWithTimestamp:self.model.add_time format:@"yyyy-MM-dd HH:mm"] textColor:PAGE_COLOR font:UIFontMedium(13)];
    timeLab.numberOfLines=0;
    [self.scrollView addSubview:timeLab];
    
    CGSize conSize=[NSString boundingSizeWithString:self.model.content size:CGSizeMake(self.contentView.width_mn-50.f,self.contentView.height_mn) attributes:[NSDictionary dictionary]];
    UILabel *conLab=[UILabel labelWithFrame:CGRectMake(25.f, timeLab.bottom_mn+20.f,self.contentView.width_mn-50.f, conSize.height) text:self.model.content textColor:UIColor.blackColor font:UIFontMedium(13)];
    conLab.textAlignment=NSTextAlignmentCenter;
    conLab.numberOfLines=0;
    [self.scrollView addSubview:conLab];
    
    
}

#pragma mark - Super

- (MNContentEdges)contentEdges {
    return MNContentEdgeTop;
}
@end

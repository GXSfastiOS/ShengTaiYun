//
//  GXSNewAddInfoTableViewCell.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/11/2.
//

#import "GXSNewAddInfoTableViewCell.h"
#import <JXCategoryView/JXCategoryView.h>
#import "FMPrejectView.h"

@interface  GXSNewAddInfoTableViewCell()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property  (nonatomic,strong)NSMutableArray *addArray;
@property  (nonatomic,strong)JXCategoryTitleView *categoryViewFast;
@property  (nonatomic,strong)JXCategoryListContainerView *listContainerViewFast;
@property  (nonatomic,strong)UIButton *addbtn;
@property  (nonatomic,strong)NSString *title;
@property  (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation GXSNewAddInfoTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setUp];
//    }
//    return  self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Title:(NSString *)title{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.title=title;
        [self setUp];
    }
    return  self;
}

- (void)setUp{
    self.addArray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@1",self.title], nil];
    self.scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0.f,MN_SCREEN_WIDTH, 40.f)];
    [self addSubview:self.scrollView];
    [self PageView];
    
    
    UIButton *addBtn=[UIButton buttonWithFrame:CGRectMake(self.categoryViewFast.right_mn+10.f, 5.f, 80.f, 30.f) image:nil title:@"添加" titleColor:UIColor.whiteColor titleFont:UIFontMedium(14)];
    [addBtn addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    addBtn.layer.cornerRadius=15;
    addBtn.backgroundColor=GXS_THEME_COLOR;
    [self.scrollView addSubview:addBtn];
    self.addbtn=addBtn;
}

- (void)btnView{
    
}

- (void)addBtn{
    NSInteger i=self.addArray.count+1;
    [self.addArray addObject:[NSString  stringWithFormat:@"%@%ld",self.title,(long)i++]];
    self.scrollView.contentSize=CGSizeMake(self.addArray.count*80+100, 40);
    [self PageView];
}

#pragma mark - setUpPageView

- (void)PageView {
    
    self.categoryViewFast = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0,self.addArray.count*80, 40)];
    self.categoryViewFast.delegate = self;
    self.categoryViewFast.backgroundColor=ssRGBHex(0XEEEEEE);
    self.categoryViewFast.titles = self.addArray;
    self.categoryViewFast.titleColor =UIColor.blackColor;
    self.categoryViewFast.titleSelectedColor = UIColor.blackColor;
    self.categoryViewFast.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
//    self.categoryViewFast.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
//    self.categoryViewFast.averageCellSpacingEnabled = NO;
//    self.categoryViewFast.titleColorGradientEnabled = NO;
//    self.categoryViewFast.titleLabelZoomEnabled = NO;
//    self.categoryViewFast.titleLabelZoomScale = 1.5;
//    self.categoryViewFast.titleLabelStrokeWidthEnabled = NO;
//    self.categoryViewFast.selectedAnimationEnabled = NO;
//    self.categoryViewFast.cellWidthZoomEnabled = NO;
//    self.categoryViewFast.cellWidthZoomScale = 1.5;
//    self.categoryViewFast.contentEdgeInsetLeft = 0;
//    self.categoryViewFast.cellWidth=80.f;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorWidth =80.f;
    lineView.indicatorColor = GXS_THEME_COLOR;
    
    self.categoryViewFast.indicators = @[lineView];
    [self.scrollView addSubview:self.categoryViewFast];
    self.listContainerViewFast = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerViewFast.frame = CGRectMake(0, self.categoryViewFast.bottom_mn, MN_SCREEN_WIDTH,100.f);
    [self addSubview:self.listContainerViewFast];
    self.categoryViewFast.listContainer = self.listContainerViewFast;
    
    self.addbtn.left_mn=self.categoryViewFast.right_mn+10;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    FMPrejectView *prcject=[[FMPrejectView alloc] initWithFrame:listContainerView.frame];
    prcject.cid=index;
    return prcject;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryViewFast.titles.count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

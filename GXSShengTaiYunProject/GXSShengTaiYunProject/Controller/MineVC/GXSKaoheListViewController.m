//
//  GXSKaoheListViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/11.
//

static NSString * cellIdentifier=@"KHtableCellIdentfier";

#import "GXSKaoheListViewController.h"

@interface GXSKaoheListViewController ()<MNSegmentSubpageDataSource>
//titleArray
@property (nonatomic,strong)NSArray *titleArray;
//cid
@property (nonatomic,assign)NSInteger cid;
@end

@implementation GXSKaoheListViewController

#pragma mark -lifeCycle

- (instancetype)initWithFrame:(CGRect)frame cid:(NSInteger)cid {
    if (self = [super initWithFrame:frame]) {
        self.cid=cid;
        [self createView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createView{
    [super createView];
    self.tableView.frame = self.contentView.bounds;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor=BG_GARYCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.tableView.width_mn, 80.f)];
    UILabel *rLab=[UILabel labelWithFrame:CGRectMake(15.f, 10.f, self.tableView.width_mn-30.f, 80.f) text:@"注意" textColor:UIColor.yellowColor font:UIFontSystem(15.f)];
    rLab.numberOfLines=0;
    [footerView addSubview:rLab];
    self.tableView.tableFooterView=footerView;
//    self.tableView.rowHeight = 50.f;

}


#pragma mark - MNSegmentSubpageDataSource
- (UIScrollView *)segmentSubpageScrollView {
    return self.tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text=self.titleArray[indexPath.row];
    cell.detailTextLabel.text=@"A";
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return  cell;
}


#pragma mark - getter and setter

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[[NSArray alloc]initWithObjects:@"网格",@"网格员",@"分管领导",@"签到次数",@"打卡次数",nil];
    }
    return  _titleArray;
}

#pragma mark -super

- (MNContentEdges)contentEdges {
    return MNContentEdgeNone;
}

- (MNListViewType)listViewType{
    return MNListViewTypeTable;
}

- (BOOL)isChildViewController {
    return YES;
}

@end

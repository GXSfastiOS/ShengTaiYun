//
//  GXSHechaViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/11.
//

static NSString * cellIdentifier=@"HCtableCellIdentfier";

#import "GXSHechaViewController.h"

@interface GXSHechaViewController ()
//titleArray
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation GXSHechaViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)createView{
    [super createView];
    self.title=@"我的核查工作";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text=self.dataArray[indexPath.row];
    cell.detailTextLabel.text=@"A";
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return  cell;
}


#pragma mark - getter and setter

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSArray alloc]initWithObjects:@"网格",@"网格员",@"分管领导",@"签到次数",@"打卡次数",nil];
    }
    return  _dataArray;
}

#pragma mark -super

- (MNContentEdges)contentEdges{
    return MNContentEdgeTop;
}

- (MNListViewType)listViewType{
    return MNListViewTypeTable;
}


@end

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
//titleArray
@property (nonatomic,strong)NSDictionary *datailDic;
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
    [self getData];

}

- (void)getData{
    GXSHTTPDataRequest *requst=[[GXSHTTPDataRequest alloc]init];
    requst.cachePolicy = MNURLDataCachePolicyNever;
    requst.method = MNURLHTTPMethodPost;
    requst.url=URL_HANDING(@"/app/qiandao/qiandao_kaoping");
    requst.body=@{@"type":@(self.cid),@"member_id":@"10000",@"token":@"777777"};
    @weakify(self);
    [requst loadData:^{
        @strongify(self);
        [self.view showActivityDialog:@"请稍后"];
    } completion:^(MNURLResponse * _Nonnull response) {
        if (response.code==MNURLResponseCodeSucceed) {
            [self.view closeDialog];
            self.datailDic=response.data[@"info"];
            [self.tableView reloadData];
        }else{
            [self.view showErrorDialog:response.message];
        }
    }];
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
    if (indexPath.row==0) {
        cell.detailTextLabel.text=self.datailDic[@"wangge_name"];
    }else if(indexPath.row==1){
        cell.detailTextLabel.text=self.datailDic[@"name"];
    }else if(indexPath.row==2){
        cell.detailTextLabel.text=self.datailDic[@"lingdao_name"];
    }else if(indexPath.row==3){
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.datailDic[@"qiandao_num"]];
    }else if(indexPath.row==4){
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.datailDic[@"daka_num"]];
    }
    
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

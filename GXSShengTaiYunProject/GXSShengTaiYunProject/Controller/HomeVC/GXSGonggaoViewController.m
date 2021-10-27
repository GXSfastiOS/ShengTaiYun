//
//  GXSGonggaoViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/28.
//

static NSString *cellID=@"gxsGonggaoCellID";

#import "GXSGonggaoViewController.h"
#import "GXSGonggaoTableViewCell.h"
#import "GXSGongGaoModel.h"
#import "GXSGGDetailViewController.h"

@interface GXSGonggaoViewController ()
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation GXSGonggaoViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)createView{
    [super createView];
    self.title=@"公告列表";
    self.tableView.frame=self.contentView.frame;
    self.pullRefreshEnabled=YES;
    self.loadMoreEnabled=YES;
    self.page=1;
    self.dataArray=[[NSMutableArray alloc]initWithCapacity:10];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[GXSGonggaoTableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    [self getData];
}

- (void)getData{
    GXSHTTPDataRequest *requst=[[GXSHTTPDataRequest alloc]init];
    requst.cachePolicy = MNURLDataCachePolicyNever;
    requst.method = MNURLHTTPMethodPost;
    requst.url=URL_HANDING(@"/app/article/article_list");
    requst.body=@{@"num":@(20),@"p":@(self.page)};
    @weakify(self);
    [requst loadData:^{
        @strongify(self);
        [self.view showActivityDialog:@"请稍后"];
    } completion:^(MNURLResponse * _Nonnull response) {
        if (response.code==MNURLResponseCodeSucceed) {
            [self.view closeDialog];
            if (self.page==1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:response.data[@"info"]];
            }else{
                [self.dataArray addObjectsFromArray:response.data[@"info"]];
            }
            [self.tableView reloadData];
        }else{
            [self.view showErrorDialog:response.message];
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSGonggaoTableViewCell *cell=[[GXSGonggaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    GXSGongGaoModel *model=[GXSGongGaoModel yy_modelWithDictionary:self.dataArray[indexPath.row]];
    cell.model=model;
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSGongGaoModel *model=[GXSGongGaoModel yy_modelWithDictionary:self.dataArray[indexPath.row]];
    GXSGGDetailViewController *detail=[[GXSGGDetailViewController alloc]init];
    detail.model=model;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250.f;
}


#pragma mark - Super


/**
 下拉刷新触发
 */
- (void)beginPullRefresh{
    self.page=1;
    [self getData];
}

- (void)beginLoadMore{
    self.page++;
    [self getData];
}

- (MNContentEdges)contentEdges {
    return MNContentEdgeTop;
}

- (MNListViewType)listViewType{
    return  MNListViewTypeTable;
}

@end

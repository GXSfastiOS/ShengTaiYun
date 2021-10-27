//
//  GXSTaskViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

static NSString *cellId=@"TaskcellID";

#import "GXSTaskViewController.h"
#import "GXSTaskTableViewCell.h"
#import "GXSAddprojectViewController.h"
#import "GXSAllCompanyViewController.h"

@interface GXSTaskViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *nowTaskBtn;
@property (nonatomic,strong) UIButton *historyTaskBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,assign) NSInteger page;
@end

@implementation GXSTaskViewController

#pragma  mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

#pragma  mark -mothod

- (void)setUpUI{
    
    UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake((MN_SCREEN_WIDTH-201.f)/2, 80.f, 201.f, 40.f)];
    [self.contentView addSubview:btnView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(100.f, 10.f, 1.f, 20.f)];
    lineView.backgroundColor=UIColor.grayColor;
    [btnView addSubview:lineView];
    self.status=@"1";
    self.keyword=@"";
    self.page=1;
    self.dataArray=[NSMutableArray array];
    //当前任务
    UIButton *nowTaskBtn=[UIButton buttonWithFrame:CGRectMake(0.f, 0.f, 100.f, 40.f) image:nil title:@"当前任务" titleColor:UIColor.blackColor titleFont:[UIFont systemFontOfSize:20.f]];
    [nowTaskBtn addTarget:self action:@selector(nowTask:) forControlEvents:UIControlEventTouchUpInside];
    nowTaskBtn.tag=100;
    [btnView addSubview:nowTaskBtn];
    self.nowTaskBtn=nowTaskBtn;
    //历史任务
    UIButton *historyTaskBtn=[UIButton buttonWithFrame:CGRectMake(101.f, 0.f, 100.f, 40.f) image:nil title:@"历史任务" titleColor:UIColor.grayColor titleFont:[UIFont systemFontOfSize:15]];
    [historyTaskBtn addTarget:self action:@selector(nowTask:) forControlEvents:UIControlEventTouchUpInside];
    nowTaskBtn.tag=101;
    [btnView addSubview:historyTaskBtn];
    self.historyTaskBtn=historyTaskBtn;

    //tableView
    [self.contentView addSubview:self.tableView];
    //搜索
    UIView *searchView=[[UIView alloc]initWithFrame:CGRectMake(0.f, btnView.bottom_mn, self.contentView.width_mn, 44.f)];
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:searchView.frame];
    searchBar.placeholder=@"可输入编号搜索";
    searchBar.delegate=self;
    searchBar.backgroundColor=UIColor.whiteColor;
    UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    barImageView.layer.borderWidth=1;
    [searchView addSubview:searchBar];
    [self.contentView addSubview:searchBar];
    
    //添加
    UIButton *addTaskBtn=[UIButton buttonWithFrame:CGRectZero image:[UIImage imageNamed:@"addTask"] title:@"" titleColor:nil titleFont:nil];
    addTaskBtn.size_mn=CGSizeMake(50.f, 50.f);
    addTaskBtn.right_mn=self.contentView.right_mn-20.f;
    addTaskBtn.bottom_mn=self.contentView.bottom_mn-100.f;
    [addTaskBtn addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addTaskBtn];
    [self getDataInfo];
}

#pragma mark - event

- (void)getDataInfo{
    GXSHTTPDataRequest *requst=[[GXSHTTPDataRequest alloc]init];
    requst.cachePolicy = MNURLDataCachePolicyNever;
    requst.method = MNURLHTTPMethodPost;
    requst.url=URL_HANDING(@"/app/renwu/renwu_list");
    requst.body=@{@"keyword":self.keyword,@"status":self.status,@"p":@(self.page)};
    @weakify(self);
    [requst loadData:^{
        @strongify(self);
        [self.view showActivityDialog:@"请稍后"];
    } completion:^(MNURLResponse * _Nonnull response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (response.code==MNURLResponseCodeSucceed) {
            [self.view closeDialog];
            if (self.page==1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:response.data[@"info"]];
            }else{
                [self.dataArray addObjectsFromArray:response.data[@"info"]];
            }
        }else{
            [self.view showErrorDialog:response.message];
        }
    }];
}

- (void)nowTask:(UIButton *)btn{
    if (btn==self.nowTaskBtn) {
        self.status=@"1";
        self.nowTaskBtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
        [self.nowTaskBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        self.historyTaskBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        [self.historyTaskBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [self getDataInfo];
    }else{
        self.status=@"2";
        self.nowTaskBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        [self.nowTaskBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        self.historyTaskBtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
        [self.historyTaskBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self getDataInfo];
    }
}

- (void)headerReData{
    self.page=1;
    [self getDataInfo];
}

- (void)footerReData{
    self.page++;
    [self getDataInfo];
}

- (void)addTask{
//    GXSAddprojectViewController *add=[[GXSAddprojectViewController alloc]init];
//    [self.navigationController pushViewController:add animated:YES];
    GXSAllCompanyViewController *all=[[GXSAllCompanyViewController alloc]init];
    [self.navigationController pushViewController:all animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getDataInfo];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.keyword=searchBar.text;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSTaskTableViewCell *cell=[[GXSTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        GXSAllCompanyViewController *all=[[GXSAllCompanyViewController alloc]init];
        [self.navigationController pushViewController:all animated:YES];
    }else if(indexPath.row==1){
 
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134.5f;
}
#pragma mark -DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return  [UIImage imageNamed:@"HX_emptyImage"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *title=@"暂无数据";
    NSDictionary *string=@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f],NSForegroundColorAttributeName: MN_R_G_B(214, 214, 214)};
    return  [[NSAttributedString alloc]initWithString:title attributes:string];
}


#pragma mark - getter and setter


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 170.f, MN_SCREEN_WIDTH, self.contentView.bottom_mn-170.f) style:UITableViewStylePlain];
        _tableView.delegate               =self;
        _tableView.dataSource             =self;
        _tableView.emptyDataSetSource     =self;
        _tableView.emptyDataSetDelegate   =self;
        _tableView.separatorStyle         =UITableViewCellSeparatorStyleNone;
        _tableView.mj_header              =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerReData)];
        _tableView.mj_footer              =[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerReData)];
        [_tableView registerClass:[GXSTaskTableViewCell class] forCellReuseIdentifier:cellId];
        
    }
    return  _tableView;
}

#pragma mark - Super

- (BOOL)isRootViewController {
    return YES;
}
- (NSString *)tabBarItemTitle {
    return @"任务";
   
}

- (MNContentEdges)contentEdges {
    return MNContentEdgeBottom;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (CGRect)emptyViewFrame {
    return UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(self.view.top_mn, 0.f, 0.f, 0.f));
}

@end

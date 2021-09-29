//
//  GXSAllHuanJingViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/29.
//

#import "GXSAllHuanJingViewController.h"
#import "GXSTaskTableViewCell.h"
#import "TaskModel.h"

static NSString *cellId=@"huanjingCellID";

@interface GXSAllHuanJingViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *shaiXuanBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *searchLab;
@end

@implementation GXSAllHuanJingViewController

#pragma  mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}


- (void)createView{
    [super createView];
    self.title=@"所有企业/生态环境要素信息";
}


#pragma  mark -mothod

- (void)setUpUI{

    //tableView
    [self.contentView addSubview:self.tableView];
    //搜索
//    UIView *searchView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 10.f, self.contentView.width_mn-60.f, 44.f)];
//    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:searchView.frame];
//    searchBar.placeholder=@"";
//    searchBar.delegate=self;
//    searchBar.backgroundColor=UIColor.whiteColor;
//    UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
//    barImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    barImageView.layer.borderWidth=1;
//    [searchView addSubview:searchBar];
//    [self.contentView addSubview:searchBar];
    
    UILabel *searchLab=[UILabel labelWithFrame:CGRectMake(15.f, 10.f, self.contentView.width_mn-80.f, 40.f) text:@"----选择项目签订日期----" textColor:UIColor.grayColor font:UIFontSystem(15)];
    searchLab.backgroundColor=[UIColor colorWithHex:@"#F6F6F6"];
    searchLab.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:searchLab];
    //筛选
    UIButton *shaixuanBtn=[UIButton buttonWithFrame:CGRectZero image:[UIImage imageNamed:@"icon_screening"] title:@"筛选" titleColor:[UIColor grayColor] titleFont:UIFontSystem(13)];
//    shaixuanBtn.imageEdgeInsets=UIEdgeInsetsMake(-8.f, 10.f, 8.f, -10.f);
//    shaixuanBtn.titleEdgeInsets=UIEdgeInsetsMake(8.f, -10.f, -8.f, 10.f);
    shaixuanBtn.size_mn=CGSizeMake(50.f, 40.f);
    shaixuanBtn.right_mn=self.contentView.right_mn-10.f;
    shaixuanBtn.centerY_mn=searchLab.centerY_mn;
    [shaixuanBtn addTarget:self action:@selector(shaixuanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shaixuanBtn];
    //添加
    UIButton *addTaskBtn=[UIButton buttonWithFrame:CGRectZero image:[UIImage imageNamed:@"addTask"] title:@"" titleColor:nil titleFont:nil];
    addTaskBtn.size_mn=CGSizeMake(50.f, 50.f);
    addTaskBtn.right_mn=self.contentView.right_mn-20.f;
    addTaskBtn.bottom_mn=self.contentView.height_mn-100.f;
    [addTaskBtn addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addTaskBtn];
}

#pragma mark - event

- (void)addTask{
    
}

- (void)shaixuanClick{
    
}


//#pragma mark - UISearchBarDelegate
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//
//}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSTaskTableViewCell *cell=[[GXSTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    TaskModel *model=[[TaskModel alloc]init];
    model.type=1;
    cell.model=model;
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
      
    }else if(indexPath.row==1){
 
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134.5f;
}


#pragma mark - getter and setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 50.f, MN_SCREEN_WIDTH, self.contentView.height_mn-50.f) style:UITableViewStylePlain];
        _tableView.delegate               =self;
        _tableView.dataSource             =self;
        _tableView.tableFooterView        = [[UIView alloc]init];
        _tableView.separatorStyle         =UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GXSTaskTableViewCell class] forCellReuseIdentifier:cellId];
    }
    return  _tableView;
}

#pragma mark - Super


- (MNContentEdges)contentEdges {
    return MNContentEdgeTop;
}


@end

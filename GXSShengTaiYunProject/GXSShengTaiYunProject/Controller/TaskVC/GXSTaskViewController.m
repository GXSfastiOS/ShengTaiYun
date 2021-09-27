//
//  GXSTaskViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

#import "GXSTaskViewController.h"

@interface GXSTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *nowTaskBtn;
@property (nonatomic,strong) UIButton *historyTaskBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
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
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(100.f, 5.f, 1.f, 30.f)];
    lineView.backgroundColor=UIColor.grayColor;
    [btnView addSubview:lineView];
    
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
//    UISearchBar
}

#pragma mark - event

- (void)nowTask:(UIButton *)btn{
    if (btn==self.nowTaskBtn) {
        self.nowTaskBtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
        [self.nowTaskBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        self.historyTaskBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        [self.historyTaskBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    }else{
        self.nowTaskBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        [self.nowTaskBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        self.historyTaskBtn.titleLabel.font=[UIFont systemFontOfSize:18.f];
        [self.historyTaskBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
      
    }else if(indexPath.row==1){
 
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}


#pragma mark - getter and setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 120.f, MN_SCREEN_WIDTH, self.view.height_mn-120.f) style:UITableViewStylePlain];
        _tableView.delegate               =self;
        _tableView.dataSource             =self;
        _tableView.tableFooterView        = [[UIView alloc]init];
        _tableView.backgroundColor        =UIColor.blackColor;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
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

//- (UIImage *)tabBarItemImage {
//    return @"tab_message".image;
//}
//
//- (UIImage *)tabBarItemSelectedImage {
//    return @"tab_message_selected".image;
//}

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

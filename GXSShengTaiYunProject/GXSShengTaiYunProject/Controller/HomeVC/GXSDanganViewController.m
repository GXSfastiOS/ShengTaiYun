//
//  GXSDanganViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/9.
//
static NSString * cellIdentifier=@"tableCellIdentfier";

#import "GXSDanganViewController.h"

@interface GXSDanganViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
//titleArray
@property (nonatomic,strong)NSArray *titleArray;
//imageArray
@property (nonatomic,strong)NSArray *bottomArray;
//tableView
@property (nonatomic,strong)UITableView *tableView;
//下边tableView
@property (nonatomic,strong)UITableView *bottomTableView;
//头视图
@property (nonatomic,strong)MNAdsorbView *headerView;
@end

@implementation GXSDanganViewController

#pragma  mark -lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createView{
    [super createView];
    self.navigationBar.hidden=YES;
    UIScrollView *scrollView = [UIScrollView scrollViewWithFrame:self.contentView.bounds delegate:nil];
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor=[UIColor colorWithHex:@"#BDBFC4"];
    
    UIImage *headerImage = [UIImage imageNamed:@"bg"];
//    CGSize headerSize = CGSizeMultiplyToWidth(headerImage.size, scrollView.width_mn);
    MNAdsorbView *headerView = [[MNAdsorbView alloc] initWithFrame:CGRectMake(0.f, 0.f, scrollView.width_mn, 285.f)];
    headerView.imageView.image = headerImage;
    self.headerView=headerView;
    [scrollView addSubview:headerView];
    
    UIButton *returnBtn=[UIButton buttonWithFrame:CGRectMake(20.f, 80.f, 70.f, 20.f) image:[UIImage imageNamed:@"icon_arrow_left_b"] title:@"" titleColor:nil titleFont:UIFontSystem(12.f)];
    [returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:returnBtn];
    
    //文字
    UILabel *stLab=[[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, 150.f,60.f)];
    stLab.text=@"生态环境云平台\n生态环境档案";
    stLab.numberOfLines=0;
    stLab.font=[UIFont systemFontOfSize:19];
    stLab.textColor=[UIColor whiteColor];
    stLab.textAlignment=NSTextAlignmentCenter;
    stLab.center=headerView.center;
    [scrollView addSubview:stLab];
    
    UIView *nowView=[[UIView alloc]initWithFrame:CGRectMake(15.f, headerView.bottom_mn-50.f, headerView.width_mn-30.f, 60.f)];
    nowView.layer.cornerRadius=10.f;
    nowView.backgroundColor=UIColor.whiteColor;
    [scrollView addSubview:nowView];
    
    UILabel *nowLab=[[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, 110.f,20.f)];
    nowLab.text=@"当前企业信息";
    nowLab.font=[UIFont systemFontOfSize:15];
    nowLab.textColor=[UIColor blackColor];
    nowLab.centerY_mn=nowView.height_mn/2;
    [nowView addSubview:nowLab];
    
    UIButton *chakanBtn=[UIButton buttonWithFrame:CGRectMake(nowView.width_mn-125.f, 0.f, 30.f, 15.f) image:nil title:@"查看" titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(14.f)];
    [chakanBtn addTarget:self action:@selector(chakanClick) forControlEvents:UIControlEventTouchUpInside];
    chakanBtn.centerY_mn=nowLab.centerY_mn;
    [nowView addSubview:chakanBtn];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(chakanBtn.right_mn+5.f, 0.f, 1, chakanBtn.height_mn)];
    line.backgroundColor=GXS_THEME_COLOR;
    line.centerY_mn=nowLab.centerY_mn;
    [nowView addSubview:line];
    
    UIButton *changeBtn=[UIButton buttonWithFrame:CGRectMake(chakanBtn.right_mn+10.f, 0.f, 30.f, 15.f) image:nil title:@"修改" titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(14.f)];
    [changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.centerY_mn=nowLab.centerY_mn;
    [nowView addSubview:changeBtn];
    
    UIView *lineTwo=[[UIView alloc]initWithFrame:CGRectMake(changeBtn.right_mn+5.f, 0.f, 1, chakanBtn.height_mn)];
    lineTwo.backgroundColor=GXS_THEME_COLOR;
    lineTwo.centerY_mn=nowLab.centerY_mn;
    [nowView addSubview:lineTwo];
    
    UIButton *sumbitBtn=[UIButton buttonWithFrame:CGRectMake(changeBtn.right_mn+10.f, 0.f, 35.f, 14.f) image:nil title:@"确定" titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(14.f)];
    [sumbitBtn addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.centerY_mn=nowLab.centerY_mn;
    [nowView addSubview:sumbitBtn];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(15.f, nowView.bottom_mn+15.f, MN_SCREEN_WIDTH-30.f, 250.f) style:UITableViewStylePlain];
    _tableView.delegate               =self;
    _tableView.dataSource             =self;
    _tableView.layer.cornerRadius     =10.f;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [scrollView addSubview:_tableView];
    
    _bottomTableView=[[UITableView alloc]initWithFrame:CGRectMake(15.f, _tableView.bottom_mn+15.f, MN_SCREEN_WIDTH-30.f, 250.f) style:UITableViewStylePlain];
    _bottomTableView.delegate               =self;
    _bottomTableView.dataSource             =self;
    _bottomTableView.layer.cornerRadius     =10.f;
    _bottomTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [scrollView addSubview:_bottomTableView];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.tableView) {
        return self.titleArray.count;
    }else{
        return self.bottomArray.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text=tableView==self.tableView ? self.titleArray[indexPath.row]:self.bottomArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row!=0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image=[UIImage imageNamed:@"icon_archives_small"];
    }
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {

    }else if(indexPath.row==1){

    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

#pragma mark - event

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chakanClick{

}

- (void)changeClick{
    
}

- (void)sumbitClick{
    
}

#pragma mark - getter and setter

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[[NSArray alloc]initWithObjects:@"我的签到",@"打卡签到汇总",@"我的核查工作",@"关于平台",@"清除缓存",@"退出登录",nil];
    }
    return  _titleArray;
}

- (NSArray *)bottomArray{
    if (!_bottomArray) {
        _bottomArray=[[NSArray alloc]initWithObjects:@"历史监督检查及处理情况汇总档案",@"login_phone",@"login_phone",@"login_phone",@"login_phone",@"login_phone",nil];
    }
    return  _bottomArray;
}


//-(UITableView *)tableView{
//    if (!_tableView) {
//        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(30.f, self.headerView.height_mn-50.f, MN_SCREEN_WIDTH-60.f, 350.f) style:UITableViewStylePlain];
//        _tableView.delegate               =self;
//        _tableView.dataSource             =self;
//        _tableView.layer.cornerRadius     =10.f;
//        _tableView.tableFooterView        = [[UIView alloc]init];
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//    }
//    return  _tableView;
//}

#pragma mark - Super
- (MNContentEdges)contentEdges{
    return MNContentEdgeNone;
}

@end

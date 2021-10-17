//
//  GXSMineViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/26.
//

static NSString * cellIdentifier=@"tableCellIdentfier";

#import "GXSMineViewController.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "GXSLoginViewController.h"
#import "GXSUSInfoViewController.h"
#import "GXSMyKaopingViewController.h"
#import "GXSHechaViewController.h"

@interface GXSMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
//titleArray
@property (nonatomic,strong)NSArray *titleArray;
//imageArray
@property (nonatomic,strong)NSArray *imageArray;
//tableView
@property (nonatomic,strong)UITableView *tableView;
//缓存
@property (nonatomic,strong)NSString *cacheStr;
//头视图
@property (nonatomic,strong)MNAdsorbView *headerView;
//用户昵称
@property (nonatomic,strong)UILabel *nameLab;
//头像
@property (nonatomic,strong)UIImageView *userImg;
//用户ID
@property (nonatomic,strong)UILabel *userID;

@end

@implementation GXSMineViewController

#pragma  mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [UIScrollView scrollViewWithFrame:self.contentView.bounds delegate:nil];
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.backgroundColor=[UIColor colorWithHex:@"#F5F6F5"];
    
    UIImage *headerImage = [UIImage imageNamed:@"bg"];
    CGSize headerSize = CGSizeMultiplyToWidth(headerImage.size, scrollView.width_mn);
    MNAdsorbView *headerView = [[MNAdsorbView alloc] initWithFrame:CGRectMake(0.f, 0.f, scrollView.width_mn, headerSize.height)];
    headerView.imageView.image = headerImage;
    self.headerView=headerView;
    [scrollView addSubview:headerView];
    
    //头像
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30.f, 110.f, 50.f, 50.f)];
    imageView.image=[UIImage imageNamed:@"user_img"];
    imageView.layer.cornerRadius=25.f;
    [headerView addSubview:imageView];
    self.userImg=imageView;
    
    //昵称
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right_mn+10.f, imageView.top_mn-5.f, MN_SCREEN_WIDTH-100.f, 20.f)];
    nameLab.text=@"会吃鱼的猫";
    nameLab.font=[UIFont systemFontOfSize:18];
    nameLab.textColor=[UIColor whiteColor];
    [scrollView addSubview:nameLab];
    
    //身份
    UILabel *IDLab=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right_mn+10.f, nameLab.bottom_mn+10.f, MN_SCREEN_WIDTH-100.f, 20.f)];
    IDLab.text=@"网格员";
    IDLab.font=[UIFont systemFontOfSize:15];
    IDLab.textColor=[UIColor whiteColor];
    [scrollView addSubview:IDLab];
    
    [scrollView addSubview:self.tableView];
    
}



#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textLabel.text=self.titleArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.imageView.image=[UIImage imageNamed:self.imageArray[indexPath.row]];
    if (indexPath.row==2) {
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.detailTextLabel.text=@"";
    }else if(indexPath.row==4){
        cell.detailTextLabel.text=self.cacheStr;
    }
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"确定清理缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cleanCache];
            }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(indexPath.row==1){
        GXSLoginViewController *login=[[GXSLoginViewController  alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }else if(indexPath.row==3){
        GXSUSInfoViewController *us=[[GXSUSInfoViewController alloc]init];
        [self.navigationController pushViewController:us animated:YES];
    }else if(indexPath.row==2){
        GXSHechaViewController *kaohe=[[GXSHechaViewController  alloc]init];
        [self.navigationController pushViewController:kaohe animated:YES];
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}



-(void)getCacheSize{
   //得到缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    //首先判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        for (NSString * fileName in childFile) {
            //缓存文件绝对路径
            NSString * absolutPath = [path stringByAppendingPathComponent:fileName];
            size = size + [manager attributesOfItemAtPath:absolutPath error:nil].fileSize;
        }
        //计算sdwebimage的缓存和系统缓存总和
        size = size + [SDImageCache sharedImageCache].totalDiskSize;
    }
    self.cacheStr = [NSString stringWithFormat:@"%.2fM",size / 1024 / 1024];
    [self.tableView reloadData];
}


-(void)cleanCache{
    //获取缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    //判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        //逐个删除缓存文件
        for (NSString *fileName in childFile) {
            NSString * absolutPat = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absolutPat error:nil];
        }
        //删除sdwebimage的缓存
        [[SDImageCache sharedImageCache] clearMemory];
    }
     //这里是又调用了得到缓存文件大小的方法，是因为不确定是否删除了所有的缓存，所以要计算一遍，展示出来
    [self getCacheSize];
}

#pragma mark - getter and setter

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[[NSArray alloc]initWithObjects:@"我的签到",@"打卡签到汇总",@"我的核查工作",@"关于平台",@"清除缓存",@"退出登录",nil];
    }
    return  _titleArray;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray=[[NSArray alloc]initWithObjects:@"me_icon_f",@"me_icon_e",@"me_icon_d",@"me_icon_c",@"me_icon_b",@"me_icon_a",nil];
    }
    return  _imageArray;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(30.f, self.headerView.height_mn-50.f, MN_SCREEN_WIDTH-60.f, 360.f) style:UITableViewStylePlain];
        _tableView.delegate               =self;
        _tableView.dataSource             =self;
        _tableView.layer.cornerRadius     =10.f;
        _tableView.tableFooterView        = [[UIView alloc]init];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return  _tableView;
}

#pragma mark - Super
- (BOOL)isRootViewController {
    return YES;
}

- (NSString *)tabBarItemTitle {
    return @"我的";
}



@end

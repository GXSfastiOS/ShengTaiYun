//
//  GXSAllCompanyViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/12.
//

static NSString * cellIdentifier=@"tableCellIdentfier";

#import "GXSAllCompanyViewController.h"

@interface GXSAllCompanyViewController ()<UISearchBarDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation GXSAllCompanyViewController


#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createView{
    [super createView];
    //搜索
    UIView *searchView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.contentView.width_mn-60.f, 44.f)];
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:searchView.frame];
    searchBar.placeholder=@"可输入编号搜索";
    searchBar.delegate=self;
    UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    barImageView.layer.borderWidth=1;
    [searchView addSubview:searchBar];
    [self.navigationBar.titleView addSubview:searchBar];
    self.navigationBar.tintColor=UIColor.whiteColor;
    
//    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    self.tableView.frame=self.contentView.frame;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.backgroundColor=GXS_THEME_COLOR;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.tableView.width_mn, 80.f)];
    sView.backgroundColor=[UIColor colorWithHex:@"#BDBFC4"];
    UILabel *textLab=[UILabel labelWithFrame:CGRectMake(15.f, 0.f, 20, 20) text:self.dataArray[section] textColor:BG_GARYCOLOR font:UIFontSystem(18.f)];
    [sView addSubview:textLab];
    return sView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.f;
}



#pragma mark -super

- (MNContentEdges)contentEdges{
    return MNContentEdgeTop;
}

- (MNListViewType)listViewType{
    return MNListViewTypeTable;
}


@end

//
//  NewProjectViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/8.
//

static NSString * cellIdentifier=@"GXSNewAddInfoTableViewCellIdentfier";

#import "GXSNewProjectViewController.h"
#import "GXSNewprojectModel.h"
#import "GXSNewAddInfoTableViewCell.h"

@interface GXSNewProjectViewController ()
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation GXSNewProjectViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)createView{
    [super createView];
    self.title=@"新建企业信息";
    self.tableView.frame=self.contentView.frame;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[GXSNewAddInfoTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.tableView.width_mn, 80.f)];
    UIButton *backBtn=[UIButton buttonWithFrame:CGRectMake(15.f, 15.f, (self.tableView.width_mn-45.f)/2, 44.f) image:nil title:@"发回重填" titleColor:UIColor.whiteColor titleFont:UIFontSystem(18.f)];
    backBtn.layer.cornerRadius=22.f;
    backBtn.backgroundColor=GXS_THEME_COLOR;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:backBtn];
    
    UIButton *sumbitBtn=[UIButton buttonWithFrame:CGRectMake(backBtn.right_mn+15.f, 15.f, (self.tableView.width_mn-45.f)/2, 44.f) image:nil title:@"审核通过" titleColor:UIColor.whiteColor titleFont:UIFontSystem(18.f)];
    sumbitBtn.layer.cornerRadius=22.f;
    sumbitBtn.backgroundColor=GXS_THEME_COLOR;
    [sumbitBtn addTarget:self action:@selector(sumbitClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sumbitBtn];
    
    self.tableView.tableFooterView=footerView;
}


#pragma mark -event

- (void)isShowClick:(UIButton *)btn{
    NSInteger section = btn.tag - 666;
    GXSNewprojectModel *model=self.dataArray[section];
    model.isShow=model.isShow ? NO:YES;
    self.dataArray[section] =model;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];

}

- (void)backClick{
    
}

- (void)sumbitClick{
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GXSNewprojectModel *model=self.dataArray[section];
    if (model.isShow) {
        return self.dataArray.count;
    }else{
        return 0;
    }
   
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSNewAddInfoTableViewCell *cell=[[GXSNewAddInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier Title:@"产品"];
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
    return 200.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.tableView.width_mn, 80.f)];
    sView.backgroundColor=[UIColor colorWithHex:@"#BDBFC4"];
//    BOOL isShow=[self.dataArray[section][@"isShow"] boolValue];
    GXSNewprojectModel *model=self.dataArray[section];
    UIButton *btn=[UIButton buttonWithFrame:CGRectMake(15.f, 15.f, self.tableView.width_mn-30.f, 50.f) image:[UIImage imageNamed:model.isShow?@"icon_arrow_up_a":@"icon_arrow_down_b"] title:model.title titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(15.f)];
    //使图片在右边，文字在左边（正常情况下是文字在右边，图片在左边）
    [btn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    //设置图片和文字之间的间隙
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.backgroundColor=UIColor.whiteColor;
    btn.layer.cornerRadius=10.f;
    btn.tag=section+666;
    [btn addTarget:self action:@selector(isShowClick:) forControlEvents:UIControlEventTouchUpInside];
    [sView addSubview:btn];
    return sView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.f;
}



#pragma mark - getter and setter

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"企业基本信息",@"主要生产设备",@"主要原辅材料",@"项目执行标准",@"总量控制标准",@"项目周边情况",@"环境敏感目标",@"企业生产工艺流程及污染排放情况",@"废气排放口",@"废水排放口",@"危废储存场所",@"噪声控制措施",@"附件上传",@"污染物排放量一览表", nil];
        //初始化数据
        for (int i=0; i<titleArray.count; i++) {
            GXSNewprojectModel *model=[[GXSNewprojectModel alloc]init];
            model.title=titleArray[i];
            model.isShow=NO;
            [_dataArray addObject:model];
        }
       
    }
    return _dataArray;
}

#pragma mark - Super

- (MNListViewType)listViewType{
    return  MNListViewTypeTable;
}

- (MNContentEdges)contentEdges {
    return MNContentEdgeTop;
}


@end

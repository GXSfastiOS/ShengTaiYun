//
//  GXSAddprojectViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/8.
//

static NSString *cellId=@"TaskcellID";

#import "GXSAddprojectViewController.h"
#import "ListCellTypeModel.h"
#import "GXSAddTableViewCell.h"

@interface GXSAddprojectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation GXSAddprojectViewController

#pragma  mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView{
    [super createView];
    self.title=@"添加任务";
    [self.view addSubview:self.tableView];
}

#pragma  mark -mothod

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSAddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    ListCellTypeModel *model=self.dataArray[indexPath.row];
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
    return 44.5f;
}


#pragma mark - getter and setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 170.f, MN_SCREEN_WIDTH, self.contentView.bottom_mn-170.f) style:UITableViewStylePlain];
        _tableView.delegate               =self;
        _tableView.dataSource             =self;
        _tableView.tableFooterView        = [[UIView alloc]init];
        _tableView.backgroundColor=UIColor.redColor;
        _tableView.separatorStyle         =UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"GXSAddTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    }
    return  _tableView;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"网格名称",@"企业名称",@"核查人员",@"分管领导",@"任务名称",@"模块核查结果", nil];
        for (int i=0; i<titleArray.count; i++) {
           ListCellTypeModel *model=[[ListCellTypeModel alloc]init];
            model.title=titleArray[i];
            if (i==2||i==3) {
                model.type=typeSelect;
                model.datail=@"请选择";
            }else{
                model.type=typeTextField;
                model.datail=@"请填写";
            }
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

@end

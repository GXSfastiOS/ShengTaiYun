//
//  FMPrejectView.m
//  FMFastMasterPreject
//
//  Created by fenglikejiInfomation on 2021/3/30.
//


static NSString *cellID=@"FMPrejectTableViewCell";
static NSString *allCellID=@"FMAllprojectTableViewCell";

#import "FMPrejectView.h"



@interface FMPrejectView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property  (nonatomic,strong)UITableView *tableView;
@property  (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FMPrejectView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initViewInfo];
    }
    return self;
}

#pragma mark - PrivateMothed

- (void)initViewInfo{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.emptyDataSetSource=self;
    self.tableView.emptyDataSetDelegate=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=ssRGBHex(0XEEEEEE);
    self.tableView.rowHeight = 44.5f;
    self.tableView.backgroundColor=[UIColor redColor];
    [_tableView registerNib:[UINib nibWithNibName:@"GXSAddTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:allCellID];
    [self addSubview:self.tableView];
}

- (void)setCid:(NSInteger)cid{
    _cid=cid;
}





#pragma mark - UITableViewDelegate,UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        return self.dataArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCellTypeModel *model=self.dataArray[indexPath.row];
  
    if (model.type==typeTextField) {
        GXSAddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.model=model;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.detailText.delegate=self;
        cell.detailText.tag=indexPath.row+66;
        return  cell;
    }else{
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:allCellID];
        cell.textLabel.text=model.title;
        cell.detailTextLabel.text=model.datail;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}




#pragma mark - lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.bounds];
        _tableView.backgroundColor=UIColor.whiteColor;
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

#pragma mark - setUpAllView
- (UIView *)listView{
    return self;
}
@end

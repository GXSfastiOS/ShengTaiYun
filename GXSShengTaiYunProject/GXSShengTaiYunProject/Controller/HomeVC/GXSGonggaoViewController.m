//
//  GXSGonggaoViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/9/28.
//

static NSString *cellID=@"gxsGonggaoCellID";

#import "GXSGonggaoViewController.h"
#import "GXSGonggaoTableViewCell.h"

@interface GXSGonggaoViewController ()

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
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[GXSGonggaoTableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSGonggaoTableViewCell *cell=[[GXSGonggaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
      
    }else if(indexPath.row==1){
 
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250.f;
}


#pragma mark - Super

- (MNContentEdges)contentEdges {
    return MNContentEdgeTop;
}

- (MNListViewType)listViewType{
    return  MNListViewTypeTable;
}

@end

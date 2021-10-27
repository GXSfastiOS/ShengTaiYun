//
//  GXSMySignViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/27.
//

static NSString * cellIdentifier=@"StableCellIdentfier";
static NSString *collectionCellid=@"HXhomecollectionCellid";

#import "GXSMySignViewController.h"
#import "GXSSignCollectionViewCell.h"
#import "MineSignModel.h"

@interface GXSMySignViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSDictionary *dataArray;
@property (nonatomic,strong)UITableView *tableView;
//collectionView
@property (nonatomic,strong)UICollectionView *collectionView;
@end

@implementation GXSMySignViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)createView{
    [super createView];
    self.title=@"我的签到";
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.collectionView];
    [self getData];
}

- (void)getData{
    GXSHTTPDataRequest *requst=[[GXSHTTPDataRequest alloc]init];
    requst.cachePolicy = MNURLDataCachePolicyNever;
    requst.method = MNURLHTTPMethodPost;
    requst.url=URL_HANDING(@"/app/qiandao/qiandao_show");
//    requst.body=@{@"date":@"",@"member_id":[[GXSUser shareInfo] uid],@"token":[[GXSUser shareInfo] token]};
    requst.body=@{@"date":@"2021-10-13",@"member_id":@"10000",@"token":@"777777"};
    @weakify(self);
    [requst loadData:^{
        @strongify(self);
        [self.view showActivityDialog:@"请稍后"];
    } completion:^(MNURLResponse * _Nonnull response) {
        if (response.code==MNURLResponseCodeSucceed) {
            [self.view closeDialog];
            self.dataArray=response.data[@"info"];
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }else{
            [self.view showErrorDialog:response.message];
        }
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (indexPath.row==0) {
        cell.textLabel.text=@"网格";
        cell.detailTextLabel.text=self.dataArray[@"wangge_name"];
    }else if (indexPath.row==1){
        cell.textLabel.text=@"网格员";
        cell.detailTextLabel.text=self.dataArray[@"name"];
    }else{
        cell.textLabel.text=@"分管领导";
        cell.detailTextLabel.text=self.dataArray[@"lingdao_name"];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return  cell;
}

#pragma  mark -UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *data=self.dataArray[@"daka_list"];
    if (data.count>0) {
        return data.count+1;
    }
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GXSSignCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    NSArray *data=self.dataArray[@"daka_list"];
    if (indexPath.row==data.count) {
        MineSignModel *model=[[MineSignModel alloc]init];
        model.daka_name=@"点击此处添加文本";
        cell.model=model;
    }else{
        MineSignModel *model=[MineSignModel yy_modelWithDictionary:data[indexPath.row]];
        cell.model=model;
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data=self.dataArray[@"daka_list"];
    if (indexPath.row==data.count) {
        
    }
}

#pragma mark - getter and setter

- (NSDictionary *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSDictionary alloc]init];
    }
    return  _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, MN_SCREEN_WIDTH, 135.f) style:UITableViewStylePlain];
        _tableView.delegate               =self;
        _tableView.dataSource             =self;
        _tableView.tableFooterView        = [[UIView alloc]init];
        _tableView.separatorStyle         =UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return  _tableView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layuot=[[UICollectionViewFlowLayout alloc]init];
        layuot.itemSize=CGSizeMake(self.contentView.width_mn/2.2f, 200.f);
        layuot.minimumLineSpacing = 5.0;
        layuot.minimumInteritemSpacing = 5.0;
        layuot.sectionInset = UIEdgeInsetsMake(0.0, 8.0, 0.0, 10.0);
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layuot];
        _collectionView.frame=CGRectMake(0.f,self.tableView.height_mn+10.f, self.contentView.width_mn,self.contentView.height_mn-145.f);
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor=UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"GXSSignCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionCellid];
        
    }
    return  _collectionView;
}

#pragma mark -super

- (MNContentEdges)contentEdges{
    return MNContentEdgeTop;
}



@end

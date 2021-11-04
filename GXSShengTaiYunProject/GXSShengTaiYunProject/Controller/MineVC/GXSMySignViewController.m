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

@interface GXSMySignViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UITextFieldDelegate, UICollectionViewDataSource>
@property (nonatomic,strong)NSDictionary *dataArray;
@property (nonatomic,strong)UITableView *tableView;
//collectionView
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSString *dakeText;
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
        if (self.image) {
            model.daka_img=self.image;
        }
        cell.model=model;
        cell.textField.delegate=self;
    }else{
        MineSignModel *model=[MineSignModel yy_modelWithDictionary:data[indexPath.row]];
        cell.model=model;
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data=self.dataArray[@"daka_list"];
    if (indexPath.row==data.count) {
        // 创建UIImagePickerController实例
       UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
       // 设置代理
       imagePickerController.delegate = self;
       // 是否显示裁剪框编辑（默认为NO），等于YES的时候，照片拍摄完成可以进行裁剪
       imagePickerController.allowsEditing = YES;
       // 设置照片来源为相机
       imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
       // 设置进入相机时使用前置或后置摄像头
       imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
       // 展示选取照片控制器
       [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image = image;
    [self.collectionView reloadData];
//    // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
//    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
//    // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
//    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
}

// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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

//
//  GXSAddprojectViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/8.
//

static NSString *cellId=@"TextFieldcellID";
static NSString *scellId=@"SelectCellID";

#import "GXSAddprojectViewController.h"
#import "ListCellTypeModel.h"
#import "GXSAddTableViewCell.h"
#import "TAProfileSelectCell.h"
#import "TAProfileSelectModel.h"

@interface GXSAddprojectViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,TAProfileSelectDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
/**文字编辑*/
@property (nonatomic, strong) MNTextView *textView;
/**图片编辑*/
@property (nonatomic, strong) UICollectionView *profileView;
/**配图模型<包括添加项>*/
@property (nonatomic, strong) NSMutableArray <TAProfileSelectModel *>*profiles;
/**添加图片*/
@property (nonatomic, strong) TAProfileSelectModel *lastProfile;
/**发布*/
@property (nonatomic, strong) UIButton *sumbitBtn;
/**网格*/
@property (nonatomic, strong) NSString *wanggeText;
/**企业*/
@property (nonatomic, strong) NSString *qiyeText;
/**核查*/
@property (nonatomic, strong) NSString *hechaText;
/**分管*/
@property (nonatomic, strong) NSString *fenguanText;
/**任务*/
@property (nonatomic, strong) NSString *renwuText;
/**模块*/
@property (nonatomic, strong) NSString *mokuaiText;

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
    
    UIScrollView *scrollView = [UIScrollView scrollViewWithFrame:self.contentView.bounds delegate:nil];
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView addSubview:self.tableView];
    
    UILabel *taskDetaillab=[UILabel labelWithFrame:CGRectMake(15.f,self.tableView.bottom_mn+20.f, 80.f, 15.f) text:@"任务描述" textColor:UIColor.blackColor font:UIFontSystem(17.f)];
    [scrollView addSubview:taskDetaillab];
    
    UIView *taskBg=[[UIView alloc]initWithFrame:CGRectMake(15.f, taskDetaillab.bottom_mn+15.f, scrollView.width_mn - 30.f,  115.f)];
    taskBg.backgroundColor=[UIColor grayColor];
    taskBg.layer.cornerRadius=10.f;
    [scrollView addSubview:taskBg];
    
    // 文字输入区域
    MNTextView *textView = [[MNTextView alloc] initWithFrame:CGRectMake(0.f, 0.f, taskBg.width_mn - 20.f, 115.f)];
//    textView.handler = self;
    textView.expandHeight = 181.f;
    textView.centerX_mn = taskBg.width_mn/2.f;
    textView.placeholder =@"请输入内容";
    textView.placeholderColor = MN_RGB(181.f);
    textView.tintColor = THEME_COLOR;
    textView.font = UIFontRegular(16.f);
    textView.textColor = UIColor.darkTextColor;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.returnKeyType = UIReturnKeyDone;
    textView.backgroundColor = UIColor.grayColor;
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.textContainer.lineFragmentPadding = 0.f;
    [taskBg addSubview:textView];
    self.textView = textView;
    
    UILabel *phoneLab=[UILabel labelWithFrame:CGRectMake(15.f,taskBg.bottom_mn+20.f, 80.f, 15.f) text:@"拍照上传" textColor:UIColor.blackColor font:UIFontSystem(17.f)];
    [scrollView addSubview:phoneLab];
    
    self.lastProfile = TAProfileSelectModel.lastProfile;
    self.profiles = @[self.lastProfile].mutableCopy;
    CGFloat interval = 10.f;
    CGFloat wh = (textView.width_mn - interval*2.f)/3.f;
    
    MNCollectionVerticalLayout *layout = MNCollectionVerticalLayout.layout;
    layout.numberOfFormation = 3;
    layout.minimumLineSpacing = interval;
    layout.minimumInteritemSpacing = interval;
    layout.itemSize = CGSizeMake(wh, wh);
    
    UICollectionView *profileView = [UICollectionView collectionViewWithFrame:CGRectMake(taskBg.left_mn, phoneLab.bottom_mn + 15.f, taskBg.width_mn, wh) layout:layout];
    profileView.delegate = self;
    profileView.dataSource = self;
    profileView.scrollEnabled = NO;
    profileView.clipsToBounds = NO;
    profileView.touchInset = UIEdgeInsetWith(-10.f);
    profileView.showsVerticalScrollIndicator = NO;
    profileView.showsHorizontalScrollIndicator = NO;
    profileView.backgroundColor = UIColor.whiteColor;
    profileView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [profileView registerClass:TAProfileSelectCell.class forCellWithReuseIdentifier:MNCollectionElementCellReuseIdentifier];
    [scrollView addSubview:profileView];
    self.profileView = profileView;
    
    //发布
    UIButton *sumbitBtn=[UIButton buttonWithFrame:CGRectZero image:nil title:@"登录" titleColor:UIColor.whiteColor titleFont:UIFontSystem(12.f)];
    sumbitBtn.backgroundColor=GXS_THEME_COLOR;
    sumbitBtn.height_mn=40.f;
    sumbitBtn.top_mn=self.profileView.bottom_mn+15.f;
    sumbitBtn.left_mn=15.f;
    sumbitBtn.width_mn=scrollView.width_mn-30.f;
    sumbitBtn.layer.cornerRadius=20.f;
    [sumbitBtn addTarget:self action:@selector(sumbitInfo) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sumbitBtn];
    self.sumbitBtn=sumbitBtn;
}

#pragma  mark -mothod


#pragma  mark -event

- (void)sumbitInfo{
    
}

#pragma mark - UICollectionViewDelegate&UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.profiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:MNCollectionElementCellReuseIdentifier forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(TAProfileSelectCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.profile = self.profiles[indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.profiles.count) return;
    TAProfileSelectModel *model = self.profiles[indexPath.item];
    if (model.isLast == NO) return;
    [self selectAssetWithType:MNAssetTypePhoto];
}


- (void)selectAssetWithType:(MNAssetType)type {
    MNAssetPicker *picker = MNAssetPicker.new;
    picker.configuration.allowsMixPicking = NO;
    picker.configuration.allowsPreviewing = NO;
    picker.configuration.allowsAutoDismiss = YES;
    picker.configuration.allowsCapturing = NO;
    picker.configuration.allowsPickingGif = NO;
    picker.configuration.allowsPickingLivePhoto = NO;
    picker.configuration.showPickingNumber = YES;
    picker.configuration.allowsDisplayFileSize = YES;
    picker.configuration.allowsOriginalExporting = YES;
    if (type == MNAssetTypePhoto) {
        picker.configuration.allowsPickingPhoto = YES;
        picker.configuration.allowsPickingVideo = NO;
        picker.configuration.requestGifUseingPhotoPolicy = YES;
        picker.configuration.requestLivePhotoUseingPhotoPolicy = YES;
        picker.configuration.allowsEditing = NO;
        picker.configuration.maxExportPixel = 2000;
        picker.configuration.maxPickingCount = 10 - self.profiles.count;
    }
//    } else {
//        picker.configuration.allowsEditing = YES;
//        picker.configuration.maxPickingCount = 1;
//        picker.configuration.allowsPickingVideo = YES;
//        picker.configuration.allowsPickingPhoto = NO;
//        picker.configuration.allowsResizeVideoSize = NO;
//        picker.configuration.minExportDuration = 3.f;
//        picker.configuration.maxExportDuration = 60.f;
//    }
    @weakify(self);
    [picker presentInController:self pickingHandler:^(MNAssetPicker * _Nonnull picker, NSArray<MNAsset *> * _Nullable assets) {
        [weakself insertProfiles:assets type:type];
    } cancelHandler:nil];
}

- (void)insertProfiles:(NSArray <MNAsset *>*)assets type:(MNAssetType)type {
    NSMutableArray <TAProfileSelectModel *>*profiles = @[].mutableCopy;
    [assets enumerateObjectsUsingBlock:^(MNAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [profiles addObject:[TAProfileSelectModel modelWithAsset:obj]];
    }];
 
    [self.profiles removeLastObject];
    [self.profiles addObjectsFromArray:profiles];
    if (self.profiles.count < 9) [self.profiles addObject:self.lastProfile];
    [self.tableView reloadData];
    [self.profileView reloadData];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    MNCollectionVerticalLayout *layout = (MNCollectionVerticalLayout *)self.profileView.collectionViewLayout;
    NSInteger row = (NSInteger)(self.profiles.count/3);
    NSInteger remainder = self.profiles.count%3;
    if (remainder > 0) row++;
    CGFloat collectionHeight = layout.itemSize.height*(CGFloat)row + layout.minimumInteritemSpacing*(CGFloat)(row - 1);
    CGFloat m = collectionHeight - self.profileView.height_mn;
    if (fabs(m) < 1.f) return;
    if (m > 0.f) {
        self.profileView.height_mn += m;
        self.sumbitBtn.top_mn=self.profileView.bottom_mn+15.f;
        self.scrollView.contentSize=CGSizeMake(self.scrollView.width_mn, self.sumbitBtn.bottom_mn+15.f);
//        self.tableView.tableHeaderView = self.headerView;
    } else {
        [UIView animateWithDuration:.3f animations:^{
            self.profileView.height_mn += m;
            self.sumbitBtn.top_mn=self.profileView.bottom_mn+15.f;
            self.scrollView.contentSize=CGSizeMake(self.scrollView.width_mn, self.sumbitBtn.bottom_mn+15.f);
        } completion:^(BOOL finished) {
//            self.tableView.tableHeaderView = self.headerView;
        }];
    }
}


#pragma mark - TAProfileSelectDelegate
- (void)profileCellDeleteButtonTouchUpInside:(TAProfileSelectCell *)cell {
    NSIndexPath *indexPath = [cell.collectionView indexPathForCell:cell];
    if (!indexPath || indexPath.item >= self.profiles.count) return;
    [self.profiles removeObjectAtIndex:indexPath.item];
    if (self.profiles.count > 0 && self.profiles.lastObject.isLast) {
        [self.profileView deleteItemsAtIndexPaths:@[indexPath]];
    } else {
        [self.profiles addObject:self.lastProfile];
        [self.profileView reloadData];
    }
    if (self.profiles.firstObject.isLast) {
        [self.tableView reloadData];
    }
    [self layoutSubviews];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListCellTypeModel *model=self.dataArray[indexPath.row];
  
    if (model.type==typeTextField) {
        GXSAddTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        cell.model=model;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.detailText.delegate=self;
        cell.detailText.tag=indexPath.row+66;
        return  cell;
    }else{
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:scellId];
        cell.textLabel.text=model.title;
        cell.detailTextLabel.text=model.datail;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return  cell;
    }
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array=[[NSArray alloc]initWithObjects:@"选择网格",@"选择",@"网格",@"选择网格", nil];
    if (indexPath.row==2) {
        ListCellTypeModel *model=self.dataArray[indexPath.row];
        @weakify(self);
        MNActionSheet *sheet=[[MNActionSheet alloc]initWithTitle:@"选择网格" cancelButtonTitle:@"取消" otherButtonTitles:array handler:^(MNActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            @strongify(self);
            NSLog(@"%@",actionSheet.title);
            model.datail=array[buttonIndex];
            self.hechaText=array[buttonIndex];
            [self.tableView reloadData];
        }];
        [sheet show];
    }else if(indexPath.row==3){
        ListCellTypeModel *model=self.dataArray[indexPath.row];
        @weakify(self);
        MNActionSheet *sheet=[[MNActionSheet alloc]initWithTitle:@"选择网格" cancelButtonTitle:@"取消" otherButtonTitles:array handler:^(MNActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            @strongify(self);
            NSLog(@"%@",actionSheet.title);
            model.datail=array[buttonIndex];
            self.fenguanText=array[buttonIndex];
            [self.tableView reloadData];
        }];
        [sheet show];
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.5f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger t=textField.tag-66;
    switch (t) {
        case 0:
            self.wanggeText=textField.text;
            break;
        case 1:
            self.qiyeText=textField.text;
            break;
        case 4:
            self.renwuText=textField.text;
            break;
        case 5:
            self.mokuaiText=textField.text;
            break;
        default:
            break;
    }
}

#pragma mark - getter and setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, MN_SCREEN_WIDTH, 280.f) style:UITableViewStylePlain];
        _tableView.delegate               =self;
        _tableView.dataSource             =self;
        _tableView.tableFooterView        = [[UIView alloc]init];
        _tableView.separatorStyle         =UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"GXSAddTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:scellId];
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

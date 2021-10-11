//
//  GXSMyKaopingViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/11.
//

#import "GXSMyKaopingViewController.h"
#import "GXSKaoheListViewController.h"

@interface GXSMyKaopingViewController ()<MNSegmentControllerDelegate,MNSegmentControllerDataSource>
@property  (nonatomic, strong) MNSegmentController *segmentController;
@property  (nonatomic,strong)NSMutableArray *typeArray;
@end

@implementation GXSMyKaopingViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView{
    [super createView];
    self.title=@"我的考评";
    [self addChildViewController:self.segmentController inView:self.contentView];
}

#pragma mark - MNSegmentControllerDelegate && MNSegmentControllerDataSource
- (void)segmentControllerInitializedConfiguration:(MNSegmentConfiguration *)configuration {
    configuration.height = 43.f;
    configuration.titleMargin = 40.f;
//    configuration.shadowSize = CGSizeMake(17.f, 6.5);
    configuration.contentMode = MNSegmentContentModeFill;
    configuration.scrollPosition = MNSegmentScrollPositionCenter;
    configuration.shadowMask = MNSegmentShadowMaskFit;
    configuration.titleFont = [UIFont systemFontOfSize:14.5f];
    configuration.titleColor = ssRGBHex(0X999999);
    configuration.selectedColor = UIColor.blackColor;
    configuration.shadowColor = UIColor.blackColor;
    configuration.separatorColor = UIColor.whiteColor;
}

- (NSArray <NSString *>*)segmentControllerShouldLoadPageTitles:(MNSegmentController *)segmentController {
    return self.typeArray;
}

- (UIViewController *)segmentController:(MNSegmentController *)segmentController childControllerOfPageIndex:(NSUInteger)pageIndex {
    GXSKaoheListViewController *vc = [[GXSKaoheListViewController alloc] initWithFrame:segmentController.view.bounds cid:1];
    return vc;
}


#pragma mark - Getter
- (MNSegmentController *)segmentController {
    if (!_segmentController) {
        MNSegmentController *segmentController = [[MNSegmentController alloc] initWithFrame:self.contentView.bounds];
        segmentController.delegate = self;
        segmentController.dataSource = self;
        _segmentController = segmentController;
    }
    return _segmentController;
}

- (NSMutableArray *)typeArray{
    if (!_typeArray) {
        _typeArray=[[NSMutableArray alloc]initWithObjects:@"当月",@"当季",@"当年", nil];
    }
    return _typeArray;
}



#pragma mark - Super
- (MNContentEdges)contentEdges{
    return MNContentEdgeTop;
}


@end

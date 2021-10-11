//
//  GXSShengTaiHeChaViewController.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/11.
//

#import "GXSShengTaiHeChaViewController.h"

@interface GXSShengTaiHeChaViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *dataArray;
/**发布*/
@property (nonatomic, strong) UIButton *sumbitBtn;
/**文字编辑*/
@property (nonatomic, strong) MNTextView *textView;
@end

@implementation GXSShengTaiHeChaViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView{
    [super createView];
    
    self.title=@"生态环境核查";
    
    UIScrollView *scrollView = [UIScrollView scrollViewWithFrame:self.contentView.bounds delegate:nil];
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor=BG_GARYCOLOR;
   
    UIButton *topBtn=[UIButton buttonWithFrame:CGRectMake(15.f, 15.f, self.contentView.width_mn-30.f, 50.f) image:[UIImage imageNamed:@"icon_arrow_right_b"] title:@"基本情况表" titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(15.f)];
    //使图片在右边，文字在左边（正常情况下是文字在右边，图片在左边）
    [topBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    //设置图片和文字之间的间隙
    topBtn.imageEdgeInsets = UIEdgeInsetsMake(0, topBtn.width_mn-100.f, 0, 0);
    topBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -topBtn.width_mn+100.f, 0, 0);
    topBtn.backgroundColor=UIColor.whiteColor;
    topBtn.layer.cornerRadius=10.f;
    [topBtn addTarget:self action:@selector(jibenClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:topBtn];
    
    for (int i=0; i<self.dataArray.count; i++) {
        CGFloat width=(self.contentView.width_mn-45.f)/2;
        
        UIButton *btn=[UIButton buttonWithFrame:CGRectMake(i%2*(width+15.f)+15.f,i/2*65.f+80.f, width, 50.f) image:[UIImage imageNamed:@"icon_arrow_right_b"] title:self.dataArray[i] titleColor:GXS_THEME_COLOR titleFont:UIFontSystem(15.f)];
        //使图片在右边，文字在左边（正常情况下是文字在右边，图片在左边）
        [btn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        //设置图片和文字之间的间隙
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 20.f, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20.f, 0, 0);
        btn.backgroundColor=UIColor.whiteColor;
        btn.layer.cornerRadius=10.f;
        btn.tag=i+777;
        [btn addTarget:self action:@selector(otherClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.height_mn=500.f;
    bottomView.top_mn=405.f;
    bottomView.left_mn=15.f;
    bottomView.width_mn=scrollView.width_mn-30.f;
    bottomView.layer.cornerRadius=10.f;
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:bottomView];
    
    UILabel *nameLab=[UILabel labelWithFrame:CGRectMake(10.f, 20.f, 90.f, 15.f) text:@"公司名称" textColor:UIColor.blackColor font:UIFontSystem(17.f)];
    [bottomView addSubview:nameLab];
    
    MNTextField *nameText=[MNTextField textFieldWithFrame:CGRectZero font:UIFontSystem(17.f) placeholder:@"请填写" delegate:nil];
    nameText.borderStyle=UITextBorderStyleNone;
    [bottomView addSubview:nameText];
    [nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-10.f);
        make.centerY.mas_equalTo(nameLab.mas_centerY);
    }];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(5.f, nameLab.bottom_mn+15.f, bottomView.width_mn-5.f, 0.5f)];
    line.backgroundColor=BG_GARYCOLOR;
    [bottomView addSubview:line];
    
    UILabel *taskLab=[UILabel labelWithFrame:CGRectMake(10.f,line.bottom_mn+15.f, 90.f, 15.f) text:@"任务名称" textColor:UIColor.blackColor font:UIFontSystem(17.f)];
    [bottomView addSubview:taskLab];
    
    MNTextField *taskText=[MNTextField textFieldWithFrame:CGRectZero font:UIFontSystem(17.f) placeholder:@"请填写" delegate:nil];
    taskText.borderStyle=UITextBorderStyleNone;
    [bottomView addSubview:taskText];
    [taskText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-10.f);
        make.centerY.mas_equalTo(taskLab.mas_centerY);
    }];
    
    UIView *taskLine=[[UIView alloc]initWithFrame:CGRectMake(5.f, taskLab.bottom_mn+15.f, bottomView.width_mn-5.f, 0.5f)];
    taskLine.backgroundColor=BG_GARYCOLOR;
    [bottomView addSubview:taskLine];
    
    UILabel *taskDetaillab=[UILabel labelWithFrame:CGRectMake(10.f,taskLine.bottom_mn+20.f, 80.f, 15.f) text:@"任务描述" textColor:UIColor.blackColor font:UIFontSystem(17.f)];
    [bottomView addSubview:taskDetaillab];
    
    UIView *taskBg=[[UIView alloc]initWithFrame:CGRectMake(15.f, taskDetaillab.bottom_mn+15.f, bottomView.width_mn - 30.f,  115.f)];
    taskBg.backgroundColor=[UIColor grayColor];
    taskBg.layer.cornerRadius=10.f;
    [bottomView addSubview:taskBg];
    
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
    
    UILabel *guanliLab=[UILabel labelWithFrame:CGRectMake(10.f,taskBg.bottom_mn+15.f, 90.f, 15.f) text:@"选择管理员" textColor:UIColor.blackColor font:UIFontSystem(17.f)];
    [bottomView addSubview:guanliLab];
    
    UIButton *guanliBtn=[UIButton buttonWithFrame:CGRectMake(bottomView.width_mn-95.f,guanliLab.top_mn, 80.f, 20.f) image:[UIImage imageNamed:@"icon_arrow_right_b"] title:@"请选择" titleColor:BG_GARYCOLOR titleFont:UIFontSystem(15.f)];
    //使图片在右边，文字在左边（正常情况下是文字在右边，图片在左边）
    [guanliBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    //设置图片和文字之间的间隙
    guanliBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10.f, 0, 0);
    guanliBtn.backgroundColor=UIColor.whiteColor;
    [guanliBtn addTarget:self action:@selector(guanliClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:guanliBtn];
    
    UIView *guanliLine=[[UIView alloc]initWithFrame:CGRectMake(5.f, guanliBtn.bottom_mn+15.f, bottomView.width_mn-5.f, 0.5f)];
    guanliLine.backgroundColor=BG_GARYCOLOR;
    [bottomView addSubview:guanliLine];
    
    UILabel *phoneLab=[UILabel labelWithFrame:CGRectMake(15.f,guanliLine.bottom_mn+20.f, 80.f, 15.f) text:@"拍照上传" textColor:UIColor.blackColor font:UIFontSystem(17.f)];
    [bottomView addSubview:phoneLab];
    
    //发布
    UIButton *sumbitBtn=[UIButton buttonWithFrame:CGRectZero image:nil title:@"登录" titleColor:UIColor.whiteColor titleFont:UIFontSystem(12.f)];
    sumbitBtn.backgroundColor=GXS_THEME_COLOR;
    sumbitBtn.height_mn=40.f;
    sumbitBtn.top_mn=bottomView.bottom_mn+15.f;
    sumbitBtn.left_mn=15.f;
    sumbitBtn.width_mn=scrollView.width_mn-30.f;
    sumbitBtn.layer.cornerRadius=20.f;
    [sumbitBtn addTarget:self action:@selector(sumbitInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:sumbitBtn];
    self.sumbitBtn=sumbitBtn;
    self.scrollView.contentSize=CGSizeMake(self.contentView.width_mn, sumbitBtn.bottom_mn+50.f);
}

#pragma mark -event

- (void)jibenClick{
    
}

- (void)sumbitInfo{
    
}

- (void)guanliClick{
    
}

- (void)otherClick:(UIButton *)btn{
    switch (btn.tag-777) {
        case 0:
             
            break;
            
        default:
            break;
    }
}

#pragma mark - getter and setter

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]initWithObjects:@"网格名称",@"企业名称",@"核查人员",@"分管领导",@"任务名称",@"模块核查结果",@"网格名称",@"网格名称",@"网格名称",@"网格名称", nil];
        
    }
    return  _dataArray;
}
#pragma mark -super

- (MNContentEdges)contentEdges{
    return MNContentEdgeTop;
}

@end

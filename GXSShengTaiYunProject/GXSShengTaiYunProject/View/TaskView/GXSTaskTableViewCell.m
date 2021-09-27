//
//  GXSTaskTableViewCell.m
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/9/27.
//

#import "GXSTaskTableViewCell.h"

@implementation GXSTaskTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size{
//    if (!self) {
//        self=[super initWithStyle:style reuseIdentifier:reuseIdentifier size:size];
//        [self setUpCell];
//    }
//    return self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self) {
        self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell{
    self.backgroundColor=UIColor.whiteColor;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(15.f, 10.f,MN_SCREEN_WIDTH-30.f, 124.f)];
    view.layer.cornerRadius=8.f;
    view.backgroundColor=UIColor.redColor;
    [self addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

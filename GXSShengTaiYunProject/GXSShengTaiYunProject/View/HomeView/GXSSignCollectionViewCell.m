//
//  GXSSignCollectionViewCell.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/27.
//

#import "GXSSignCollectionViewCell.h"


@interface  GXSSignCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dakeLab;
@property (weak, nonatomic) IBOutlet UIImageView *dakaImg;
@property (weak, nonatomic) IBOutlet UILabel *dakaAddress;

@end

@implementation GXSSignCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MineSignModel *)model{
    if ([model.daka_name isEqualToString:@"点击此处添加文本"]) {
        self.dakeLab.text=[NSString stringWithFormat:@"打卡%@次",@"0"];
        self.dakaAddress.hidden=YES;
        self.textField.hidden=NO;
        self.dakaImg.image=model.daka_img?model.daka_img:[UIImage imageNamed:@"icon_defaultimg"];
    }else{
        self.dakeLab.text=[NSString stringWithFormat:@"打卡%@次",model.daka_id];
        self.dakaAddress.hidden=NO;
        self.textField.hidden=YES;
        self.dakaAddress.text=model.daka_name;
        [self.dakaImg sd_setImageWithURL:[NSURL URLWithString:model.daka_pic] placeholderImage:[UIImage imageNamed:@"bg"]];
    }
    
}

@end

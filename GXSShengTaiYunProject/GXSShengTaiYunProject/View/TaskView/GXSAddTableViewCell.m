//
//  GXSAddTableViewCell.m
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/8.
//

#import "GXSAddTableViewCell.h"

@interface  GXSAddTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *detailText;

@end

@implementation GXSAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ListCellTypeModel *)model{
    self.titleLab.text=model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

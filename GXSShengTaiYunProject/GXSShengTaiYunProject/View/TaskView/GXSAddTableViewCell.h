//
//  GXSAddTableViewCell.h
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/8.
//

#import "MNTableViewCell.h"
#import "ListCellTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXSAddTableViewCell : MNTableViewCell
@property(nonatomic,strong)ListCellTypeModel *model;
@property (weak, nonatomic) IBOutlet UITextField *detailText;
@end

NS_ASSUME_NONNULL_END

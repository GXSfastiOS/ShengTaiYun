//
//  GXSSignCollectionViewCell.h
//  GXSShengTaiYunProject
//
//  Created by fenglikejiInfomation on 2021/10/27.
//

#import "MNCollectionViewCell.h"
#import "MineSignModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GXSSignCollectionViewCell : MNCollectionViewCell
@property (nonatomic,strong)MineSignModel *model;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

NS_ASSUME_NONNULL_END

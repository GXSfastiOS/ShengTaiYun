//
//  GXSTaskTableViewCell.h
//  GXSShengTaiYunProject
//
//  Created by guoxianshudeMac on 2021/9/27.
//

#import "MNTableViewCell.h"
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXSTaskTableViewCell : MNTableViewCell
//model
@property (nonatomic,strong)TaskModel *model;
@end

NS_ASSUME_NONNULL_END

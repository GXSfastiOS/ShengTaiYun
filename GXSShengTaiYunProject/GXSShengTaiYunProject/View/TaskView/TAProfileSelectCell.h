//
//  TAProfileSelectCell.h
//  TeamAlbum
//
//  Created by Vicent on 2020/9/9.
//

#import "MNCollectionViewCell.h"
@class TAProfileSelectModel, TAProfileSelectCell;

@protocol TAProfileSelectDelegate <NSObject>
@optional;
- (void)profileCellDeleteButtonTouchUpInside:(TAProfileSelectCell *_Nonnull)cell;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TAProfileSelectCell : MNCollectionViewCell

/**配图数据*/
@property (nonatomic, strong) TAProfileSelectModel *profile;

@end

NS_ASSUME_NONNULL_END

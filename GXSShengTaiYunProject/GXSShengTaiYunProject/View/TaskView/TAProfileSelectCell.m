//
//  TAProfileSelectCell.m
//  TeamAlbum
//
//  Created by Vicent on 2020/9/9.
//

#import "TAProfileSelectCell.h"
#import "TAProfileSelectModel.h"
#import "UIImageView+WebCache.h"

@interface TAProfileSelectCell ()
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *badgeView;
@end

@implementation TAProfileSelectCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.clipsToBounds = NO;
        self.contentView.touchInset = UIEdgeInsetWith(-10.f);
        
        self.touchInset = UIEdgeInsetWith(-10.f);
        
        self.imageView.frame = self.contentView.bounds;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        UIImageView *badgeView = [UIImageView imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"main_video_badge"]];
        badgeView.hidden = YES;
        badgeView.size_mn = CGSizeMake(30.f, 30.f);
        badgeView.userInteractionEnabled = NO;
        [self.contentView addSubview:badgeView];
        self.badgeView = badgeView;
        
        UIButton *deleteButton = [UIButton buttonWithFrame:CGRectZero image:[UIImage imageNamed:@"paste_delete"] title:nil titleColor:nil titleFont:nil];
        deleteButton.hidden = YES;
        deleteButton.size_mn = CGSizeMake(20.f, 20.f);
        deleteButton.touchInset = UIEdgeInsetWith(-3.f);
        [deleteButton addTarget:self action:@selector(deleteButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteButton];
        self.deleteButton = deleteButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.badgeView.center_mn = self.contentView.bounds_center;
    self.deleteButton.top_mn = -6.f;
    self.deleteButton.right_mn = self.contentView.width_mn + 6.f;
}

- (void)setProfile:(TAProfileSelectModel *)profile {
    self.deleteButton.hidden = profile.isLast;
    self.badgeView.hidden = profile.type == TAProfileTypePhoto;
    if (profile.thumbnail) {
        self.imageView.image = profile.thumbnail;
    } else if (profile.preview) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:profile.preview]];
    } else {
        self.imageView.image = nil;
    }
}

- (void)deleteButtonTouchUpInside {
    id viewController = self.viewController;
    if (viewController && [viewController conformsToProtocol:@protocol(TAProfileSelectDelegate)] && [viewController respondsToSelector:@selector(profileCellDeleteButtonTouchUpInside:)]) {
        [viewController profileCellDeleteButtonTouchUpInside:self];
    }
}

@end

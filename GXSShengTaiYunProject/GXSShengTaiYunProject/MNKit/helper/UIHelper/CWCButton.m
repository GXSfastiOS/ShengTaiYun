//
//  CWCButton.m
//  CustomWaterCamera
//
//  Created by chaowen deng on 2021/7/28.
//

#import "CWCButton.h"

@implementation CWCButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleFrame = CGRectNull;
        self.imageFrame = CGRectNull;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (CGRectIsNull(self.imageFrame)) {
        return [super imageRectForContentRect:contentRect];
    }
    return self.imageFrame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (CGRectIsNull(self.titleFrame)) {
        return [super titleRectForContentRect:contentRect];
    }
    return self.titleFrame;
}

@end

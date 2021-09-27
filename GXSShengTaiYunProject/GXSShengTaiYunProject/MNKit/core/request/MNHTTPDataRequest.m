//
//  MNHTTPDataRequest.m
//  MNKit
//
//  Created by Vincent on 2018/11/21.
//  Copyright © 2018年 小斯. All rights reserved.
//

#import "MNHTTPDataRequest.h"

@interface MNHTTPDataRequest ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MNHTTPDataRequest
- (void)initialized {
    [super initialized];
    _page = 1;
    _more = NO;
    _pagingEnabled = NO;
    _dataArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)loadData:(MNURLRequestStartCallback)startCallback completion:(MNURLRequestFinishCallback)finishCallback {
    [self handQuery];
    [self handBody];
    [self handHeaderField];
    [super loadData:startCallback completion:finishCallback];
}

- (void)didSucceedWithResponseObject:(id)responseObject {
    [super didSucceedWithResponseObject:responseObject];
    if (_page == 1) [self cleanMemory];
}

- (void)handQuery {}

- (void)handBody {}

- (void)handHeaderField {}

- (void)prepareReloadData {
    _page = 1;
}

- (BOOL)isDataEmpty {
    return (!_dataArray || _dataArray.count <= 0);
}

- (void)cleanMemory {
    if (_dataArray) [_dataArray removeAllObjects];
}

@end

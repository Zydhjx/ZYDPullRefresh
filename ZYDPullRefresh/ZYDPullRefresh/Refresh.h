//
//  Refresh.h
//  Refresh
//
//  Created by ZYD on 15/8/24.
//  Copyright (c) 2015年 SuperMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Refresh : UIView

//回调
@property (nonatomic, copy) void(^startAction)();

//创建上拉刷新实例
- (instancetype)initWithTableView:(UITableView *)tableView;

//数据下载完成时刷新UI调用
- (void)finishRefresh;



@end

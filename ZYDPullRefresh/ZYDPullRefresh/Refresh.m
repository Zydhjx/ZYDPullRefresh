//
//  Refresh.m
//  Refresh
//
//  Created by ZYD on 15/8/24.
//  Copyright (c) 2015年 SuperMap. All rights reserved.
//

#import "Refresh.h"


typedef enum : NSUInteger {
    WillStart,
    IsRefreshing,
    Finished,
} Status;

#define REFRESH_WIDTH 160
#define REFRESH_HEIGHT 30

@interface Refresh ()
{
    BOOL isDraging;
    BOOL hasPassed;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) Status status;

@end

@implementation Refresh

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype)initWithTableView:(UITableView *)tableView {

    if (self = [super init]) {
        self.tableView = tableView;
        
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:nil];
        self.frame = CGRectMake(self.tableView.bounds.size.width/2 - REFRESH_WIDTH/2, 0, REFRESH_WIDTH, REFRESH_HEIGHT);
        [self.tableView addSubview:self];
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator.frame = CGRectMake(0, 0, REFRESH_HEIGHT, REFRESH_HEIGHT);
        [self addSubview:self.indicator];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(REFRESH_HEIGHT, 0, self.bounds.size.width - REFRESH_HEIGHT, REFRESH_HEIGHT)];
        self.statusLabel.font = [UIFont systemFontOfSize:15];
        self.statusLabel.text = @"上拉加载更多...";
        [self addSubview:self.statusLabel];
    
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"contentSize"]) {
        self.frame = CGRectMake(self.tableView.bounds.size.width/2 - REFRESH_WIDTH/2, self.tableView.contentSize.height, REFRESH_WIDTH, REFRESH_HEIGHT);
    
        
    }else if ([keyPath isEqualToString:@"contentOffset"] && self.tableView.contentOffset.y + self.tableView.bounds.size.height >= self.tableView.contentSize.height + REFRESH_HEIGHT) {
    
        NSValue *value = [change objectForKey:NSKeyValueChangeOldKey];
        CGPoint point = [value CGPointValue];
        
        if ((point.y < self.tableView.contentOffset.y) && self.tableView.isDragging && !hasPassed) {

            hasPassed = YES;
            isDraging = YES;
        }else if ((point.y > self.tableView.contentOffset.y) && isDraging && (self.status != IsRefreshing)) {
    
            isDraging = NO;
            [UIView animateWithDuration:0.1 animations:^{
                
                self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + REFRESH_HEIGHT);
                self.frame = CGRectMake(self.tableView.bounds.size.width/2 - REFRESH_WIDTH/2, self.tableView.contentSize.height - REFRESH_HEIGHT, REFRESH_WIDTH, REFRESH_HEIGHT);
            } completion:^(BOOL finished) {
                
                if (self.startAction) {
                    self.startAction();
                }
                [self setTextWithStatus:IsRefreshing];
                [self.indicator startAnimating];
                
            }];
        }
    }
}

- (void)setTextWithStatus:(Status)status {

    switch (status) {
        case WillStart:
            self.statusLabel.text = @"上拉加载更多...";
            
            break;
        case IsRefreshing:
            self.statusLabel.text = @"正在加载...";
            break;
        case Finished:
            self.statusLabel.text = @"加载完成";
            break;
        default:
            break;
    }
    self.status = status;
}

- (void)finishRefresh {

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self setTextWithStatus:Finished];
        [self.indicator stopAnimating];
        self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height);
        self.frame = CGRectMake(self.tableView.bounds.size.width/2 - REFRESH_WIDTH/2, self.tableView.contentSize.height, REFRESH_WIDTH, REFRESH_HEIGHT);
    } completion:^(BOOL finished) {
        [self setTextWithStatus:WillStart];
        hasPassed = NO;
    }];
    
}



@end

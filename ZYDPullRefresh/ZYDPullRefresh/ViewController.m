//
//  ViewController.m
//  ZYDPullRefresh
//
//  Created by ZYD on 15/8/25.
//  Copyright (c) 2015年 SuperMap. All rights reserved.
//

#import "ViewController.h"

#import "Refresh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Refresh *refresh;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.items = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _refresh = [[Refresh alloc] initWithTableView:self.tableView];
    
    NSDate *date = [[NSDate alloc] init];
    NSMutableArray *items = self.items;
    ViewController *vc = self;
    [self.refresh setStartAction:^{
        
        for (NSInteger i = 0; i < 10; i++) {
            [items addObject:date];
        }
        [vc performSelector:@selector(finish) withObject:nil afterDelay:5];
    }];
    
    for (NSInteger i = 0; i < 10; i++) {
        [self.items addObject:date];
    }

    
}

- (void)finish {
    
    [self.tableView reloadData];
    [_refresh finishRefresh];
}

#pragma mark--UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.items.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    cell.textLabel.text = [formatter stringFromDate:self.items[indexPath.row]];
    
    return cell;
}




#pragma mark--UITableViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

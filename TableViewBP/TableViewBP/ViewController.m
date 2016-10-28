//
//  ViewController.m
//  TableViewBP
//
//  Created by GK on 16/10/3.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "ViewController.h"
#import "ViewDataSource.h"
#import "CustomCell.h"
#import "TableViewModel.h"
#import "RefreshFooter.h"
#import "RefreshHeader.h"
#import "ContactsPeople.h"

@interface ViewController ()<ViewDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ViewDataSource *viewDataSource;//tableview delegate
@property (nonatomic,strong) TableViewModel *viewModel; //提供网络请求更新数据
@property (nonatomic,strong) RefreshFooter *footerView;
@property (nonatomic,strong) RefreshHeader *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTableView];
    [self setRefreshHeaderAndFooterView];
    
    [self.headerView beginRefreshing];
    
    NSArray *temp = [ContactsPeople allContactsPeople];
    NSLog(@"%@",temp);
}

#pragma  mark --set  View
- (void)setTableView
{
    //register cell
    [self.tableView registerNib:[UINib nibWithNibName:[CustomCell cellIdentifier] bundle:nil] forCellReuseIdentifier:[CustomCell cellIdentifier]];
    
    //data source
    self.tableView.dataSource = self.viewDataSource;
    self.tableView.delegate = self.viewDataSource;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (void)setRefreshHeaderAndFooterView
{
    //header
    self.headerView = [[RefreshHeader alloc] initScrollView:self.tableView];
    
    __weak typeof (self) weakSelf = self;
    self.headerView.headerViewBeginRefresh = ^(){
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf headerRefreshAction];
    };
    
    // footer
    self.footerView = [[RefreshFooter alloc] initScrollView:self.tableView];
    
    self.footerView.footerViewBeginRefresh = ^(){
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf footerRefreshAction];
    };

}

#pragma mark -- ViewDataSourceDelegate
- (void)selectedInTableView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- property
- (ViewDataSource *)viewDataSource
{
    if (!_viewDataSource) {
        _viewDataSource = [[ViewDataSource alloc] init];
        _viewDataSource.delegate = self;
    }
    return _viewDataSource;
}
- (TableViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[TableViewModel alloc] init];
    }
    return _viewModel;
}
# pragma mark -- helper
- (void)headerRefreshAction
{
    [self.viewModel headerRefreshRequestWithCallback:^(NSArray *array,BOOL isSuccess){
        self.viewDataSource.dataSourceArray = [[NSMutableArray alloc] initWithArray:array];
        [self.headerView endRefreshing];
        [self.tableView reloadData];
    }];
    
}

- (void)footerRefreshAction
{
    [self.viewModel footerRefreshRequestWithCallback:^(NSArray *array,BOOL isSuccess){
        if (isSuccess) {
            NSArray *tempArray = [[NSArray alloc] initWithArray:array];
            if (tempArray.count == 0) {
                [self.footerView noMoreData];
            }else {
                [self.viewDataSource.dataSourceArray addObjectsFromArray:tempArray];
                [self.footerView endRefreshing];
                [self.tableView reloadData];
            }
        }else {
            [self.footerView loadError];
        }
    }];
}

@end

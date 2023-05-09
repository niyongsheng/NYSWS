//
//  NYSHomeCourseVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSHomeCourseVC.h"
#import "NYSCourseCell.h"

@interface NYSHomeCourseVC ()
<
UITextFieldDelegate
>
{
    NSInteger _pageNo;
}
@end

@implementation NYSHomeCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页课程列表";
    
    [self setupSearchView];
}

- (void)setupSearchView {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
    self.tableView.mj_footer = nil;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    [self footerRereshing];
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    
    NSDictionary *argument = @{
        @"pageNo": @(_pageNo),
        @"pageSize": @(9999),
        @"index": _index,
      };
    WS(weakSelf)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@""
                                      argument:argument
                                             remark:@"课程搜索列表"
                                            success:^(id response) {
        NSArray *array = [NSArray modelArrayWithClass:[NYSHomeCourseModel class] json:response[@"records"]];
        if (array.count > 0) {
            [weakSelf.dataSourceArr addObjectsFromArray:array];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NoData") reason:@"" suggestion:@"" placeholderImg:@"null"];
            }
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NetErr") reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
    }];
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"NYSCourseCell";
    NYSCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NYSHomeCourseModel *model = self.dataSourceArr[indexPath.row];

}

@end


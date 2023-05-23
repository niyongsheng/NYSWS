//
//  NYSMyCourseListVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSMyCourseListVC.h"
#import "NYSMyCourseCell.h"
#import "NYSCourseDetailVC.h"
#import "NYSPurchasedCourseDetailVC.h"

@interface NYSMyCourseListVC ()
{
    NSInteger _pageNo;
}


@end

@implementation NYSMyCourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableviewStyle = UITableViewStylePlain;
       [self.view addSubview:self.tableView];
       self.tableView.refreshControl = nil;
       self.tableView.showsVerticalScrollIndicator = NO;
       self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
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
        @"status": _index,
        @"page": @(_pageNo),
        @"limit": DefaultPageSize,
      };
    WS(weakSelf)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@"/index/Course/user_activation"
                                      argument:argument
                                             remark:@"已购/已学列表"
                                            success:^(id response) {
        NSArray *array = [NSArray modelArrayWithClass:[NYSHomeCourseModel class] json:response];
        if (array.count > 0) {
            [weakSelf.dataSourceArr addObjectsFromArray:array];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NoData") reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _pageNo = 1;
    [self footerRereshing];
    
    return YES;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"NYSMyCourseCell";
    NYSMyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

    NYSPurchasedCourseDetailVC *vc = NYSPurchasedCourseDetailVC.new;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

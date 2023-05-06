//
//  NYSMessageCenterVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSMessageCenterVC.h"
#import "NYSMessageCenterCell.h"

@interface NYSMessageCenterVC ()
<
UITextFieldDelegate
>
{
    NSInteger _pageNo;
}
@property (nonatomic, strong) UITextField *searchTF;
@end

@implementation NYSMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息中心";
    
    [self setupSearchView];
}

- (void)setupSearchView {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    
    CGFloat searchViewH = 40;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, searchViewH + NNormalSpace)];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(NNormalSpace, NNormalSpace/2, kScreenWidth - 2 * NNormalSpace, searchViewH)];
    ViewRadius(searchView, searchViewH/2);
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [headerView addSubview:searchView];
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(NNormalSpace, searchViewH/4, searchViewH/2, searchViewH/2)];
    [searchIconIV setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchIconIV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIconIV.right + NNormalSpace, 0, searchView.width - searchIconIV.right - 2 * NNormalSpace, searchViewH)];
    self.searchTF.delegate = self;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = @"搜一搜~";
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchTF];
    
//    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    
    NSDictionary *argument = @{
        @"pageNo": @(_pageNo),
        @"pageSize": DefaultPageSize,
        @"keyword": _searchTF.text,
      };
    WS(weakSelf)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                          url:@""
                                      argument:argument
                                             remark:@"消息中心列表"
                                            success:^(id response) {
        NSArray *array = [NSArray modelArrayWithClass:[NYSMessageCenterModel class] json:response[@"records"]];
        if (array.count > 0) {
            [weakSelf.dataSourceArr addObjectsFromArray:array];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:@"暂无数据" reason:@"" suggestion:@"" placeholderImg:@"null"];
            }
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        [weakSelf.tableView.refreshControl endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:@"网络错误" reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
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
    return NCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"NYSMessageCenterCell";
    NYSMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NYSMessageCenterModel *model = self.dataSourceArr[indexPath.row];

}

@end

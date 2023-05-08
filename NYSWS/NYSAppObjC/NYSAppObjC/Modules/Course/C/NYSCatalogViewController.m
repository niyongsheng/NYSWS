//
//  NYSCatalogViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCatalogViewController.h"
#import "NYSLessonPlayCell.h"

@interface NYSCatalogViewController ()
{
    NSInteger _pageNo;
}
@property (weak, nonatomic) IBOutlet UIView *catalogTitleV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *pagingV;

@property (nonatomic, strong) UITextField *searchTF;
@end

@implementation NYSCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wr_setNavBarBackgroundAlpha:0];
    ViewRadius(_catalogTitleV, 25);
    ViewRadius(_contentV, 20);
    
    
    // 搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(NNormalSpace, NNormalSpace/2, kScreenWidth - 2 * NNormalSpace, 40)];
    ViewRadius(searchView, 40/2);
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(NNormalSpace, 40/4, 40/2, 40/2)];
    [searchIconIV setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchIconIV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIconIV.right + NNormalSpace, 0, searchView.width - searchIconIV.right - 2 * NNormalSpace, 40)];
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = @"搜索词";
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchTF];
    
    self.navigationItem.titleView = searchView;
    
    
    _tableviewStyle = UITableViewStylePlain;
    [self.contentV addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NYSTools addRoundedCorners:self.tableView corners:UIRectCornerTopLeft|UIRectCornerTopRight radius:30];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentV.mas_top).offset(0);
        make.bottom.mas_equalTo(self.contentV.mas_bottom).offset(0);
        make.left.mas_equalTo(self.contentV.mas_left);
        make.right.mas_equalTo(self.contentV.mas_right);
    }];
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    
    NSDictionary *argument = @{
        @"pageNo": @(_pageNo),
        @"pageSize": DefaultPageSize,
    };
    WS(weakSelf)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@""
                                       argument:argument
                                         remark:@"资金变动列表"
                                        success:^(id response) {
        NSArray *array = [NSArray modelArrayWithClass:[NYSMovementModel class] json:response[@"records"]];
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
    static NSString *ID = @"NYSLessonPlayCell";
    NYSLessonPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
//    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

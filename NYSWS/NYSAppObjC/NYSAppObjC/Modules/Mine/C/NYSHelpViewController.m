//
//  NYSAboutViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/6.
//

#import "NYSHelpViewController.h"
#import "NYSHelpCenterCell.h"
#import "NYSHelpContentVC.h"

@interface NYSHelpViewController ()
{
    NSInteger _pageNo;
}
@end

@implementation NYSHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"HelpCenter");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NTopHeight + 10);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    [self footerRereshing];
}

#pragma mark - 网络加载数据
- (void)headerRereshing {
    [super headerRereshing];
    
    _pageNo = 0;
    [self footerRereshing];
}

- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    
    NSDictionary *argument = @{
        @"page": @(_pageNo),
        @"limit": DefaultPageSize,
    };
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Index/news_list"
                                       parameters:argument
                                         remark:@"帮助中心列表"
                                        success:^(id response) {
        @strongify(self)
        if (self->_pageNo == 1) {
            [self.dataSourceArr removeAllObjects];
        }
        
        NSArray *array = [NSArray modelArrayWithClass:[NYSHelpCenterModel class] json:response];
        if (array.count > 0) {
            [self.dataSourceArr addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            if (self->_pageNo == 1) {
                self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:NLocalizedStr(@"NoData") reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
            }
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer setHidden:self.dataSourceArr.count == 0];
        }
        
        [self.tableView.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } failed:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSString *description = error.localizedDescription;
        if (![description isNotBlank]) {
            description = NLocalizedStr(@"NetErr");
        }
        self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:description reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"NYSHelpCenterCell";
    NYSHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NYSHelpCenterModel *model = self.dataSourceArr[indexPath.row];
    NYSHelpContentVC *vc = NYSHelpContentVC.new;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

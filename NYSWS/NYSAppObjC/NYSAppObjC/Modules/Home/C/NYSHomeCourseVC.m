//
//  NYSHomeCourseVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/5.
//

#import "NYSHomeCourseVC.h"
#import "NYSCourseCell.h"
#import "NYSCourseDetailVC.h"
#import "NYSPurchasedCourseDetailVC.h"

@interface NYSHomeCourseVC ()
{
    NSInteger _pageNo;
}
@end

@implementation NYSHomeCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NNotificationCenter addObserverForName:@"HomeRefreshNotification" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self->_pageNo = 0;
        [self footerRereshing];
    }];
    
    [self setupSearchView];
}

- (void)setupSearchView {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.mj_footer = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
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
        @"page": @(_pageNo),
        @"limit": @999,
        @"is_recommend": @0,
        @"class_id": _index,
    };
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Course/list"
                                       parameters:argument
                                         remark:@"（首页）课程分类列表"
                                        success:^(id response) {
        @strongify(self)
        if (self->_pageNo == 1) {
            [self.dataSourceArr removeAllObjects];
        }
        
        NSArray *array = [NSArray modelArrayWithClass:[NYSHomeCourseModel class] json:response];
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
        [self changeTableviewHeight:self.dataSourceArr];
        
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

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSHomeCourseModel *model = self.dataSourceArr[indexPath.row];
    return [self getCellHeight:model];
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
    
    if ([model.is_activation isEqual:@"0"] || [model.is_course isEqual:@"0"]) {
        NYSPurchasedCourseDetailVC *vc = NYSPurchasedCourseDetailVC.new;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        NYSCourseDetailVC *vc = NYSCourseDetailVC.new;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 计算Cell高度
- (CGFloat)getCellHeight:(NYSHomeCourseModel *)model {
    CGFloat h = [model.subtitle heightForFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 170];
    return 160 + h;
}

- (void)changeTableviewHeight:(NSMutableArray *)dataSourceArr {
    
    CGFloat h = 0;
    for (NYSHomeCourseModel *model in self.dataSourceArr) {
        h += [self getCellHeight:model];
    }
    
    if (h == 0) {
        h += 200;
    }
    
    self.tableViewHeight = h;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, h + 15));
    }];
    [self.view layoutIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableviewHeight:)]) {
        [self.delegate tableviewHeight:h];
    }
}

@end


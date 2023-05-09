//
//  NYSSearchVC.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/4.
//

#import "NYSSearchCourseVC.h"
#import "NYSCourseCell.h"
#import "NYSBannerCell.h"
#import "NYSCourseDetailVC.h"

#define HomeBannerHeight        RealValue(120)

@interface NYSSearchCourseVC ()
<
UITextFieldDelegate
>
{
    NSInteger _pageNo;
}
@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) WMZBannerParam *bannerParam;
@property (nonatomic, strong) WMZBannerView *bannerView;
/// 轮播图
@property (nonatomic, strong) NSMutableArray<NYSBannerModel *> *bannerArray;
@end

@implementation NYSSearchCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索";
    
    [self setupSearchView];
}

- (void)setupSearchView {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    
    CGFloat searchViewH = 40;
    if (_isShowBanner) searchViewH += (HomeBannerHeight + 2 * NNormalSpace);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, searchViewH + NNormalSpace)];
    
    // 搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(NNormalSpace, NNormalSpace/2, kScreenWidth - 2 * NNormalSpace, 40)];
    ViewRadius(searchView, 40/2);
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [headerView addSubview:searchView];
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(NNormalSpace, 40/4, 40/2, 40/2)];
    [searchIconIV setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchIconIV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIconIV.right + NNormalSpace, 0, searchView.width - searchIconIV.right - 2 * NNormalSpace, 40)];
    self.searchTF.delegate = self;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = NLocalizedStr(@"Search");
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchTF];
    
    // 轮播图
    if (_isShowBanner) {
        self.bannerView = [[WMZBannerView alloc] initConfigureWithModel:self.bannerParam withView:headerView];
        self.bannerView.top = searchView.bottom + NNormalSpace;
        self.bannerView.centerX = headerView.centerX;
    }
    
    
    self.tableView.tableHeaderView = headerView;
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
    NYSCourseDetailVC *vc = NYSCourseDetailVC.new;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter/Getter
- (NSMutableArray<NYSBannerModel *> *)bannerArray {
    if (!_bannerArray) {
        NYSBannerModel *banner1 = [NYSBannerModel modelWithJSON:@{@"bannerUrl":@"https:///i.postimg.cc/4y2b2Mg1/1-3x.png"}];
        NYSBannerModel *banner2 = [NYSBannerModel modelWithJSON:@{@"bannerUrl":@"https:///i.postimg.cc/4y2b2Mg1/1-3x.png"}];
        _bannerArray = @[banner1, banner2].mutableCopy;
    }
    return _bannerArray;
}

- (WMZBannerParam *)bannerParam {
    if (!_bannerParam) {
        _bannerParam = BannerParam()
        .wMyCellClassNameSet(@"NYSBannerCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView, NSArray *dataArr) {
            NYSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSBannerCell class]) forIndexPath:indexPath];
            cell.isCourseBanner = YES;
            cell.bannerModel = model;
            return cell;
        })
        .wEventClickSet(^(id anyID, NSInteger index) {
            
        })
        .wFrameSet(CGRectMake(0, 0, NScreenWidth - 2 * NNormalSpace, HomeBannerHeight))
        .wItemSizeSet(CGSizeMake(NScreenWidth - 2 * NNormalSpace, HomeBannerHeight))
        .wScaleFactorSet(0.15f)
        .wScaleSet(NO)
        .wLineSpacingSet(NNormalSpace)
        .wRepeatSet(YES)
        .wAutoScrollSet(YES)
        .wAutoScrollSecondSet(5.0f)
        .wHideBannerControlSet(YES)
        .wDataSet(self.bannerArray);
    }
    return _bannerParam;
}

@end

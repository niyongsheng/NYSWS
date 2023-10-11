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
#import "NYSPurchasedCourseDetailVC.h"

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
static NSString *CellID = @"NYSCourseCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NLocalizedStr(@"SearchTitle");
    
    [self setupSearchView];
    if ([self.type isEqualToString:@"2"])
        [self footerRereshing];
    
    // 刷新课程数据
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NNotificationReloadData" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [self headerRereshing];
    }];
}

- (void)setupSearchView {
    
    _tableviewStyle = UITableViewStylePlain;
    [self.view addSubview:self.tableView];
    //    self.tableView.refreshControl = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:CellID bundle:nil] forCellReuseIdentifier:CellID];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(NScreenWidth, NScreenHeight));
    }];
    
    
    CGFloat searchViewH = 40;
    if ([self.type isEqualToString:@"2"]) searchViewH += (HomeBannerHeight + 2 * NNormalSpace);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, searchViewH + NNormalSpace)];
    headerView.backgroundColor = [UIColor whiteColor];
    
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
    if ([self.type isEqualToString:@"2"]) {
        self.searchTF.userInteractionEnabled = NO;
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 2 * NNormalSpace, searchViewH)];
        [searchBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NYSSearchCourseVC *searchVC = [NYSSearchCourseVC new];
            searchVC.type = @"3";
            searchVC.classId = self.classId;
            [self.navigationController pushViewController:searchVC animated:YES];
        }];
        [searchView addSubview:searchBtn];

        self.bannerView = [[WMZBannerView alloc] initConfigureWithModel:self.bannerParam withView:headerView];
        self.bannerView.top = searchView.bottom + NNormalSpace;
        self.bannerView.centerX = headerView.centerX;
    }
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 网络加载数据
- (void)headerRereshing {
    [super headerRereshing];
    
    _pageNo = 1;
    [self getData:YES];
}

- (void)footerRereshing {
    [super footerRereshing];
    _pageNo ++;
    [self getData:NO];
}

- (void)getData:(BOOL)isHeader {
    // 加载轮播数据
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:@"/index/Index/banner"
                                       argument:@{ @"page": @1, @"limit": @999 }
                                         remark:@"轮播图"
                                        success:^(id response) {
        @strongify(self)
        self.bannerArray = [NSArray modelArrayWithClass:[NYSBannerModel class] json:response].mutableCopy;
        self.bannerParam.wDataSet(self.bannerArray);
        [self.bannerView updateUI];
    } failed:^(NSError * _Nullable error) {
        
    }];
    
    NSMutableDictionary *argument = @{
        @"page": @(_pageNo),
        @"limit": DefaultPageSize,
        @"keyword": _searchTF.text
    }.mutableCopy;
    if ([self.type isEqualToString:@"2"] || [self.type isEqualToString:@"3"]) {
        [argument setValue:_classId forKey:@"class_id"];
        [argument setValue:@1 forKey:@"is_recommend"];
    }
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:[self.type isEqualToString:@"1"] ? @"/index/Course/select_coures" : @"/index/Course/list"
                                       argument:argument
                                         remark:@"搜索"
                                        success:^(id response) {
        @strongify(self)
        NSArray *array = [NSArray modelArrayWithClass:[NYSHomeCourseModel class] json:response];
        if (array.count > 0) {
            if (isHeader) {
                [self.dataSourceArr removeAllObjects];
            }
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
    _pageNo = 0;
    [self.dataSourceArr removeAllObjects];
    [self footerRereshing];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _pageNo = 0;
    [self.dataSourceArr removeAllObjects];
    [self footerRereshing];
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    [self headerRereshing];
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
    CGFloat h = [model.subtitle heightForFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 170];
    return 160 + h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSCourseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID];
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

//
//  NYSCatalogViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCatalogViewController.h"
#import "NYSWordCell.h"
#import "NYSStatementCell.h"
#import "CKAudioPlayerHelper.h"

#import "NYSCatalogSearchViewController.h"
#define ContenHeight (kScreenHeight - NTopHeight - NBottomHeight - 170)

@interface NYSCatalogViewController () <CKAudioPlayerHelperDelegate>
{
    NSInteger _pageNo;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *catalogTitleVHeight;
@property (weak, nonatomic) IBOutlet UIView *catalogTitleV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *pagingV;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIImageView *adIV;
@property (weak, nonatomic) IBOutlet UILabel *adL;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger currentPage;

/// 是否可试听
@property (nonatomic, copy) NSString *is_try;

/// 音频数组
@property (nonatomic, strong) NSArray *urlArray;
/// 序列号数组
@property (nonatomic, strong) NSArray *serialArray;
@end

@implementation NYSCatalogViewController
static NSString *NYSWordCellID = @"NYSWordCell";
static NSString *NYSStatementCellID = @"NYSStatementCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 避免向前翻译左滑冲突
//    self.fd_interactivePopDisabled = YES;
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 20;
    
    [self wr_setNavBarBackgroundAlpha:0];
    
    // 搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(NNormalSpace, NNormalSpace/2, kScreenWidth - 2 * NNormalSpace, 40)];
    ViewRadius(searchView, 40/2);
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(NNormalSpace, 40/4, 40/2, 40/2)];
    [searchIconIV setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchIconIV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIconIV.right + NNormalSpace, 0, searchView.width - searchIconIV.right - 2 * NNormalSpace, 40)];
    self.searchTF.enabled = NO;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = NLocalizedStr(@"SearchWord");
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchTF];
    
    self.navigationItem.titleView = searchView;
    
    self.navigationItem.titleView.userInteractionEnabled = YES;
    [self.navigationItem.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.isFromTry) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:NAppWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NLocalizedStr(@"CanNotSearch");
            [hud hideAnimated:YES afterDelay:1.0f];
            return;
        }
        
        NYSCatalogSearchViewController *vc = NYSCatalogSearchViewController.new;
        vc.index = self.index;
        vc.courseId = self.courseId;
        vc.chapterArray = self.chapterArray;
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    
    
    _tableviewStyle = UITableViewStylePlain;
    [self.contentV addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.mj_footer = nil;
    self.tableView.bounces = NO;
    ViewBorderRadius(self.tableView, 0, 1, UIColor.whiteColor)
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#4FBAD4"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NYSWordCellID bundle:nil] forCellReuseIdentifier:NYSWordCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NYSStatementCellID bundle:nil] forCellReuseIdentifier:NYSStatementCellID];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentV.mas_top).offset(10);
        make.bottom.mas_equalTo(self.contentV.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.contentV.mas_left).offset(10);
        make.right.mas_equalTo(self.contentV.mas_right).offset(-10);
    }];
    
    [self headerDisplayHandle];
    
    ViewRadius(_catalogTitleV, 25);
    ViewRadius(_contentV, 20);
    self.contentV.backgroundColor = [UIColor colorWithHexString:@"#4FBAD4"];
    
    [CKAudioPlayerHelper shareInstance].delegate = self;
    
    self.adL.text = self.courseModel.ad_title;
    self.adIV.userInteractionEnabled = YES;
    @weakify(self)
    [self.adIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        NYSWebViewController *webVC = [NYSWebViewController new];
        webVC.urlStr = self.courseModel.ad_url;
        webVC.autoTitle = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }]];
    
    // 右滑翻页
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.currentPage > 1) {
            [self getDetailData:[NSString stringWithFormat:@"%ld", --self.currentPage]];
        } else {
            [NYSTools showToast:@"已到第一页"];
        }
    }];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:rightRecognizer];
    // 左滑翻页
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (self.currentPage < self.totalPage) {
            [self getDetailData:[NSString stringWithFormat:@"%ld", ++self.currentPage]];
        } else {
            [NYSTools showToast:@"已到最后一页"];
        }
    }];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:leftRecognizer];
}

- (IBAction)leftBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    self.index --;
    
    [self headerDisplayHandle];
}

- (IBAction)rightBtnOnclicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender.layer];
    self.index ++;
    
    [self headerDisplayHandle];
}

- (void)headerDisplayHandle {
    self.leftBtn.enabled = self.index > 0;
    self.rightBtn.enabled = self.index < self.chapterArray.count - 1;
    
    self.is_try = [self.chapterArray[self.index] is_try];
    self.titleL.text = [self.chapterArray[self.index] title];
    self.subtitleL.text = [self.chapterArray[self.index] subtitle];
    [UIView animateWithDuration:1.0f animations:^{
        self.catalogTitleVHeight.constant = 40 + [self.subtitleL.text heightForFont:[UIFont systemFontOfSize:12] width:kScreenWidth - 145];
    }];
    
    [self getDetailData:@"1"];
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    
    [self getDetailData:@"1"];
}

- (void)getDetailData:(NSString *)page {
    self.currentPage = page.integerValue;
    
    NSDictionary *argument = @{
        @"page": page,
        @"chapter_id": @([self.chapterArray[self.index] ID]),
    };
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Course/chapter_info"
                                       parameters:argument
                                         remark:@"章节详情"
                                        success:^(id response) {
        @strongify(self)
        NSArray *wordArray = [NSArray modelArrayWithClass:[NYSCatalogModel class] json:response[@"data"][@"word_list"]];
        NSMutableArray *wordArrM = [NSMutableArray array];
        for (int i = 0; i < wordArray.count; i += 2) {
            if (i + 1 > wordArray.count -1) {
                [wordArrM addObject:@[wordArray[i]]];
            } else {
                [wordArrM addObject:@[wordArray[i], wordArray[i+1]]];
            }
        }
        
        NSArray *statementArray = [NSArray modelArrayWithClass:[NYSCatalogModel class] json:response[@"data"][@"statement_list"]];
        
        [self.dataSourceArr removeAllObjects];
        if ((wordArray.count + statementArray.count) > 0) {
            [self.dataSourceArr addObject:wordArrM];
            [self.dataSourceArr addObject:statementArray];
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
        [NYSTableViewAnimation showWithAnimationType:NYSTableViewAnimationTypeMove tableView:self.tableView];
        
        CGFloat th = self.tableView.contentSize.height;
        if (self.dataSourceArr.count == 0 || th > ContenHeight) th = ContenHeight;
        
        [self.view layoutIfNeeded];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(th);
        }];
        [UIView animateWithDuration:0.5f animations:^{
            self.contentV.height = th + 20;
        }];
        
        [self setTotalPage:[response[@"total_page"] integerValue] currentPage:page.integerValue];
        
    } failed:^(NSError * _Nullable error) {
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSString *description = error.localizedDescription;
        if (![description isNotBlank]) {
            description = NLocalizedStr(@"NetErr");
        }
        self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:description reason:error.localizedFailureReason suggestion:@"" placeholderImg:@"error"];
    }];
}

/// 布局页码
/// - Parameters:
///   - totalPage: 总页码
///   - currentPage: 当前页面
- (void)setTotalPage:(NSInteger)totalPage currentPage:(NSInteger)currentPage {
    _totalPage = totalPage;
    [self.pagingV removeAllSubviews];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 190, 30)];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.pagingV addSubview:scrollView];
    CGFloat x = 0;
    for (int i = 0; i < totalPage; i++) {
        NSString *titleStr = [NSString stringWithFormat:@"%d", i + 1];
        CGFloat btnWidth = 30;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = UIColor.whiteColor;
        [button setTitleColor:[UIColor colorWithHexString:@"#85E7FF"] forState:UIControlStateNormal];
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.frame = CGRectMake(x + 15, 0, btnWidth, btnWidth);
        [button addTarget:self action:@selector(pagingBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        ViewBorderRadius(button, btnWidth/2, 1, [UIColor colorWithHexString:@"#85E7FF"]);
        
        if (i == currentPage - 1) {
            button.backgroundColor = [UIColor colorWithHexString:@"#85E7FF"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        x += (btnWidth + 15);
    }

    scrollView.contentSize = CGSizeMake(x, 0);
    [scrollView setContentOffset:CGPointMake((currentPage - 1) * 45, 0) animated:NO];
}

- (void)pagingBtnOnclicked:(UIButton *)sender {
    
    [self getDetailData:[NSString stringWithFormat:@"%ld", sender.tag]];
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
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray<NYSCatalogModel *> *arr = self.dataSourceArr[indexPath.section][indexPath.row];
        NSString *content = [[arr firstObject] content];
        NSString *translate = [[arr firstObject] translate];
        if (arr.count > 1) {
            if ([[arr lastObject] content].length > [[arr firstObject] content].length)
                content = [[arr lastObject] content];
            if ([[arr lastObject] translate].length > [[arr firstObject] translate].length)
                translate = [[arr lastObject] translate];
        }
        
        CGFloat labelH0 = [content heightForFont:WordLabelFont width:WordLabelWidth];
        CGFloat labelH1 = [translate heightForFont:WordLabelFont width:WordLabelWidth];
        
        return 20 + labelH0 + labelH1;
    } else {
        NYSCatalogModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
        CGFloat labelH0 = [model.content heightForFont:StatementLabelFont width:StatementLabelWidth];
        CGFloat labelH1 = [model.translate heightForFont:StatementLabelFont width:StatementLabelWidth];
        
        return 20 + labelH0 + labelH1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NYSWordCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NYSWordCellID];
        cell.indexPath = indexPath;
        cell.modelArr = self.dataSourceArr[indexPath.section][indexPath.row];
        cell.block = ^(BOOL isLeft, NSIndexPath * _Nonnull indexP) {
            
            NSArray<NYSCatalogModel *> *arr = self.dataSourceArr[indexP.section][indexP.row];
            if (isLeft) {
                [self playWav:[[arr firstObject] url] contentUrl:[[arr firstObject] content_url] urlSerial:@"01" contentUrlSerial:@"02"];
            } else if (arr.count > 1) {
                [self playWav:[[arr lastObject] url] contentUrl:[[arr lastObject] content_url] urlSerial:@"01" contentUrlSerial:@"02"];
            }
        };
        return cell;
        
    } else {
        
        NYSCatalogModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
        NYSStatementCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NYSStatementCellID];
        cell.model = model;
        return cell;
    }
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NYSCatalogModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
        [self playWav:model.url contentUrl:model.content_url urlSerial:@"01" contentUrlSerial:@"02"];
    }
}

/// 播放
/// - Parameter urlStr: 音频url
/// - Parameter contentUrlStr: 翻译url
/// - Parameter urlSerial: 序列号
/// - Parameter contentUrlSerial: 翻译序列号
- (void)playWav:(NSString *)urlStr contentUrl:(NSString *)contentUrlStr urlSerial:(NSString *)urlSerial contentUrlSerial:(NSString *)contentUrlSerial  {
    if (!self.isFromTry)
        [self signLearned];
    
    if (self.isFromTry && self.is_try.boolValue) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:NAppWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NLocalizedStr(@"PleaseBuy");
        [hud hideAnimated:YES afterDelay:1.0f];
        return;
    }
    
    if (![urlStr isNotBlank] && ![contentUrlStr isNotBlank]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:NAppWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NLocalizedStr(@"NoAudioInfo");
        [hud hideAnimated:YES afterDelay:1.0f];
        return;
    }
    
    if ([contentUrlStr isNotBlank] && ![contentUrlStr containsString:@"http"])
        contentUrlStr = [NSString stringWithFormat:@"%@%@", APP_CDN_URL, contentUrlStr];
    
    if ([urlStr isNotBlank] && ![urlStr containsString:@"http"])
        urlStr = [NSString stringWithFormat:@"%@%@", APP_CDN_URL, urlStr];
    
    self.urlArray = @[contentUrlStr, urlStr];
    self.serialArray = @[contentUrlSerial, urlSerial];

    if ([[self.urlArray firstObject] isNotBlank]) {
        [[CKAudioPlayerHelper shareInstance] managerAudioWithUrlPath:[self.urlArray firstObject] serial:[self.serialArray firstObject] playOrPause:YES];
    } else {
        [[CKAudioPlayerHelper shareInstance] managerAudioWithUrlPath:[self.urlArray lastObject] serial:[self.serialArray lastObject] playOrPause:YES];
    }
}

#pragma mark - CKAudioPlayerHelperDelegate
- (void)didAudioPlayerFinishPlay:(AVAudioPlayer *)audioPlayer serial:(NSString *)serial pathName:(NSString *)pathName {
    if ([serial isEqualToString:[self.serialArray firstObject]] && self.urlArray.count > 1) {
        [[CKAudioPlayerHelper shareInstance] managerAudioWithUrlPath:[self.urlArray lastObject] serial:[self.serialArray lastObject] playOrPause:YES];
    }
}

- (void)signLearned {
    NSDictionary *argument = @{
        @"course_id": @(self.courseId),
    };
    [NYSNetRequest jsonNetworkRequestWithType:POST
                                            url:@"/index/Course/learned"
                                       parameters:argument
                                         remark:@"标记已学"
                                        success:^(id response) {
        
    } failed:^(NSError * _Nullable error) {

    }];
}

@end

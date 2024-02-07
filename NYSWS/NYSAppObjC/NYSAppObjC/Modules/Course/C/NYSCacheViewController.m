//
//  NYSCacheViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCacheViewController.h"
#import "NYSWordCell.h"
#import "NYSStatementCell.h"
#import "CKAudioPlayerHelper.h"

#import "NYSCatalogSearchViewController.h"

@interface NYSCacheViewController () <CKAudioPlayerHelperDelegate>
{
    NSInteger _pageNo;
    CGFloat _tableviewInitHeight;
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
@property (nonatomic, strong) NSArray *audioArray;
/// 序列号数组
@property (nonatomic, strong) NSArray *serialArray;
@end

@implementation NYSCacheViewController
static NSString *NYSWordCellID = @"NYSWordCell";
static NSString *NYSStatementCellID = @"NYSStatementCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 避免向前翻译左滑冲突
//    self.fd_interactivePopDisabled = YES;
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 20;
    
    [self wr_setNavBarBackgroundAlpha:0];
    
    self.navigationItem.title = @"课程缓存";
    
    _tableviewStyle = UITableViewStylePlain;
    [self.contentV addSubview:self.tableView];
    self.tableView.refreshControl = nil;
    self.tableView.mj_footer = nil;
    self.tableView.bounces = NO;
    ViewBorderRadius(self.tableView, 0, 1, UIColor.whiteColor)
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#4FBAD4"];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NYSWordCellID bundle:nil] forCellReuseIdentifier:NYSWordCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NYSStatementCellID bundle:nil] forCellReuseIdentifier:NYSStatementCellID];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentV.mas_top).offset(10);
        make.bottom.mas_equalTo(self.contentV.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.contentV.mas_left).offset(10);
        make.right.mas_equalTo(self.contentV.mas_right).offset(-10);
    }];
    _tableviewInitHeight = self.tableView.height;
    
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
    
    NSArray *wordArray = self.courseModel.chapter[self.index].content.word_list;
    NSMutableArray *wordArrM = [NSMutableArray array];
    for (int i = 0; i < wordArray.count; i += 2) {
        if (i + 1 > wordArray.count -1) {
            [wordArrM addObject:@[wordArray[i]]];
        } else {
            [wordArrM addObject:@[wordArray[i], wordArray[i+1]]];
        }
    }
    
    NSArray *statementArray = self.courseModel.chapter[self.index].content.statement_list;
    
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
    }
    
    [self.tableView.refreshControl endRefreshing];
    [self.tableView reloadData];
    [NYSTableViewAnimation showWithAnimationType:NYSTableViewAnimationTypeMove tableView:self.tableView];
    
    CGFloat th = self.tableView.contentSize.height;
    if (self.dataSourceArr.count > 0 && th < self->_tableviewInitHeight) {
        [self.view layoutIfNeeded];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(th);
        }];
        [UIView animateWithDuration:0.5f animations:^{
            self.contentV.height = th + 20;
        }];
    }
    
    [self setTotalPage:1 currentPage:page.integerValue];
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
                [self playWav:[[arr firstObject] url_path] contentUrl:[[arr firstObject] content_url_path]];
            } else if (arr.count > 1) {
                [self playWav:[[arr lastObject] url_path] contentUrl:[[arr lastObject] content_url_path]];
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
        [self playWav:model.url_path contentUrl:model.content_url_path];
    }
}

/// 本地缓存播放
- (void)playWav:(NSString *)urlStr contentUrl:(NSString *)contentUrlStr {
    
    if (![urlStr isNotBlank] && ![contentUrlStr isNotBlank]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:NAppWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NLocalizedStr(@"NoAudioInfo");
        [hud hideAnimated:YES afterDelay:1.0f];
        return;
    }
    
    self.audioArray = @[contentUrlStr, urlStr];
    self.serialArray = @[@"02", @"01"];
    
    if ([[self.audioArray firstObject] isNotBlank]) {
        [[CKAudioPlayerHelper shareInstance] managerAudioWithLocalPath:[self.audioArray firstObject] serial:[self.serialArray firstObject] playOrPause:YES];
    } else {
        [[CKAudioPlayerHelper shareInstance] managerAudioWithLocalPath:[self.audioArray lastObject] serial:[self.serialArray lastObject] playOrPause:YES];
    }
}

#pragma mark - CKAudioPlayerHelperDelegate
- (void)didAudioPlayerFinishPlay:(AVAudioPlayer *)audioPlayer serial:(NSString *)serial pathName:(NSString *)pathName {
    if ([serial isEqualToString:[self.serialArray firstObject]] && self.audioArray.count > 1) {
        [[CKAudioPlayerHelper shareInstance] managerAudioWithLocalPath:[self.audioArray lastObject] serial:[self.serialArray lastObject] playOrPause:YES];
    }
}

@end

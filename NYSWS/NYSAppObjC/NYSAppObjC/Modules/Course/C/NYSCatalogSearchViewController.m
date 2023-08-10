//
//  NYSCatalogSearchViewController.m
//  NYSAppObjC
//
//  Created by niyongsheng on 2023/5/8.
//

#import "NYSCatalogSearchViewController.h"
#import "NYSWordCell.h"
#import "NYSStatementCell.h"
#import "CKAudioPlayerHelper.h"

@interface NYSCatalogSearchViewController ()
<
UITextFieldDelegate,
CKAudioPlayerHelperDelegate
>
{
    NSInteger _pageNo;
}
@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger currentPage;

/// 音频数组
@property (nonatomic, strong) NSArray *urlArray;
/// 序列号数组
@property (nonatomic, strong) NSArray *serialArray;
@end

@implementation NYSCatalogSearchViewController
static NSString *NYSWordCellID = @"NYSWordCell";
static NSString *NYSStatementCellID = @"NYSStatementCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wr_setNavBarBackgroundAlpha:0];
    
    // 搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(NNormalSpace, NNormalSpace/2, kScreenWidth - 2 * NNormalSpace, 40)];
    ViewRadius(searchView, 40/2);
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(NNormalSpace, 40/4, 40/2, 40/2)];
    [searchIconIV setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchIconIV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIconIV.right + NNormalSpace, 0, searchView.width - searchIconIV.right - 2 * NNormalSpace, 40)];
    self.searchTF.delegate = self;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = NLocalizedStr(@"SearchWord");
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchTF];
    
    self.navigationItem.titleView = searchView;
    
    
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
    
    ViewRadius(_contentV, 20);
    self.contentV.backgroundColor = [UIColor colorWithHexString:@"#4FBAD4"];
    
//    [self.searchTF becomeFirstResponder];
    
    [CKAudioPlayerHelper shareInstance].delegate = self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self getDetailData:@"1"];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _pageNo = 0;
    [self getDetailData:@"1"];
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    _pageNo = 0;
    [self getDetailData:@"1"];
}

#pragma mark - 网络加载数据
- (void)footerRereshing {
    [super footerRereshing];
    
    [self getDetailData:@"1"];
}

- (void)getDetailData:(NSString *)page {
    self.currentPage = page.integerValue;
    
    NSMutableDictionary *argument = @{
        @"page": page,
        @"limit": @9999,
        @"keyword": self.searchTF.text,
    }.mutableCopy;
    if (!self.isHomeSearch) {
        [argument setValue:@(self.courseId) forKey:@"course_id"];
//        [argument setValue:@([self.chapterArray[self.index] ID]) forKey:@"chapter_id"];
    }
    @weakify(self)
    [NYSNetRequest jsonNetworkRequestWithMethod:@"POST"
                                            url:self.isHomeSearch ? @"/index/Course/select_index_content" : @"/index/Course/select_content"
                                       argument:argument
                                         remark:self.isHomeSearch ? @"首页关键词搜索" : @"章节关键词搜索"
                                        success:^(id response) {
        @strongify(self)
        NSArray *wordArray = [NSArray modelArrayWithClass:[NYSCatalogModel class] json:response[@"word_list"]];
        NSMutableArray *wordArrM = [NSMutableArray array];
        for (int i = 0; i < wordArray.count; i += 2) {
            if (i + 1 > wordArray.count -1) {
                [wordArrM addObject:@[wordArray[i]]];
            } else {
                [wordArrM addObject:@[wordArray[i], wordArray[i+1]]];
            }
        }
        
        NSArray *statementArray = [NSArray modelArrayWithClass:[NYSCatalogModel class] json:response[@"statement_list"]];
        
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
        
        CGFloat labelH0 = [content heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        CGFloat labelH1 = [translate heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        
        return 20 + labelH0 + labelH1;
    } else {
        NYSCatalogModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
        CGFloat labelH0 = [model.content heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        CGFloat labelH1 = [model.translate heightForFont:[UIFont systemFontOfSize:15] width:(kScreenWidth - 90) / 2];
        
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
                NYSCatalogModel *firstWordModel = [arr firstObject];
                [self playWav:[firstWordModel url] contentUrl:[firstWordModel content_url] isActivation:firstWordModel.is_activation isTry:firstWordModel.is_try];
            } else if (arr.count > 1) {
                NYSCatalogModel *lastWordModel = [arr lastObject];
                [self playWav:[lastWordModel url] contentUrl:[lastWordModel content_url] isActivation:lastWordModel.is_activation isTry:lastWordModel.is_try];
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
        [self playWav:model.url contentUrl:model.content_url isActivation:model.is_activation isTry:model.is_try];
    }
}

/// 播放
/// - Parameter urlStr: 音频url
/// - Parameter contentUrlStr: 原文音频
/// - Parameter isActivation: 是否激活
/// - Parameter isTry: 是否试听
/// http://xyd.app12345.cn/upload/images/76/84577a010bf752f4c6530bf60c9412.wav
- (void)playWav:(NSString *)urlStr contentUrl:(NSString *)contentUrlStr isActivation:(NSInteger)isActivation isTry:(NSInteger)isTry {
    
    if (self.isHomeSearch) {
        if (isActivation == 1 && isTry == 1) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:NAppWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NLocalizedStr(@"PleaseBuy");
            [hud hideAnimated:YES afterDelay:1.0f];
            return;
        }
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
    self.serialArray = @[@"02", @"01"];

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

@end

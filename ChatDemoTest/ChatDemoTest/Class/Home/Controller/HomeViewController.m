//
//  HomeViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/14.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "MyFMDBData.h"
#import "ScenicspotListDataInfo.h"
#import "CategorySearchView.h"
#import "HomeTravelsTableViewCell.h"
#import "HomeTravelsCellModel.h"
#import "HomeTravelsCunstomTableViewCell.h"
#import "TravelsDetailTableViewController.h"
#import "EMAlertView.h"
#import "SpotsSearchViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#define playerHeight 180

@interface HomeViewController ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CategorySearchViewDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    long _pageno;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SDCycleScrollView *playerView;
@property(nonatomic, strong) CategorySearchView *categorySearchView;
@property(nonatomic, strong) NSMutableArray *travelsList;

@end

@implementation HomeViewController

#pragma mark - 懒加载
-(UITableView *)tableView{

    if (!_tableView) {
        CGRect frame=CGRectMake(0, 0, self.view.width, self.view.height-64);
        _tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)travelsList{

    if (!_travelsList) {
        _travelsList=[[NSMutableArray alloc] init];
    }
    return _travelsList;
}
#pragma mark - 共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"主页";
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //刷新控件
    [self setupRefresh];
    
    //初始化列表
    [self tableView];
    
    //添加轮播图片
    [self createADView];
    
    //分类查询页面
    [self createSearchView];
    
    //游记列表
    _pageno=1;
    [self requestTravelsData:_pageno];
    
}
-(void)viewWillAppear:(BOOL)animated {
    _locService.delegate = self;
    [_locService startUserLocationService];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
}


#pragma mark - 私有方法
#pragma mark 下拉刷新数据
-(void)reverseGeocodeWithLatitude:(CGFloat)latitude withCoordinate:(CGFloat)coordinate
{
   
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};

    pt = (CLLocationCoordinate2D){latitude, coordinate};

    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

//刷新控件
-(void)setupRefresh{

    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.tableView.mj_footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)loadNewData
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
    });
}
- (void)loadMoreData{

    _pageno++;
    [self requestTravelsData:_pageno];
}

-(void)requestTravelsData:(long)pageno{
    
    NSString *query=@"成都";
    NSString *utf_query=[query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *httpUrl = @"http://apis.baidu.com/qunartravel/travellist/travellist";
    NSString *httpArg = [NSString stringWithFormat:@"query=%@&page=%ld",utf_query,pageno];
    [self requestTravels:httpUrl withHttpArg:httpArg];
}
-(void)requestTravels: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg{

    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: BDAPIKey forHTTPHeaderField: @"apikey"];
    __weak typeof(self) weakSelf=self;
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   
                                   NSDictionary *dic=[weakSelf dictionaryWithJsonString:responseString];
                                   [weakSelf setupTravelsDataList:dic];
                               }
                               
                               // 停止加载
                               [weakSelf.tableView.mj_footer endRefreshing];
                               
                           }];
}

-(void)setupTravelsDataList:(NSDictionary *)dic{

    NSString *errmsg=dic[@"errmsg"];
    if (dic==nil||![errmsg isEqualToString:@"success"]) {
        return;
    }
    NSDictionary *dataDic=dic[@"data"];
    NSArray *dataList=dataDic[@"books"];
    for (NSDictionary *dict in dataList) {
        HomeTravelsCellModel *model=[HomeTravelsCellModel setupHomeTravelsCellModel:dict];
        [self.travelsList addObject:model];
    }
    
    [self.tableView reloadData];
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(SDCycleScrollView *)createADView{
    
    CGRect frame=CGRectMake(0, 0, ScreenW, playerHeight);
    _playerView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:PlaceholderImage];
    _playerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _playerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _playerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _playerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _playerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    _playerView.imageURLStringsGroup=@[@"http://pic16.nipic.com/20110829/3441550_100152357000_2.jpg",@"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg",@"http://hiphotos.baidu.com/praisejesus/pic/item/e8df7df89fac869eb68f316d.jpg"];
    
    return _playerView;
    
}

-(CategorySearchView *)createSearchView{

    CGRect frame=CGRectMake(0, 0, ScreenW, 100);
    _categorySearchView=[CategorySearchView setupCategorySearchView:frame];
    _categorySearchView.delegate=self;
    return _categorySearchView;
}


#pragma mark - 代理方法

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{

    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==2) {
        return self.travelsList.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifer=@"cell";
    static NSString *custominentofer=@"custominentofer";
    UITableViewCell *cell;
    HomeTravelsCunstomTableViewCell *travelsTableViewCell;
    if (indexPath.section==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        [cell addSubview:self.playerView];
    }else if (indexPath.section==1){
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:self.categorySearchView];
        
    }else{
        travelsTableViewCell=[tableView dequeueReusableCellWithIdentifier:custominentofer];
        if (travelsTableViewCell==nil) {
            travelsTableViewCell=[[HomeTravelsCunstomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:custominentofer];
        }
        travelsTableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
        HomeTravelsCellModel *model=self.travelsList[indexPath.row];
        [travelsTableViewCell setupCellData:model];
        return travelsTableViewCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        return playerHeight;
    }else if (indexPath.section==1){
    
        return 100;
    }else{
    
        return 220;
    }
   
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    if (indexPath.section==2) {
         NSLog(@"%@",self.travelsList[indexPath.row]);
        
        UIStoryboard *travels=[UIStoryboard storyboardWithName:@"travelsDetail" bundle:[NSBundle mainBundle]];
        TravelsDetailTableViewController *vc=[travels instantiateViewControllerWithIdentifier:@"travelsDetailController"];
        HomeTravelsCellModel *model=self.travelsList[indexPath.row];
        vc.model=model;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==2) {
        return 30;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor lightGrayColor];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.frame=CGRectMake(15, 5, 100, 20);
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=@"热门游记";
    [view addSubview:titleLabel];
    return view;
}


#pragma mark - CategorySearchViewDelegate
-(void)CategorySearchViewItemDidClick:(long)tag{

    NSLog(@"%ld",tag);
    if (tag==0) {
        SpotsSearchViewController *vc=[[SpotsSearchViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag==1){
        
        UIStoryboard *storybord=[UIStoryboard storyboardWithName:@"TrainSearch" bundle:[NSBundle mainBundle]];
        UIViewController *vc=storybord.instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (tag==2){
    
        UIStoryboard *storybord=[UIStoryboard storyboardWithName:@"WeatherSearch" bundle:[NSBundle mainBundle]];
        UIViewController *vc=storybord.instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        EMAlertView *alert = [[EMAlertView alloc]initWithTitle:@"温馨提示" message:@"萌萌的开发人员还在偷懒中，此功能还在沉睡中等待唤醒！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }


}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [self reverseGeocodeWithLatitude:userLocation.location.coordinate.latitude withCoordinate:userLocation.location.coordinate.longitude];
    [_locService stopUserLocationService];
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"当前位置";
//        showmeg = [NSString stringWithFormat:@"%@",item.title];
//        return;
        BMKPoiInfo *BMKinfo=result.poiList[0];
        showmeg = [NSString stringWithFormat:@"%@",BMKinfo.address];
        
        [UserInfonCache sharedUserInfonCache].city=BMKinfo.city;
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}
@end

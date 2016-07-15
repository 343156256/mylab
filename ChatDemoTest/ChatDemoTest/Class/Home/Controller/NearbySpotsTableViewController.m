//
//  NearbySpotsTableViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/27.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "NearbySpotsTableViewController.h"
#import "ScenicspotListDataInfo.h"
#import "SpotDetailWebviewController.h"
#import "MyFMDBData.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface NearbySpotsTableViewController ()<BMKMapViewDelegate, BMKPoiSearchDelegate>
{
    MyFMDBData *_listdata;
    BMKPoiSearch* _poisearch;
    int curPage;
    BOOL hasSearch;
}
@end

@implementation NearbySpotsTableViewController

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(instancetype)initWithStyle:(UITableViewStyle)style{

    self=[super initWithStyle:style];
    if (self) {
        
        self.tableView.frame=CGRectMake(0, 0, ScreenW, ScreenH);
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据库
    _listdata=[MyFMDBData sharedMyFMDBData];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    _poisearch = [[BMKPoiSearch alloc]init];
    hasSearch=NO;
    
    
    UIView *view=[[UIView alloc]init];
    self.tableView.tableFooterView=view;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.tableView.mj_footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(searchMoreBMPOI)];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    if (!hasSearch) {
        curPage = 0;
        [self searchBMPOI:curPage];
        hasSearch=YES;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    _poisearch.delegate = nil; // 不用时，置nil
}

-(void)searchBMPOI:(int)pageCount
{
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = pageCount;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city= @"成都";
    citySearchOption.keyword = @"景点";
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
    
    
}
-(void)searchMoreBMPOI{
    curPage++;
    [self searchBMPOI:curPage];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer=@"nearbyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
    }
    ScenicspotListDataInfo *model=self.dataArray[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"景点名: %@",model.spotName];
    if (model.spotAliasName==nil) {
         cell.detailTextLabel.text=@"别名: 无";
    }else{
        NSMutableString *aliasName=[NSMutableString string];
        for (NSString *name in model.spotAliasName) {
            [aliasName appendString:[NSString stringWithFormat:@" %@",name]];
        }
        cell.detailTextLabel.text=[NSString stringWithFormat:@"别名:%@",aliasName];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ScenicspotListDataInfo *model=self.dataArray[indexPath.row];
    SpotDetailWebviewController *vc=[[SpotDetailWebviewController alloc]init];
    vc.productId=model.productId;
    vc.title=model.spotName;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            NSString *title = poi.name;
            NSArray *seachArray = [_listdata query:title];
            ScenicspotListDataInfo *model;
            if (seachArray.count>1) {
                NSArray *nextSearch=[_listdata query:[NSString stringWithFormat:@"成都%@",title]];
                if (nextSearch.count>0) {
                    model=nextSearch[0];
                }else{
                    model=seachArray[0];
                }
            }else if (seachArray.count==1){
                
                model=seachArray[0];
            }
            if (model) {
                NSLog(@"%@",model.spotName);
                [self.dataArray addObject:model];
            }
        }
        
        if (self.dataArray.count<10&&curPage<4) {
            [self searchMoreBMPOI];
        }else if (self.dataArray.count==0&&curPage<10){
            [self searchMoreBMPOI];
        }else{
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_footer endRefreshing];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

@end

//
//  SpotsSearchViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/27.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "SpotsSearchViewController.h"
#import "MySegmentControlView.h"
#import "MyFMDBData.h"
#import "NearbySpotsTableViewController.h"
#import "SearchMySpotsViewController.h"
#import "ScenicspotListDataInfo.h"


@interface SpotsSearchViewController ()<MySegmentControlViewDelegate>
{
    MySegmentControlView *_segmentView;
    
     MyFMDBData *_listdata;

}

@property(nonatomic,strong) UITableView *nearbySpots;
@property(nonatomic,strong) NearbySpotsTableViewController *nearByView;
@property(nonatomic,strong) SearchMySpotsViewController *searchView;
@property(nonatomic,strong) NSMutableArray *dataAarray;
@end

@implementation SpotsSearchViewController

-(NSMutableArray *)dataAarray{

    if (!_dataAarray) {
        _dataAarray=[[NSMutableArray alloc]init];
    }
    return _dataAarray;
}

-(NearbySpotsTableViewController *)nearByView{

    if (!_nearByView) {
        _nearByView=[[NearbySpotsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    return _nearByView;
}

-(SearchMySpotsViewController *)searchView{

    if (!_searchView) {
        _searchView=[SearchMySpotsViewController setupSearchMySpotsViewController];
    }
    return _searchView;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化数据库
    _listdata=[MyFMDBData sharedMyFMDBData];
    
        // 设置导航栏中的SegmentedControl
    NSArray *items = @[@"热门景点", @"景点搜索"];
    _segmentView = [[MySegmentControlView alloc] initWithSegmentControlItems:items defaultSelectedIndex:0];
    _segmentView.delegate = self;
    self.navigationItem.titleView = _segmentView;
    
    //初始化第一个展示界面
    [self addChildViewController:self.nearByView];
    [self.view addSubview:self.nearByView.tableView];
    
    //初始化第二个界面
    [self addChildViewController:self.searchView];
    [self.view addSubview:self.searchView.view];
    self.searchView.view.x=ScreenW;
    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
//    self.nearByView.tableView.mj_footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(searchMoreBMPOI)];
//    self.nearByView.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
}

-(void)segmentControlDidSelected:(NSInteger)selectedIndex{

    _segmentView.userInteractionEnabled=NO;
    if (selectedIndex==0) {
       
        [self.view bringSubviewToFront:self.nearByView.tableView];
        [UIView animateWithDuration:0.7 animations:^{
            self.nearByView.tableView.x=0;
        } completion:^(BOOL finished) {
            self.searchView.view.x=ScreenW;
            _segmentView.userInteractionEnabled=YES;
        }];
        
        
        
    }else if (selectedIndex==1){
        
        [self.view bringSubviewToFront:self.searchView.view];
        [UIView animateWithDuration:0.7 animations:^{
            self.searchView.view.x=0;
        } completion:^(BOOL finished) {
            self.nearByView.tableView.x=-ScreenW;
            _segmentView.userInteractionEnabled=YES;
        }];

    }
}


@end

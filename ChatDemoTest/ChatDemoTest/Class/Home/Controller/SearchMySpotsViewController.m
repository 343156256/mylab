//
//  SearchMySpotsTableViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/30.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "SearchMySpotsViewController.h"
#import "ScenicspotListDataInfo.h"
#import "CachMethod.h"
#import "MyFMDBData.h"
#import "SpotDetailWebviewController.h"

#define HistorySearchCacheDataFile @"HistorySearchCacheDataFile"

@interface SearchMySpotsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *_selectBtn;
    MyFMDBData *_listdata;
}
- (IBAction)searchBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *historyArray;


@end

@implementation SearchMySpotsViewController

+(instancetype)setupSearchMySpotsViewController{

    return [[[NSBundle mainBundle] loadNibNamed:@"SearchMySpotsViewController" owner:nil options:nil] firstObject];
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableview{

    if (!_tableview) {
        _tableview=[[UITableView alloc] init];
        _tableview.dataSource=self;
        _tableview.delegate=self;
        UIView *view=[[UIView alloc]init];
        _tableview.tableFooterView=view;
    
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据库
    _listdata=[MyFMDBData sharedMyFMDBData];
    
    self.textField.delegate=self;
    self.historyLabel.frame=CGRectMake(0, 80, ScreenW, 20);
    self.historyView.frame=CGRectMake(0, 100, ScreenW, ScreenH);
    [self setupSearchHistory];
    [self createSearchHistoryBtn];
    [self.view bringSubviewToFront:self.historyLabel];
    [self.view bringSubviewToFront:self.historyView];
}

-(void)viewWillAppear:(BOOL)animated{

    self.tableview.frame=CGRectMake(0, 80, ScreenW, self.view.frame.size.height-80-64);
    [self.view addSubview:self.tableview];
}

-(void)setupSearchHistory{

    NSDictionary *prama=@{@"name":[UserInfonCache sharedUserInfonCache].userName};
    NSArray *historys=[CachMethod dataWithParams:prama with:HistorySearchCacheDataFile];
    _historyArray=[[NSMutableArray alloc]init];
    if (historys) {
        [self.historyArray addObjectsFromArray:historys];
    }
}

-(void)createSearchHistoryBtn{

    CGFloat paddingTop=10;
    CGFloat btnH=25;
    CGFloat paddingLeft=10;
    CGFloat paddingIn=10;
    
    CGFloat lastX=0;
    CGFloat lastY=0;
    
    int count=self.historyArray.count>10?10:(int)self.historyArray.count;
    for (int i=0; i<count; i++) {
        NSString *title=self.historyArray[i];
        UIButton *btn=[[UIButton alloc]init];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=3;
        UIColor *color=[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_background"]];
        btn.layer.borderColor=color.CGColor;
        btn.layer.borderWidth=0.5;
        [btn addTarget:self action:@selector(historyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        CGSize size1=CGSizeMake(ScreenW-2*paddingLeft, btnH);
        CGSize size2=[title boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size;
        CGRect frame;
        if (lastX==0) {
            frame=CGRectMake(paddingLeft, paddingTop, size2.width+paddingIn, btnH);

        }else{
        
            CGFloat nextMaxX=size2.width+lastX+paddingLeft;
            if (nextMaxX>ScreenW-paddingLeft-paddingIn) {
               
                frame=CGRectMake(paddingLeft, lastY+paddingTop, size2.width+paddingIn, btnH);
            }else{
            
                frame=CGRectMake(lastX+paddingLeft, lastY-btnH, size2.width+paddingIn, btnH);
            }
        }
        lastX=CGRectGetMaxX(frame);
        lastY=CGRectGetMaxY(frame);
        btn.frame=frame;
        [self.historyView addSubview:btn];
    }
    
}

-(void)historyBtnClick:(UIButton *)sender{
    
    [sender setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_background"]]];
    sender.selected=YES;
    _selectBtn.selected=NO;
    [_selectBtn setBackgroundColor:[UIColor whiteColor]];
    _selectBtn=sender;
    self.textField.text = sender.currentTitle;
}

- (IBAction)searchBtnClick:(UIButton *)sender {
    
    [self.textField resignFirstResponder];
    NSString *textStr=[self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([textStr isEqualToString:@""])return;
    if ([self.historyArray containsObject:textStr]) {
        [self.historyArray removeObject:textStr];
    }
    [self.historyArray insertObject:textStr atIndex:0];
    NSDictionary *prama=@{@"name":[UserInfonCache sharedUserInfonCache].userName};
    [CachMethod saveData:self.historyArray at:prama with:HistorySearchCacheDataFile];
    NSArray *viewArr=[self.historyView subviews];
    for (UIView *view in viewArr) {
        [view removeFromSuperview];
    }
    [self createSearchHistoryBtn];
    [UIView animateWithDuration:0.7 animations:^{
        
        self.historyLabel.frame=CGRectMake(0, ScreenH, ScreenW, 20);
        self.historyView.frame=CGRectMake(0, ScreenH+20, ScreenW, ScreenH);
    }];
    
    [self.dataArray removeAllObjects];
    NSArray *search = [_listdata query:textStr];
    [self.dataArray addObjectsFromArray:search];
    [self.tableview reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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

#pragma mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    [UIView animateWithDuration:0.7 animations:^{
        self.historyLabel.frame=CGRectMake(0, 80, ScreenW, 20);
        self.historyView.frame=CGRectMake(0, 100, ScreenW, ScreenH);
    }];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    NSString *str=textField.text;
    NSLog(@"%@",str);
    [UIView animateWithDuration:0.7 animations:^{
        
        self.historyLabel.frame=CGRectMake(0, ScreenH, ScreenW, 20);
        self.historyView.frame=CGRectMake(0, ScreenH+20, ScreenW, ScreenH);
    }];
}



@end

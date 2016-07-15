//
//  TrainSearchViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/7/11.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "TrainSearchViewController.h"
#import "ButtonsViewController.h"
#import "FSCalendar.h"

@interface TrainSearchViewController ()<FSCalendarDelegate>

@property(nonatomic,strong)ButtonsViewController *canlendarView;
@property (weak, nonatomic) IBOutlet UITextField *fromText;
@property (weak, nonatomic) IBOutlet UITextField *toText;
- (IBAction)calendarBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *calendarLabel;
- (IBAction)sureBtnClick:(UIButton *)sender;

@end

@implementation TrainSearchViewController

-(ButtonsViewController *)canlendarView{

    if (!_canlendarView) {
        _canlendarView=[[ButtonsViewController alloc]init];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canlendarBGClick)];
        tap.numberOfTapsRequired=1;
//        [_canlendarView.view addGestureRecognizer:tap];
        _canlendarView.calendar.delegate=self;
    }
    return _canlendarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addChildViewController:self.canlendarView];
    
}

-(void)canlendarBGClick{

    [self.canlendarView.view removeFromSuperview];
}

- (IBAction)calendarBtnClick:(UIButton *)sender {
    
    
    [self.view addSubview:self.canlendarView.view];
}
- (IBAction)sureBtnClick:(UIButton *)sender {
}

#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSString *dateStr=[calendar stringFromDate:date format:@"yyyy-MM-dd"];
    NSLog(@"%s %@", __FUNCTION__, dateStr);
    self.calendarLabel.text=[NSString stringWithFormat:@"出发日期:%@",dateStr];
    [self canlendarBGClick];
}


@end

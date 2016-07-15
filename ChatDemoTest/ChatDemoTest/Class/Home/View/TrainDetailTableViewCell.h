//
//  TrainDetailTableViewCell.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/7/11.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trainType;
@property (weak, nonatomic) IBOutlet UILabel *trainNum;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *duration;



@end

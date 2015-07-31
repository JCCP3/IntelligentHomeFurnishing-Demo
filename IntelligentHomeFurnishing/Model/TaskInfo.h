//
//  TaskInfo.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/22.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskInfo : NSObject

@property (nonatomic ,strong)NSString *taskInfoID;//任务ID
@property (nonatomic ,strong)NSString *taskInfoName;//任务名称
@property (nonatomic ,strong)NSString *taskIndex; //子任务序号
@property (nonatomic ,strong)NSString *taskAction1; //是否激活第一个操作
@property (nonatomic ,strong)NSString *taskAction2; //是否激活第二个操作
@property (nonatomic ,strong)NSString *taskCenterControllerID; //集中器ID
@property (nonatomic ,strong)NSString *taskChildTaskID;
@property (nonatomic ,strong)NSString *taskCheck;
@property (nonatomic ,strong)NSString *taskExecutionTs1; //打开时间的毫秒
@property (nonatomic ,strong)NSString *taskExecutionTs2; //关闭时间的毫秒
@property (nonatomic ,strong)NSString *taskSwitchIndex; //开关序号
@property (nonatomic ,strong)NSString *taskType; //区分太阳时 、 周任务 、分隔任务
@property (nonatomic ,strong)NSString *taskType2;//为2时说明是嵌套任务
@property (nonatomic ,strong)NSString *taskWeek;//周序号
@property (nonatomic ,strong)NSString *taskPeriod;//循环周期毫秒数

-(void)setTaskInfoWithDataDic:(NSMutableDictionary *)dataDic;

@end

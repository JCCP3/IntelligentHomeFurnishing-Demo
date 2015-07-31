//
//  SwitchInfo.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/19.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchInfo : NSObject

@property (nonatomic ,strong)NSString *switchAtCenterControllerID; //开关所在控制器
@property (nonatomic ,strong)NSString *switchAtCenterControllerTerminalUID;
@property (nonatomic ,strong)NSString *switchAtCenterControllerName; //开关所在控制器名称
@property (nonatomic ,strong)NSString *switchAtCenterControllerStatus;//控制器状态
@property (nonatomic ,strong)NSString *switchIndex; //开关下标
@property (nonatomic ,strong)NSString *switchName; //开关名称
@property (nonatomic ,strong)NSString *switchStatus; //开关状态

@property (nonatomic ,assign)BOOL switchIsCloseSoon;
@property (nonatomic ,assign)BOOL switchIsOpenSoon;


-(void)setSwitchInfoWithDataDic:(NSMutableDictionary *)dataDic;

@end

//
//  IntegratedDeviceInfo.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/21.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegratedDeviceInfo : NSObject

@property (nonatomic ,strong)NSString *integratedDeviceID; //集成器ID
@property (nonatomic ,strong)NSString *integratedDeviceName;//集成器名称
@property (nonatomic ,strong)NSString *integratedDeviceCurrentDianLiu; //电流
@property (nonatomic ,strong)NSString *integratedDeviceCurrentDianYa; //电压
@property (nonatomic ,strong)NSString *integratedDeviceInsideWet;//室内湿度
@property (nonatomic ,strong)NSString *integratedDeviceInsideTemp; //室内温度
@property (nonatomic ,strong)NSString *integratedDeviceOutsideWet; //室外湿度
@property (nonatomic ,strong)NSString *integratedDeviceOutsideTemp;//室外温度

-(void)setIntegratedDeviceWithDataDic:(NSMutableDictionary *)dataDic;

@end

//
//  IntegratedDeviceInfo.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/21.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "IntegratedDeviceInfo.h"

@implementation IntegratedDeviceInfo

-(void)setIntegratedDeviceWithDataDic:(NSMutableDictionary *)dataDic{
    
    if([dataDic objectForKey:@"id"] && ![[dataDic objectForKey:@"id"] isEqual:@""] && ![[dataDic objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        
        _integratedDeviceID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"id"] intValue]];
    }
    
    if([dataDic objectForKey:@"name"] && ![[dataDic objectForKey:@"name"] isEqual:@""] && ![[dataDic objectForKey:@"name"] isKindOfClass:[NSNull class]]){
        
        _integratedDeviceName = [dataDic objectForKey:@"name"];
        
    }
    
    if([dataDic objectForKey:@"esCurrent"] && ![[dataDic objectForKey:@"esCurrent"] isEqual:@""] && ![[dataDic objectForKey:@"esCurrent"] isKindOfClass:[NSNull class]]){
        
        _integratedDeviceCurrentDianLiu = [NSString stringWithFormat:@"%.f",[[dataDic objectForKey:@"esCurrent"] floatValue]];
        
    }
    
    if([dataDic objectForKey:@"esVoltage"] && ![[dataDic objectForKey:@"esVoltage"] isEqual:@""] && ![[dataDic objectForKey:@"esVoltage"] isKindOfClass:[NSNull class]]){
        
        _integratedDeviceCurrentDianYa = [NSString stringWithFormat:@"%.f",[[dataDic objectForKey:@"esVoltage"] floatValue]];
    }
    
    if([dataDic objectForKey:@"terminalUID"] && ![[dataDic objectForKey:@"terminalUID"] isEqual:@""] && ![[dataDic objectForKey:@"terminalUID"] isKindOfClass:[NSNull class]]){
        
        
    }
    
}

@end

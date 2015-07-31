//
//  SwitchInfo.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/19.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "SwitchInfo.h"

@implementation SwitchInfo

-(void)setSwitchInfoWithDataDic:(NSMutableDictionary *)dataDic{
    
    if([dataDic objectForKey:@"centerControllerId"] && ![[dataDic objectForKey:@"centerControllerId"] isEqual:@""] && ![[dataDic objectForKey:@"centerControllerId"] isKindOfClass:[NSNull class]]){
        
        _switchAtCenterControllerID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"centerControllerId"] intValue]];
    }
    
    if([dataDic objectForKey:@"centerControllerTerminalUID"] && ![[dataDic objectForKey:@"centerControllerTerminalUID"] isEqual:@""] && ![[dataDic objectForKey:@"centerControllerTerminalUID"] isKindOfClass:[NSNull class]]){
        _switchAtCenterControllerTerminalUID = [dataDic objectForKey:@"centerControllerTerminalUID"];
    }
    
    
    if([dataDic objectForKey:@"centerControllerName"] && ![[dataDic objectForKey:@"centerControllerName"] isEqual:@""] && ![[dataDic objectForKey:@"centerControllerName"] isKindOfClass:[NSNull class]]){
        
        _switchAtCenterControllerName = [dataDic objectForKey:@"centerControllerName"];
    }
    
    if([dataDic objectForKey:@"centerControllerStatus"] && ![[dataDic objectForKey:@"centerControllerStatus"] isEqual:@""] && ![[dataDic objectForKey:@"centerControllerStatus"] isKindOfClass:[NSNull class]]){
        
        _switchAtCenterControllerStatus = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"centerControllerStatus"] intValue]];
    }
    
    
    if([dataDic objectForKey:@"switchIndex"] && ![[dataDic objectForKey:@"switchIndex"] isEqual:@""] && ![[dataDic objectForKey:@"switchIndex"] isKindOfClass:[NSNull class]]){
        
        _switchIndex = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"switchIndex"] intValue]];
        
    }
    
    
    if([dataDic objectForKey:@"switchName"] && ![[dataDic objectForKey:@"switchName"] isEqual:@""] && ![[dataDic objectForKey:@"switchName"] isKindOfClass:[NSNull class]]){
        
        _switchName = [dataDic objectForKey:@"switchName"];
        
    }
    
    if([dataDic objectForKey:@"switchStatus"] && ![[dataDic objectForKey:@"switchStatus"] isEqual:@""] && ![[dataDic objectForKey:@"switchStatus"] isKindOfClass:[NSNull class]]){
        
        _switchStatus = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"switchStatus"] intValue]];
    }
    
}

@end

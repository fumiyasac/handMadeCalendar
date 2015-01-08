//
//  DeviseSize.m
//  handmadeCalenderSampleOfObjectiveC
//
//  Created by 酒井文也 on 2015/01/08.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "DeviseSize.h"

@implementation DeviseSize

int deviceBoundsHeight;
int deviceBoundsWidth;

//現在起動中のデバイス名の取得メソッド
+ (NSString *)getNowDisplayDevice
{
    deviceBoundsWidth = [[UIScreen mainScreen] bounds].size.width;
    deviceBoundsHeight = [[UIScreen mainScreen] bounds].size.height;
    
    NSString *deviceType = [NSString new];
    
    //iPhone4s
    if(deviceBoundsWidth == 320 && deviceBoundsHeight == 480){
        
        deviceType = @"iPhone4s";
        
        //iPhone5またはiPhone5s
    }else if (deviceBoundsWidth == 320 && deviceBoundsHeight == 568){
        
        deviceType = @"iPhone5";
        
        //iPhone6
    }else if (deviceBoundsWidth == 375 && deviceBoundsHeight == 667){
        
        deviceType = @"iPhone6";
        
        //iPhone6plus
    }else if (deviceBoundsWidth == 414 && deviceBoundsHeight == 736){
        
        deviceType = @"iPhone6plus";
        
    }
    return deviceType;
}

@end

//
//  Tools.h
//  BluetoothLED
//
//  Created by 奇鹭 on 2017/12/9.
//  Copyright © 2017年 xieyongxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormatModal.h"
@interface Tools : NSObject

@property (nonatomic, strong)NSMutableArray *modelArray;

@property (nonatomic, strong)NSMutableArray *settingModelArray;

@property (nonatomic, strong)NSMutableArray *pixelsArray;

+ (instancetype)shareInstance;

+ (void)open_file_name:(const char *)file list:(unsigned char*)list_buf;

+ (NSInteger)calculateTextBytes:(NSString *)text;

+ (NSInteger)calculateTextBits:(FormatModal *)model;

+ (NSMutableArray *)getDataFromDZKFile:(FormatModal *)model;

- (void)calculateBinary:(NSInteger)hex calculateTimes:(NSInteger)times;

@end

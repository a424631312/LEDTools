//
//  FormatModal.h
//  BluetoothLED
//
//  Created by 奇鹭 on 2017/12/9.
//  Copyright © 2017年 xieyongxu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIColor;
@interface FormatModal : NSObject<NSCopying>

@property (nonatomic, strong)NSString *text;

@property (nonatomic, strong)NSString *textSize;

@property (nonatomic, assign, readonly)NSInteger textSizeNumber;

@property (nonatomic, strong)NSString *textFont;

@property (nonatomic, assign, readonly)NSInteger textFontNumber;

@property (nonatomic, assign, readonly)NSInteger textwidthNumber;

@property (nonatomic, assign)NSInteger textColour;

@property (nonatomic, strong)UIColor *textUIColor;

@property (nonatomic, assign)NSInteger textBytes;

@property (nonatomic, strong)NSString *textLength;

@property (nonatomic, assign)NSInteger textNumber;

@property (nonatomic, assign)NSInteger textEffect;

@property (nonatomic, strong)NSMutableArray *datasArray;

@property (nonatomic, strong, readonly)NSMutableArray *pixelArray;

@property (nonatomic, assign)NSInteger cellHeight;

@property (nonatomic, assign)NSInteger speed;

@property (nonatomic, assign)NSInteger brightness;

@end

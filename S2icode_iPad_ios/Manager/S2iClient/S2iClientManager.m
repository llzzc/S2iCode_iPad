//
//  S2iClientManager.m
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iClientManager.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "SerialNoModel.h"

#import "S2iRestClientInit.h"
#import "ClientInitData.h"
#import "RestRequestClientInit.h"



@implementation S2iClientManager

single_implementation(S2iClientManager)

- (DeviceConfigInfoModel*) getDeviceConfigInfo {
    if (deviceConfigInfoModel) {
        return deviceConfigInfoModel;
    } else {
        return NULL;
    }
}


- (SoftwareVersionModel*) getSoftwareVersionModel {
    return softwareVersionModel;
}
 
#pragma mark 初始化
- (id)init
{
    S2iLog(@"init");
    [self checkUUID];
    
    deviceConfigInfoModel = [[DeviceConfigInfoModel alloc] init];
    //qrWhiteUrls = [[NSArray<NSString*> alloc] init];
    NSString* clientInitJSON = [S2iConfig sharedS2iConfig].clientInit;
    S2iLog(@"%@", clientInitJSON);
    
    if (clientInitJSON == nil || clientInitJSON.length <= 0) {
        NSDictionary* appClientInitJSON = [S2iTool readInitJson: [S2iClientManager deviceModel]];
        [deviceConfigInfoModel initWithDictionary: [appClientInitJSON valueForKey:@"DeviceConfigInfo"]];
        qrWhiteUrls = [appClientInitJSON valueForKey:@"QRWhiteUrls"];
    } else {
        NSMutableDictionary* clientInitDictionary = [self convertJSON2Dict:clientInitJSON];
        
        [deviceConfigInfoModel initWithDictionary: [clientInitDictionary valueForKey:@"DeviceConfigInfo"]];
        qrWhiteUrls = [clientInitDictionary valueForKey:@"QRWhiteUrls"];
    }
    
    //2. 数据库管理类
    _sqliteManager = [[S2iSqliteManager alloc] init];
    
    //3. GPS管理类
    _locationManager = [[S2iLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //4. 配置文件管理类（config）
    [[S2iConfig sharedS2iConfig] setupConfig];
    
    if ([S2iConfig sharedS2iConfig].gps) {
        [self startGPS];
    }
    
    [self requestClientInit];
    
    return self;
}

- (void) requestClientInit {
    S2iRestClientInit* client = [[S2iRestClientInit alloc] init];
    RestRequestClientInit* requestClientInit = [[RestRequestClientInit alloc] init];
    S2iLog(@"RequestClientInit");
    [client getClientInit: requestClientInit withSuccess:^(ClientInitData* clientInitData) {
        S2iLog(@"ClientInitData %@", [clientInitData.Data debugDescription]);
        if (clientInitData.Code && [clientInitData.Code intValue] == 10000) {
            deviceConfigInfoModel = clientInitData.Data.DeviceConfigInfo;
            CGFloat zoom = [S2iConfig sharedS2iConfig].zoom;
            if (zoom > [deviceConfigInfoModel.MaxZoom floatValue] || zoom < [deviceConfigInfoModel.MinZoom floatValue]) {
                [[S2iConfig sharedS2iConfig] setZoom:[deviceConfigInfoModel.MinZoom floatValue]];
            }
            
            if ([self checkSoftwareUpdateWithLastVersion:clientInitData.Data.SoftwareVersion]) {
                [[S2iConfig sharedS2iConfig] setHideUpdateBadge:NO];
            }
            
            softwareVersionModel = clientInitData.Data.SoftwareVersion;
            qrWhiteUrls = clientInitData.Data.QRWhiteUrls;
            
            NSString* recvData = [self convertObjectToJson:clientInitData.Data];
            [[S2iConfig sharedS2iConfig] setClientInit:recvData];
            
            //2. 把设备ID号，保持到配置文件中
            [[S2iConfig sharedS2iConfig] setDeviceId: [clientInitData.Data.DeviceConfigInfo.DeviceId intValue] ];
            
            if ([_delegate respondsToSelector:@selector(receivedWithPics:)]) {
                [_delegate receivedWithPics: clientInitData.Data.SlidePictures];
            }
            
            [self checkSoftwareUpdate];
        }
    } withFailure:^(NSError *error) {
        S2iLog(@"Error %@", [error description]);
    }];

}

- (BOOL) checkSoftwareUpdateWithLastVersion: (SoftwareVersionModel*) newSoftwareVersion {
    if ([softwareVersionModel.MajorNumber intValue] < [newSoftwareVersion.MajorNumber intValue]) {
        return YES;
    } else if ([softwareVersionModel.MajorNumber intValue] == [newSoftwareVersion.MajorNumber intValue]){
        if ([softwareVersionModel.MinorNumber intValue] < [newSoftwareVersion.MinorNumber intValue]) {
            return YES;
        } else if ([softwareVersionModel.MinorNumber intValue] == [newSoftwareVersion.MinorNumber intValue]){
            if ([softwareVersionModel.RevisionNumber intValue] < [newSoftwareVersion.RevisionNumber intValue]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL) hasSoftwareUpdate {
    BOOL update = NO;
    if (softwareVersionModel) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSArray *versions = [version componentsSeparatedByString:@"."];
        if (versions && [versions count] == 3) {
            if ([softwareVersionModel.MajorNumber intValue] > [[versions objectAtIndex:0] intValue]) {
                update = YES;
            } else if ([softwareVersionModel.MajorNumber intValue] == [[versions objectAtIndex:0] intValue]){
                if ([softwareVersionModel.MinorNumber intValue] > [[versions objectAtIndex:1] intValue]) {
                    update = YES;
                } else if ([softwareVersionModel.MinorNumber intValue] == [[versions objectAtIndex:1] intValue]){
                    if ([softwareVersionModel.RevisionNumber intValue]> [[versions objectAtIndex:2] intValue]) {
                        update = YES;
                    }
                }
            }
        }
    }
    
    return update;
}

- (void) checkSoftwareUpdate {
    if ([self hasSoftwareUpdate]) {
        if ([_delegate respondsToSelector:@selector(softwareUpdateAvailable:)]) {
            [_delegate softwareUpdateAvailable: softwareVersionModel];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(softwareUpdateAvailable:)]) {
            [_delegate softwareUpdateAvailable: nil];
        }
    }
}

- (NSMutableDictionary*) convertJSON2Dict:(NSString*) json {
    if (json) {
        NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        NSMutableDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

        if (error == nil) {
            return dJSON;
        } else {
            return nil;
        }
    } else {
        return nil;
    }

}

- (NSString*) convertObjectToJson : (id) object {
    if ([NSJSONSerialization isValidJSONObject:((ClientInitDataModel*)object)]) {
        NSError* error = nil;
        NSData *jsd = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsd encoding:NSUTF8StringEncoding];
        return jsonString;
    } else {
        NSDictionary* dic = [((ClientInitDataModel*)object) convertToDictionary];
        NSError* error = nil;
        NSData *jsd = [NSJSONSerialization dataWithJSONObject:dic options: 0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsd encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

#pragma mark - 新建一个图像文件名
+ (NSString *)newImageFileName
{
    NSDate * startTime = [NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    //s2i码图像名称是用 格式化时间 命名的。 图片类型：jpg
    NSString * strReturn = [[NSString alloc] initWithFormat:@"%@.jpg", [dateFormat stringFromDate:startTime]];
    return strReturn;
}



#pragma mark - 保存S2i图像到沙盒中
//image - 上传解码图像
- (NSString*)saveS2iImage:(UIImage *)image
{
    if (!image)
        return nil;
    
    //存入沙盒的图像名称
    s2iImageName = [S2iClientManager newImageFileName];
    
    NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/s2iImages"];
    BOOL isDir = YES;
    NSFileManager * fm= [NSFileManager defaultManager];
    NSError * error;
    
    //判，是否有jpgPath的文件夹，没有创建
    if(![fm fileExistsAtPath:jpgPath isDirectory:&isDir])
    {
        if(![fm createDirectoryAtPath:jpgPath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            S2iLog(@"Error: Create folder failed");
        }
    }
    NSString * jpgFilePath = [[NSString alloc] initWithFormat:@"%@/%@", jpgPath, s2iImageName];
    [UIImageJPEGRepresentation(image, F_DEF_LOCALJPGCOMPRESS) writeToFile:jpgFilePath atomically:YES];
    S2iLog(@"解码图像名称：%@", s2iImageName);
    S2iLog(@"解码图像沙盒路径：%@", jpgFilePath);
    return s2iImageName;
}


#pragma mark 处理服务器接口的响应值

- (void)addDecPdtWithImageName:(NSString *)decImageName model:(S2iDecPdtModel *)model {
    //1> 把解码信息，插入数据库中。
    [_sqliteManager addDecPdtWithImageName:s2iImageName model:model];
}


#pragma mark - UIAlertViewDelegate
#pragma mark 监听alert按钮事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    S2iLog(@"buttonIndex: %ld", (long)buttonIndex);
    
    if (_softupModel) {
        if (buttonIndex==0) {
            //关闭
            S2iLog(@"关闭！");
        } else if(buttonIndex==1) {
            //下载
            [self openAppStoreWithUrl:_softupModel.updateSite];
        }
    }
}

#pragma mark - 跳转至AppStore下载
- (void)openAppStoreWithUrl:(NSString *)aUrl {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:aUrl]];
}


#pragma mark - 取得当前版本号， 如："2.2.4"
- (NSString *)getSoftUpVersion:(S2iSoftUpModel *) model {
    int majorVersion = 0;
    int minorVersion = 0;
    int microVersion = 0;
    
    if (model.majorVersionNumber) {
        int version = [model.majorVersionNumber intValue];
        minorVersion = version%10;
        majorVersion = version/10;
    }
    if (model.minorVersionNumber) {
        microVersion = [model.minorVersionNumber intValue];
    }
    return [NSString stringWithFormat:@"%d.%d.%d", majorVersion, minorVersion, microVersion];
} 


#pragma mark - 判断是否有新版本
/***************************************************
 *  功能：
 *      判断是否有新版本
 *  参数：
 *      aOldVersion - 旧版本号
 ***************************************************/
- (BOOL)hasNewVersion:(NSString *)aOldVersion softupModel:(S2iSoftUpModel * )model {
    BOOL bReturn = NO;
    NSArray * oldVersionArray = [aOldVersion componentsSeparatedByString:@"."];
    NSArray * newVersionArray = [[self getSoftUpVersion:model] componentsSeparatedByString:@"."];
    if (newVersionArray.count == 3 && oldVersionArray.count == 3) {
        for (int i = 0; i < 3; i ++) {
            int nVersion = [[newVersionArray objectAtIndex:i] intValue];
            int oVersion = [[oldVersionArray objectAtIndex:i] intValue];
            S2iLog(@"new: %d, old: %d", nVersion, oVersion);
            if (nVersion > oVersion) {
                bReturn = YES;
            } else if (nVersion < oVersion) {
                bReturn = NO;
                break;
            }
        }
    }
    S2iLog(@"判断是否有新版本====%d", bReturn);
    return bReturn;
}

#pragma mark - S2iLocationManagerDelegate

#pragma mark 当前设备GPS坐标
- (void)locationGPS:(CLLocation *)location {
    _locationGPS = location;
    //S2iLog(@"current Location: %@-%@", @([_locationGPS coordinate].latitude), @([_locationGPS coordinate].longitude));
}

#pragma mark - 获取设备的型号
/****************************************************************************************************
 *
 *  功能：
 *      获取设备的型号
 *  返回：
 *      枚举值
 *  备注：
 *
 *      iPhone手机设备的型号，列表如下：
 *
 *      if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
 *      if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
 *      if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
 *      if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
 *      if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
 *      if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
 *      if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
 *      if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
 *      if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
 *      if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
 *      if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
 *      if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
 *      if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
 *      if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
 *      if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
 *
 ****************************************************************************************************/
+ (DeviceMode)deviceModel
{
    NSString * platform = nil;
    char buffer[32];
    size_t length = sizeof(buffer);
    if (sysctlbyname("hw.machine", &buffer, &length, NULL, 0) == 0) {
        platform = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
    }
    
    //S2iLog(@"platform: %@", platform);
    
    //iPhone4
    if ([platform rangeOfString:@"iPhone3,"].location != NSNotFound) {
        return IPHONE_4;
    } else if ([platform rangeOfString:@"iPhone4,"].location != NSNotFound) {
        return IPHONE_4S;
    } else if ([platform rangeOfString:@"iPhone5,"].location != NSNotFound) {
        if ([platform isEqualToString: @"iPhone5,1"] || [platform isEqualToString: @"iPhone5,2"])
            return IPHONE_5;
        else
            return IPHONE_5C;
    } else if ([platform rangeOfString:@"iPhone6,"].location != NSNotFound) {
        return IPHONE_5S;
    } else if ([platform rangeOfString:@"iPhone7,"].location != NSNotFound) {
        if ([platform isEqualToString: @"iPhone7,2"])
            return IPHONE_6;
        else if([platform isEqualToString: @"iPhone7,1"])
            return IPHONE_6PLUS;
        else
            return IPHONE_OTHER;
    } else if ([platform rangeOfString:@"iPhone8,"].location != NSNotFound) {
        if ([platform isEqualToString: @"iPhone8,2"])
            return IPHONE_6SPLUS;
        else if([platform isEqualToString: @"iPhone8,1"])
            return IPHONE_6S;
        else if([platform isEqualToString: @"iPhone8,4"])
            return IPHONE_5SE;
        else
            return IPHONE_OTHER;
    } else
        return IPHONE_OTHER;
}



#pragma mark - 判断图像清晰度
/*********************************************
 *  功能：
 *      判断图像清晰度
 *  返回：
 *      小于60，返回NO，其余返回YES
 *********************************************/
- (EnumImageHistScoreLevel)isCapturedImageSharp {
    S2iLog(@"isCapturedImageSharp: %ld", (long)imageHistScore);
    EnumImageHistScoreLevel enumLevel = ImageHistScoreLevel_Red;
    
    if (imageHistScore >= N_IMAGE_HISTSCORE_YELLOW_LEVEL)
        enumLevel = ImageHistScoreLevel_Green;
    else if (imageHistScore < N_IMAGE_HISTSCORE_YELLOW_LEVEL && imageHistScore > N_IMAGE_HISTSCORE_RED_LEVEL)
        enumLevel = ImageHistScoreLevel_Yellow;
    else
        enumLevel = ImageHistScoreLevel_Red;
    return enumLevel;
}

- (NSInteger) getImageHistScore {
    return imageHistScore;
}

#pragma mark - 播放解码成功提示音
- (void)playSound
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //如果无法再下面播放，可以尝试在此播放
        //AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    AudioServicesPlaySystemSound(shake_sound_male_id);
    //让手机震动
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - 历史记录中S2i解码图像
- (NSMutableArray *)loadS2iImagesHistory {
    if (s2iImagesList)
        s2iImagesList = nil;
    
    //1. 初始化图像数组
    s2iImagesList = [[NSMutableArray alloc] init];
    NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/s2iImages"];
    //S2iLog(@"jpgPath===%@", jpgPath);
    
    NSArray * dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:jpgPath error:nil];
    //S2iLog(@"dir: %@", [dirContents description]);
    
    for (long i = [dirContents count]-1; i >=0 ; i--) {
        S2iDecPdtModel * model = [_sqliteManager selectDecPdtWithImageName:[dirContents objectAtIndex:i]];
        if (model) {
            [s2iImagesList addObject:model];            
        }
    }
    return s2iImagesList;
}


#pragma mark - 历史记录中QR解码图像
- (NSMutableArray *)loadQRImagesHistory {
    if (qrImagesList)
        qrImagesList = nil;
    
    //1. 初始化图像数组
    qrImagesList = [[NSMutableArray alloc] init];
    NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/qrImages"];
    //S2iLog(@"jpgPath===%@", jpgPath);
    
    NSArray * dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:jpgPath error:nil];
    //S2iLog(@"dir: %@", [dirContents description]);
    
    for (long i = [dirContents count]-1; i >=0 ; i--) {
        S2iQRModel * model = [_sqliteManager selectQRWithImageName:[dirContents objectAtIndex:i]];
        [qrImagesList addObject:model];
        S2iLog(@"QRINf0o=-=====%@", model.qrInfo);
        
    }
    return qrImagesList;
}



#pragma mark - 删除“小章解码”的数据库中的数据
- (void)removeWithDecPdtModel:(S2iDecPdtModel *)model {
    if (!model)
        return;
    
    NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/s2iImages"];
    NSString* jpgFilePath = [NSString stringWithFormat:@"%@/%@", jpgPath, model.decImageName];
    
    S2iLog(@"s2iImage: %@", jpgFilePath);
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: jpgFilePath] == YES) {
        S2iLog (@"File exists");
        if ([filemgr removeItemAtPath: jpgFilePath error: NULL]  == YES)
            S2iLog (@"Remove successful");
        else
            S2iLog (@"Remove failed");
    }
    else
        S2iLog (@"File not found");
    
    //1. 数据库删除一行数据
    [_sqliteManager deleteDecPdtModel:model.decImageName];
}




#pragma mark - 删除“QR”的数据库中的数据
- (void)removeWithQRModel:(S2iQRModel *)model {
    if (!model)
        return;
    
    NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/qrImages"];
    NSString* jpgFilePath = [NSString stringWithFormat:@"%@/%@", jpgPath, model.qrImageName];
    
    S2iLog(@"qrImage: %@", jpgFilePath);
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: jpgFilePath] == YES) {
        S2iLog (@"File exists");
        if ([filemgr removeItemAtPath: jpgFilePath error: NULL]  == YES)
            S2iLog (@"Remove successful");
        else
            S2iLog (@"Remove failed");
    } else {
        S2iLog (@"File not found");
    }
    //1. 数据库删除一行数据
    [_sqliteManager deleteQRModel:model.qrImageName];
}

#pragma mark - 处理图像
/********************************************************************************
 *  功能：
 *      处理图像
 *  参数：
 *      aImage - 图像数据
 *      aCropFrame - 剪切的区域
 *  返回：
 *      剪切后的S2I图像数据
 ********************************************************************************/
- (UIImage *)processImage:(UIImage *)aImage withCropFrame:(CGRect)aCropFrame {
    UIImage * s2iImage = nil;
    if (aImage) {
        if (aImage.size.width == aCropFrame.size.width && aImage.size.height == aCropFrame.size.height) {
            s2iImage = [[UIImage alloc] initWithData: UIImageJPEGRepresentation(aImage, F_DEF_LOCALJPGCOMPRESS)] ;
        } else {
            UIImage* cropImage = nil;
            //UIImage* grayImage = nil;
            UIImage* resizeImage = nil;
            UIImage* canvasImage = nil;
            
            cropImage = [S2iImageManager getSubImageFrom:aImage WithRect:aCropFrame];
            if (cropImage.size.width != N_S2I_RAW_IMAGE_SIZE) {
                resizeImage = [S2iImageManager imageWithImage:cropImage scaledToSize: CGSizeMake(N_S2I_RAW_IMAGE_SIZE, (N_S2I_RAW_IMAGE_SIZE*cropImage.size.height)/cropImage.size.width)];
            } else {
                resizeImage = cropImage;
            }
            CGSize imgSize = CGSizeMake(640, 640);
            canvasImage = [S2iImageManager canvasImage:resizeImage toSize:imgSize withColor:[UIColor whiteColor]];
            //grayImage = [S2iImageManager convertToGreyscale2:canvasImage];
            s2iImage = [[UIImage alloc] initWithData: UIImageJPEGRepresentation(canvasImage,F_DEF_LOCALJPGCOMPRESS)] ;
        }
    }
    return s2iImage;
}


#pragma mark - 网络是否可用
+ (void) isNetworkReachableWithCompleted: (BlockType) blockDemo {
    KSReachability *reachability2 = [KSReachability reachabilityToInternet];
    reachability2.onReachabilityChanged = ^(KSReachability* reachability)
    {
        S2iLog(@"Reachability changed to %d (blocks)", reachability.reachable);
        blockDemo(reachability.reachable);
    };
}



#pragma mark - QR码存到数据库
- (void)insertTableQRWithInfo:(NSString *)info image:(UIImage *)qrImage {
    //1. 存到沙盒中
    [self saveQRImage:qrImage];
    
    //2. 保存到数据库中
    S2iQRModel * model = [S2iQRModel qrWithImageName:qrImageName qrInfo:info];
    [_sqliteManager addQRWithImageName:qrImageName model:model];
}


#pragma mark - 保存S2i图像到沙盒中
//image - 上传解码图像
- (void)saveQRImage:(UIImage *)image {
    if (!image)
        return;
    
    //存入沙盒的图像名称
    qrImageName = [S2iClientManager newImageFileName];
    
    NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/qrImages"];
    BOOL isDir = YES;
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error;
    
    //判，是否有jpgPath的文件夹，没有创建
    if(![fm fileExistsAtPath:jpgPath isDirectory:&isDir]) {
        if(![fm createDirectoryAtPath:jpgPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            S2iLog(@"Error: Create folder failed");
        }
    }
    
    NSString * jpgFilePath = [[NSString alloc] initWithFormat:@"%@/%@", jpgPath, qrImageName];
    [UIImageJPEGRepresentation(image, F_DEF_LOCALJPGCOMPRESS) writeToFile:jpgFilePath atomically:YES];
    S2iLog(@"解码图像名称：%@", qrImageName);
    S2iLog(@"解码图像沙盒路径：%@", jpgFilePath);
}

- (void) startGPS {
    [_locationManager startLocation];   //开启GPS
}

- (void) startGPSwithCompletedHandler: (void (^)())handler {
    [_locationManager startLocationWithCompleteHandler:handler];   //开启GPS
}

- (void) stopGPS {
    [_locationManager stopLocation];   //开启GPS
    _locationGPS = nil;
}

- (CLLocation*) getCurrentLocation {
    return _locationGPS;
}

- (void) checkUUID {
    NSString* UUID = [[S2iConfig sharedS2iConfig] UUID];
    if (UUID && UUID.length > 0) {
        S2iLog(@"UUID is %@", UUID);
    } else {
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [[S2iConfig sharedS2iConfig] setUUID:identifierForVendor];
        //NSString* UUID = [[S2iConfig sharedS2iConfig] UUID];
        //S2iLog(@"UUID is updated to %@", UUID);
    }
}

- (BOOL) isQRWhiteUrl: (NSString*) url {
    
    if (qrWhiteUrls && url) {
        for (NSString* qrWhiteUrl in qrWhiteUrls) {
            if([url rangeOfString:qrWhiteUrl].location != NSNotFound) {
                return YES;
            }
        }
    }
    return NO;
}

@end





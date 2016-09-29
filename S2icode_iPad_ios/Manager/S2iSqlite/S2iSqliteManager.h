//
//  S2iSqliteManager.h
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：数据库管理类
    
    一、简单了解Sqlite3
     SQLite3是一款开源的嵌入式关系类型数据库， 可移植性好、易使用、内存开销小。
     SQLite3是无类型的，意味着可以保持任何类型的数据到任意表任意字段。
     SQLite3常用的5中数据类型：text/integer/float/boolean/blob。
     在IOS中要使用SQLite3，需要添加库文件：libsqlite3.bylib,
        并导入主头文件#import <sqlite3.h>，这是一个C语言的库。
 
    二、 基本操作
     1. 创建数据库（sqlite3_opendb）
     2. 单步执行操作 (sqlite3_exec)
     - 创建数据库表
     - 数据操作
     · 插入数据
     · 更新数据
     · 删除数据
     3. 查询操作
     - sqlite3_prepare_v2 检查sql合法性
     - sqlite3_step 逐行获取查询结果
     - sqlite3_coloum_xxx 获取对应类型的内容
     - sqlite3_finalize 释放stmt


 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "S2iDecPdtModel.h"
#import "S2iQRModel.h"







@interface S2iSqliteManager : NSObject
{
    sqlite3 * m_pDb;        //数据库实例
}





/**
 *  增加 - 小章解码
 *
 *  @param decImagePath       解码图像在沙盒中路径
 *  @param deleteDecPdtModel  小章解码数据模型
 */
- (void)addDecPdtWithImageName:(NSString *)decImageName
                         model:(S2iDecPdtModel *)model;


/**
 *  删除 - 小章解码
 *
 *  @param decImageName 解码图像名称
 */
- (void)deleteDecPdtModel:(NSString *)decImageName;




/**
 *  根据“解码图像名称”，查询
 *
 *  @param imageName 解码图像名称
 *
 *  @return 小章解码模型
 */
- (S2iDecPdtModel *)selectDecPdtWithImageName:(NSString *)imageName;





/**
 *  增加QR码
 *
 *  @param qrImageName QR解码图像在沙盒中的路径
 *  @param model       QR数据模型
 */
- (void)addQRWithImageName:(NSString *)qrImageName
                     model:(S2iQRModel *)model;


/**
 *  删除QR码
 *
 *  @param qrImageName QR码图像名称
 */
- (void)deleteQRModel:(NSString *)qrImageName;

/**
 *  根据“QR码图像名称”，查询
 *
 *  @param imageName QR图像米名称
 *
 *  @return QR数据模型
 */
- (S2iQRModel *)selectQRWithImageName:(NSString *)imageName;



@end

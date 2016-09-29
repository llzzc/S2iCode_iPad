//
//  S2iSqliteManager.m
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iSqliteManager.h"


/**
 *  数据库名称
 */
NSString * STR_DATABASE_NAME = @"S2iDB.db";
/**
 *  小章解码表
 */
NSString * STR_TABLENAME_DECPDT = @"tbl_DecPdt";
/**
 *  QR码表
 */
NSString * STR_TABLENAME_QR = @"tbl_QR";



@implementation S2iSqliteManager


#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    
    //1. 初始化数据库并创建数据库表
    [self setupDB];
    
    
    return self;
}




#pragma mark - 打开数据库，如不存在，则创建。
- (void)setupDB
{
    //生成存放在沙盒中的数据库完整路径
    NSString * strDocDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * strDbName = [strDocDir stringByAppendingPathComponent: STR_DATABASE_NAME];
    S2iLog(@"数据库===%@", strDbName);
    
    //sqlite3 数据库的链接，基于该链接可以进行数据库操作
    if (SQLITE_OK == sqlite3_open(strDbName.UTF8String, &m_pDb))
    {
        S2iLog(@"创建/打开数据库成功！");
        
        //如果数据库创建成功！
        //1. 创建“小章解码”表
        [self setupDecPdtTable];
        
        //2. 创建“QR”表
        [self setupQRTable];
        
    }
    else
    {
        S2iLog(@"创建/打开数据库失败！");
    }
}




#pragma mark - 创建tbl_DecPdt表
/**
 *  1. 表名：tbl_DecPdt
 *  2. 使用DBManager创建，把生成的代码赋值过来就OK了
 *  3. IF NOT EXISTS
 *  4. IOS把id设为自增，在添加数据的时候，也要用null站位，不能不写。
 *  5. DecImage是解码图像二进制数据。//暂时用text类型，不行换varchar。
 */
- (void)setupDecPdtTable
{
    NSString * strSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ \
                         (Id integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, \
                         DecImageName text, \
                         FromDate text, \
                         SerialNo text,\
                         CompanyName text, \
                         DataContent text, \
                         DogId text, \
                         ImgQlt text, \
                         NanoCount text, \
                         CompanyUrl text, \
                         ProductUrl text, \
                         PdtUseType text, \
                         PdtTraceabilityUrl text, \
                         ColorCode text, \
                         ColorCodeInfo text, \
                         ShapeScore text, \
                         HistScore text, \
                         QltScore text, \
                         TotalScore text, \
                         MaxDecScore text, \
                         MinDecScore text, \
                         DecLevel text, \
                         CurrentNumber text, \
                         Description text, \
                         PdtDecRecordList text)",
                         STR_TABLENAME_DECPDT];
    
    char * pErrorMsg;
    if (SQLITE_OK ==  sqlite3_exec(m_pDb, strSql.UTF8String, NULL, NULL, &pErrorMsg))
    {
        S2iLog(@"创建 tbl_DecPdt 数据表成功!");
    }
    else
    {
        S2iLog(@"创建 tbl_DecPdt 数据表失败!");
    }
}


#pragma mark - 增删改查方法
- (void)execSql:(NSString *)sql msg:(NSString*)msg
{
    char * pErrorMsg;
    if (SQLITE_OK ==  sqlite3_exec(m_pDb, sql.UTF8String, NULL, NULL, &pErrorMsg))
    {
        S2iLog(@"%@成功!", msg);
    }
    else
    {
        S2iLog(@"%@失败 - %s!", msg, pErrorMsg);
    }
}






#pragma mark 小章解码

#pragma mark - 增加S2i码
/**
 *  小章解码
 *
 *  @param decImagePath 解码图像沙盒路径
 *  @param model        解码实体类
 */
- (void)addDecPdtWithImageName:(NSString *)decImageName
                         model:(S2iDecPdtModel *)model
{
    NSString * strSql = [NSString stringWithFormat: @"INSERT INTO %@ VALUES \
                         (null,'%@','%@','%@','%@','%@','%@','%@','%@','%@', \
                         '%@','%@', '%@','%@','%@','%@','%@','%@','%@','%@', \
                         '%@','%@','%@','%@','%@')",
                         STR_TABLENAME_DECPDT,
                         decImageName,
                         model.fromDate,
                         model.serialNo,
                         model.companyName,
                         model.dataContent,
                         model.dogId,
                         model.imgQlt,
                         model.nanoCount,
                         model.companyUrl,
                         model.productUrl,
                         model.pdtUseType,
                         model.pdtTraceabilityUrl,
                         model.colorCode,
                         model.colorCodeInfo,
                         model.shapeScore,
                         model.histScore,
                         model.qltScore,
                         model.totalScore,
                         model.maxDecScore,
                         model.minDecScore,
                         model.decLevel,
                         model.currentNumber,
                         model.descriptionStr,
                         model.pdtDecRecordList
                         ];
    
    //执行SQL语句
    [self execSql:strSql msg:@"添加"];
}





#pragma mark - 删除S2i码
- (void)deleteDecPdtModel:(NSString *)decImageName
{
    NSString * strSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE DecImageName='%@'", STR_TABLENAME_DECPDT, decImageName];
    
    //执行SQL语句
    [self execSql:strSql msg:@"删除"];
}





#pragma mark - 全部查询S2i码
- (S2iDecPdtModel *)selectDecPdtWithImageName:(NSString *)imageName
{
    NSString * strSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE DecImageName='%@'", STR_TABLENAME_DECPDT, imageName];
    
    S2iDecPdtModel * model = nil;
    
    //1. 评估准备SQL语法是否正确
    sqlite3_stmt * pStmt = NULL;
    if (SQLITE_OK == sqlite3_prepare_v2(m_pDb, strSql.UTF8String, -1, &pStmt, NULL))
    {
        
        //2. 如果能正常查询，调用单步执行方法， 依次取得查询结果
        //如果得到一行记录
        while (SQLITE_ROW == sqlite3_step(pStmt))
        {
            //3.获取/显示查询结果
            
            //1)主键ID，唯一标识
            int nId = sqlite3_column_int(pStmt, 0);
            
            //2)解码图像图像名称
            const unsigned char * decImageName = sqlite3_column_text(pStmt, 1);
            NSString * decImageNameUTF8 = [NSString stringWithUTF8String:(const char *)decImageName];
            
            //5)fromDate
            const unsigned char * fromDate = sqlite3_column_text(pStmt, 2);
            NSString * fromDateUTF8 = [NSString stringWithUTF8String:(const char *)fromDate];
            //7)serialNo
            const unsigned char * serialNo = sqlite3_column_text(pStmt, 3);
            NSString * serialNoUTF8 = [NSString stringWithUTF8String:(const char *)serialNo];
            //8)companyName
            const unsigned char * companyName = sqlite3_column_text(pStmt, 4);
            NSString * companyNameUTF8 = [NSString stringWithUTF8String:(const char *)companyName];
            //9)dataContent
            const unsigned char * dataContent = sqlite3_column_text(pStmt, 5);
            NSString * dataContentUTF8 = [NSString stringWithUTF8String:(const char *)dataContent];
            //11)dogId
            const unsigned char * dogId = sqlite3_column_text(pStmt, 6);
            NSString * dogIdUTF8 = [NSString stringWithUTF8String:(const char *)dogId];
            //10)imgQlt
            const unsigned char * imgQlt = sqlite3_column_text(pStmt, 7);
            NSString * imgQltUTF8 = [NSString stringWithUTF8String:(const char *)imgQlt];
            //12)nanoCount
            const unsigned char * nanoCount = sqlite3_column_text(pStmt, 8);
            NSString * nanoCountUTF8 = [NSString stringWithUTF8String:(const char *)nanoCount];
            //14)companyUrl
            const unsigned char * companyUrl = sqlite3_column_text(pStmt, 9);
            NSString * companyUrlUTF8 = [NSString stringWithUTF8String:(const char *)companyUrl];
            //15)productUrl
            const unsigned char * productUrl = sqlite3_column_text(pStmt, 10);
            NSString * productUrlUTF8 = [NSString stringWithUTF8String:(const char *)productUrl];
            
            //15)pdtUseType
            const unsigned char * pdtUseType = sqlite3_column_text(pStmt, 11);
            NSString * pdtUseTypeUTF8 = [NSString stringWithUTF8String:(const char *)pdtUseType];
            //15)pdtTraceabilityUrl
            const unsigned char * pdtTraceabilityUrl = sqlite3_column_text(pStmt, 12);
            NSString * pdtTraceabilityUrlUTF8 = [NSString stringWithUTF8String:(const char *)pdtTraceabilityUrl];
            //15)colorCode
            const unsigned char * colorCode = sqlite3_column_text(pStmt, 13);
            NSString * colorCodeUTF8 = [NSString stringWithUTF8String:(const char *)colorCode];
            //15)colorCodeInfo
            const unsigned char * colorCodeInfo = sqlite3_column_text(pStmt, 14);
            NSString * colorCodeInfoUTF8 = [NSString stringWithUTF8String:(const char *)colorCodeInfo];
            
            
            //17)shapeScore
            const unsigned char * shapeScore = sqlite3_column_text(pStmt, 15);
            NSString * shapeScoreUTF8 = [NSString stringWithUTF8String:(const char *)shapeScore];
            //19)histScore
            const unsigned char * histScore = sqlite3_column_text(pStmt, 16);
            NSString * histScoreUTF8 = [NSString stringWithUTF8String:(const char *)histScore];
            //18)qltScore
            const unsigned char * qltScore = sqlite3_column_text(pStmt, 17);
            NSString * qltScoreUTF8 = [NSString stringWithUTF8String:(const char *)qltScore];
           
            //20)totalScore
            const unsigned char * totalScore = sqlite3_column_text(pStmt, 18);
            NSString * totalScoreUTF8 = [NSString stringWithUTF8String:(const char *)totalScore];
            //21)maxDecScore
            const unsigned char * maxDecScore = sqlite3_column_text(pStmt, 19);
            NSString * maxDecScoreUTF8 = [NSString stringWithUTF8String:(const char *)maxDecScore];
            //22)minDecScore
            const unsigned char * minDecScore = sqlite3_column_text(pStmt, 20);
            NSString * minDecScoreUTF8 = [NSString stringWithUTF8String:(const char *)minDecScore];
            //23)decLevel
            const unsigned char * decLevel = sqlite3_column_text(pStmt, 21);
            NSString * decLevelUTF8 = [NSString stringWithUTF8String:(const char *)decLevel];
            
            //currentNumber
            const unsigned char * currentNumber = sqlite3_column_text(pStmt, 22);
            NSString * currentNumberUTF8 = [NSString stringWithUTF8String:(const char *)currentNumber];
            //Description
            const unsigned char * description = sqlite3_column_text(pStmt, 23);
            NSString * descriptionUTF8 = [NSString stringWithUTF8String:(const char *)description];
            //PdtDecRecordList
            const unsigned char * pdtDecRecordList = sqlite3_column_text(pStmt, 24);
            NSString * pdtDecRecordListUTF8 = [NSString stringWithUTF8String:(const char *)pdtDecRecordList];
            
            model = [[S2iDecPdtModel alloc] init];
            model = [S2iDecPdtModel decPdtWithId:nId
                                    decImageName:decImageNameUTF8
                                        fromDate:fromDateUTF8
                                        serialNo:serialNoUTF8
                                     companyName:companyNameUTF8
                                     dataContent:dataContentUTF8
                                           dogId:dogIdUTF8
                                          imgQlt:imgQltUTF8
                                       nanoCount:nanoCountUTF8
                                      companyUrl:companyUrlUTF8
                                      productUrl:productUrlUTF8
                                      pdtUseType:pdtUseTypeUTF8
                              pdtTraceabilityUrl:pdtTraceabilityUrlUTF8
                                       colorCode:colorCodeUTF8
                                   colorCodeInfo:colorCodeInfoUTF8
                                      shapeScore:shapeScoreUTF8
                                       histScore:histScoreUTF8
                                        qltScore:qltScoreUTF8
                                      totalScore:totalScoreUTF8
                                     maxDecScore:maxDecScoreUTF8
                                     minDecScore:minDecScoreUTF8
                                        decLevel:decLevelUTF8
                                   currentNumber:currentNumberUTF8
                                     descriptionStr:descriptionUTF8
                                pdtDecRecordList:pdtDecRecordListUTF8];
            
        }
    }
    else
    {
        S2iLog(@"sql语法错误!");
    }
    
    
    //4. 释放句柄
    sqlite3_finalize(pStmt);
    
    return model;
}







#pragma mark - 创建QR表
- (void)setupQRTable
{
    NSString * strSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ \
                         (Id integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, \
                         qrImageName text, \
                         qrInfo text)",
                         STR_TABLENAME_QR];
    
    char * pErrorMsg;
    if (SQLITE_OK ==  sqlite3_exec(m_pDb, strSql.UTF8String, NULL, NULL, &pErrorMsg))
    {
        S2iLog(@"创建 setupQRTable 数据表成功!");
    }
    else
    {
        S2iLog(@"创建 setupQRTable 数据表失败!");
    }
}




#pragma mark 增加QR
- (void)addQRWithImageName:(NSString *)qrImageName
                         model:(S2iQRModel *)model
{
    NSString * strSql = [NSString stringWithFormat: @"INSERT INTO %@ VALUES (null,'%@','%@')",
                         STR_TABLENAME_QR,
                         qrImageName,
                         model.qrInfo];
    
    S2iLog(@"model.qrInfo====%@", model.qrInfo);
    
    //执行SQL语句
    [self execSql:strSql msg:@"添加"];
}



#pragma mark - 删除QR码
- (void)deleteQRModel:(NSString *)qrImageName
{
    NSString * strSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE qrImageName='%@'", STR_TABLENAME_QR, qrImageName];
    
    //执行SQL语句
    [self execSql:strSql msg:@"删除"];
}


#pragma mark 查询QR信息
- (S2iQRModel *)selectQRWithImageName:(NSString *)imageName
{
    NSString * strSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE qrImageName='%@'", STR_TABLENAME_QR, imageName];
    
    S2iQRModel * model = nil;
    
    //1. 评估准备SQL语法是否正确
    sqlite3_stmt * pStmt = NULL;
    if (SQLITE_OK == sqlite3_prepare_v2(m_pDb, strSql.UTF8String, -1, &pStmt, NULL))
    {
        model = [[S2iQRModel alloc] init];
        
        //2. 如果能正常查询，调用单步执行方法， 依次取得查询结果
        //如果得到一行记录
        while (SQLITE_ROW == sqlite3_step(pStmt))
        {
            //3.获取/显示查询结果
            
            //1)主键ID，唯一标识
            //int nId = sqlite3_column_int(pStmt, 0);
            
            //2)解码图像名称
            const unsigned char * qrImageName = sqlite3_column_text(pStmt, 1);
            NSString * qrImageNameUTF8 = [NSString stringWithUTF8String:(const char *)qrImageName];
            
            //3)解码信息
            const unsigned char * qrInfo = sqlite3_column_text(pStmt, 2);
            NSString * qrInfoUTF8 = [NSString stringWithUTF8String:(const char *)qrInfo];
            
            model = [S2iQRModel qrWithImageName:qrImageNameUTF8 qrInfo:qrInfoUTF8];
        }
    }
    else
    {
        S2iLog(@"sql语法错误!");
    }
    
    
    //4. 释放句柄
    sqlite3_finalize(pStmt);
    
    return model;
}






















@end

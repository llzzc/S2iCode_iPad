//
//  S2iDecPdtModel.h
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

/****************************************************************************
 *
 *  本类概要说明：
 *
 *  1. 类名
 *      S2iDecPdtModel：是WEB SERVICE DecPdtSignet接口的返回数据模型类
 *
 *  2. 功能
 *      根据服务器返回的解码信息XML元素节点，一一对应的定义每个属性。
 *      S2iDecPdtModel类就是小章解码信息的数据模型类。
 *
 *  3. 服务器返回的XML结构，如下：
 *
 *     <?xml version="1.0" encoding="utf-8"?>
 *     <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
 *                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 *                    xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 *     <soap:Body>
 *     <DecPdtSignetResponse xmlns="http://localhost/">
 *     <DecPdtSignetResult>
 *
 *          <ErrCode>2</ErrCode>
 *          <ErrMsg>
 *              1.拍摄质量低，建议调整距离重新拍摄！
 *              2.印刷质量差，建议调整距离手动拍摄！
 *              3.如反复清晰拍摄均有提示，涉嫌伪造！
 *          </ErrMsg>
 *
 *          <ResultInfo>
 *              <FromDate>2012-05-02(2.220.122)</FromDate>
 *              <ToDate />
 *              <SignetGUID>0000201205020008</SignetGUID>
 *              <BrandOwnerName>沈阳安创信息科技有限公司</BrandOwnerName>
 *              <DataContent>安创科技秉承“信息安全是责任，技术创新是动力，客户需求是使命”的经营理念，立足中国，辐射全球。</DataContent>
 *              <ImgQlt />
 *              <DogId>0</DogId>
 *              <NanoCount />
 *              <S2iWebAddr>www.s2icode.com</S2iWebAddr>
 *              <BrandWebAddr>http://www.s2icode.com</BrandWebAddr>
 *              <ProductInfo>http://s.s2icode.com/31</ProductInfo>
 *              <ProductAd />
 *          </ResultInfo>
 *
 *          <ScoreInfo>
 *              <ShapeScore>41.00</ShapeScore>
 *              <QltScore>61.00</QltScore>
 *              <HistScore>78.00</HistScore>
 *              <DecScore>61</DecScore>
 *              <MaxDecScore>61</MaxDecScore>
 *              <MinDecScore>61</MinDecScore>
 *              <DecLevel>-2147483648</DecLevel>
 *          </ScoreInfo>
 *
 *     </DecPdtSignetResult>
 *     </DecPdtSignetResponse>
 *     </soap:Body>
 *     </soap:Envelope>
 ****************************************************************************/



#import <Foundation/Foundation.h>


/**
 *  解码状态枚举
 */
typedef enum
{
    ENUM_ERRCODE_FAILURE = 0,       //失败
    ENUM_ERRCODE_SUCCESS = 1,       //成功
    ENUM_ERRCODE_SUSPICION = 2      //怀疑
}enumErrCode;




/**
 *  小章解码实体模型类
 */
@interface S2iDecPdtModel : NSObject


//下面2个属性是根据数据库小章解码表定义的
@property (nonatomic, assign) NSInteger nId;                //数据库中的主键ID
@property (nonatomic, copy) NSString * decImageName;        //解码图像名称


//下面的属性是根据WebService标签定义的

/*<ResultInfo>*/
@property (nonatomic, copy) NSString * fromDate;            //商品认证时间 (图像质量参数 . 纳米数量)
@property (nonatomic, copy) NSString * serialNo;            //全球唯一序列号
@property (nonatomic, copy) NSString * companyName;         //公司名称
@property (nonatomic, copy) NSString * dataContent;         //码内数据区信息
@property (nonatomic, copy) NSString * dogId;               //狗ID
@property (nonatomic, copy) NSString * imgQlt;              //图像质量参数
@property (nonatomic, copy) NSString * nanoCount;           //纳米数量（暂时没用到）
@property (nonatomic, copy) NSString * companyUrl;          //公司网站网址
@property (nonatomic, copy) NSString * productUrl;          //商品简介网址
@property (nonatomic, copy) NSString * pdtUseType;          //商品简介网址
@property (nonatomic, copy) NSString * pdtTraceabilityUrl;          //溯源网址
@property (nonatomic, copy) NSString * colorCode;                   //0.红色、1.黄色、2.绿色
@property (nonatomic, copy) NSString * colorCodeInfo;               //颜色代码相应的描述
/*</ResultInfo>*/


/*<ScoreInfo>*/
@property (nonatomic, copy) NSString * shapeScore;       //图像形状得分
@property (nonatomic, copy) NSString * histScore;        //图像清晰度得分
@property (nonatomic, copy) NSString * qltScore;         //图像质量得分
@property (nonatomic, copy) NSString * totalScore;       //图像当前得分
@property (nonatomic, copy) NSString * maxDecScore;      //最高解码得分
@property (nonatomic, copy) NSString * minDecScore;      //最低解码得分（暂时没用到）
@property (nonatomic, copy) NSString * decLevel;         //解码等级
/*</ScoreInfo>*/

@property (nonatomic, copy) NSString * currentNumber;           //解码等级
@property (nonatomic, copy) NSString * descriptionStr;             //解码等级
@property (nonatomic, copy) NSString * pdtDecRecordList;         //解码等级






/**
 *  如果解码类型不是一标一码，则为nil
 *  如果解码类型是一标一码，则把一标一码的解码信息转成data，存到数据库中。
 */
//@property (nonatomic, strong) NSString *pdtFolwStrXml;




//快速创建实体类
+ (id)decPdtWithId:(NSInteger)nId
      decImageName:(NSString *)decImageName
          fromDate:(NSString *)fromDate
          serialNo:(NSString *)serialNo
       companyName:(NSString *)companyName
       dataContent:(NSString *)dataContent
             dogId:(NSString *)dogId
            imgQlt:(NSString *)imgQlt
         nanoCount:(NSString *)nanoCount
        companyUrl:(NSString *)companyUrl
        productUrl:(NSString *)productUrl
        pdtUseType:(NSString *)pdtUseType
pdtTraceabilityUrl:(NSString *)pdtTraceabilityUrl
         colorCode:(NSString *)colorCode
     colorCodeInfo:(NSString *)colorCodeInfo
        shapeScore:(NSString *)shapeScore
         histScore:(NSString *)histScore
          qltScore:(NSString *)qltScore
        totalScore:(NSString *)totalScore
       maxDecScore:(NSString *)maxDecScore
       minDecScore:(NSString *)minDecScore
          decLevel:(NSString *)decLevel
    currentNumber:(NSString *)currentNumber
       descriptionStr:(NSString *)descriptionStr
    pdtDecRecordList:(NSString *)pdtDecRecordList;


@end








































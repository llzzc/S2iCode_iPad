//
//  S2iXmlManager.h
//  S2iPhone
//
//  Created by txm on 14/12/17.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：XML管理类
 
    1. 添加libxml2.2.dylib库
    2. 在 “Header Search Paths" 和 "User Header Search Paths” 里填入 $(SDKROOT)/usr/include/libxml2
 */

#import <Foundation/Foundation.h>
#include <libxml/xmlmemory.h>
#include <libxml/xmlwriter.h>
#import "S2iDecPdtModel.h"
#import "S2iSoftUpModel.h"
#import "S2iAddDevInfoModel.h"
#import "S2iPdtFlowIdModel.h"





/**
 *  构造XML标识
 */
#define STR_XML_ENCODING "UTF-8"
#define STR_XML_SOAP "soap"
#define STR_XML_ENVELOPE "Envelope"
#define STR_XML_NAMESPACE "http://www.w3.org/2003/05/soap-envelope"
#define STR_XML_XMLNS_LOC "xmlns:loc"
#define STR_XML_SERVER_URL "http://localhost/"
#define STR_XML_BODY "Body"
#define STR_XML_LOC "loc"
#define STR_XML_XMLNS "xmlns"
#define STR_XML_HEADER "Header"


/**
 *  AddPhoneDeviceInfo接口
 */
//标识
#define STR_XML_ADDPHONEDEVICEINFORESPONSE_TAG "PostMobileDevicesResponse"
//请求
// [new]
#define STR_XML_ADDPHONEDEVICEINFO_TAG "PostMobileDevices"
#define STR_XML_ADDPHONE_PHONENAME_TAG "jsonStr"

#define STR_XML_ADDPHONE_PHONETYPE_TAG "PhoneType"
#define STR_XML_ADDPHONE_SCREENWIDTH_TAG "ScreenWidth"
#define STR_XML_ADDPHONE_SCREENHEIGHT_TAG "ScreenHeight"
#define STR_XML_ADDPHONE_SELVIDEOWIDTH_TAG "SelVideoWidth"
#define STR_XML_ADDPHONE_SELVIDEOHEIGHT_TAG "SelVideoHeight"
#define STR_XML_ADDPHONE_SELCAPTUREWIDTH_TAG "SelCaptureWidth"
#define STR_XML_ADDPHONE_SELCAPTUREHEIGHT_TAG "SelCaptureHeight"
#define STR_XML_ADDPHONE_ISCONTINUOUSFOCUS_TAG "IsContinuousFocus"
//解析
#define STR_XML_ADDPHONE_RESULTCODE_TAG "ResultCode"
#define STR_XML_ADDPHONE_ERRORINFO_TAG "ErrorInfo"
#define STR_XML_ADDPHONE_PHONEDEVICEID_TAG "PhoneDeviceId"

/**
 *  DecPdtSignet接口
 */
//标识
#define STR_XML_DECPDTSIGNET_INTERFACE_TAG "GetPdtDecResponse"
//请求
//【new】
#define STR_XML_DECPDT_TAG "GetPdtDec"
#define STR_XML_DECPDT_KEY_TAG "jsonStr"                    //密码



#define STR_XML_DECPDT_BY64IMGDATA_TAG "by64ImgData"    //解码图片byte数组
#define STR_XML_DECPDT_LONGITUDE_TAG "Longitude"        //精度
#define STR_XML_DECPDT_LATITUDE_TAG "Latitude"          //纬度
#define STR_XML_DECPDT_DEVICEID_TAG "DeviceId"          //设备Id
//解析
#define STR_XML_DECPDT_DECPDTRESULT_TAG "DecPdtResult"
#define STR_XML_DECPDT_RESULTCODE_TAG "ResultCode"
#define STR_XML_DECPDT_ERRORINFO_TAG "ErrorInfo"

#define STR_XML_DECPDT_RESULTINFO_TAG "ResultInfo"
#define STR_XML_DECPDT_FROMDATE_TAG "FromDate"
#define STR_XML_DECPDT_SERIALNO_TAG "SerialNo"  //
#define STR_XML_DECPDT_COMPANYNAME_TAG "CompanyName"
#define STR_XML_DECPDT_DATACONTENT_TAG "DataContent"
#define STR_XML_DECPDT_DOGID_TAG "DogId"
#define STR_XML_DECPDT_IMGQLT_TAG "ImgQlt"
#define STR_XML_DECPDT_NANOCOUNT_TAG "NanoCount"
#define STR_XML_DECPDT_COMPANYURL_TAG "CompanyUrl"
#define STR_XML_DECPDT_PRODUCTURL_TAG "ProductUrl"

#define STR_XML_DECPDT_SCOREINFO_TAG "ScoreInfo"
#define STR_XML_DECPDT_SHAPESCORE_TAG "ShapeScore"
#define STR_XML_DECPDT_HISTSCORE_TAG "HistScore"
#define STR_XML_DECPDT_QLTSCORE_TAG "QltScore"
#define STR_XML_DECPDT_TOTALSCORE_TAG "TotalScore"
#define STR_XML_DECPDT_DECMAXSCORE_TAG "DecMaxScore"
#define STR_XML_DECPDT_DECMINSCORE_TAG "DecMinScore"
#define STR_XML_DECPDT_DECLEVEL_TAG "DecLevel"

#define STR_XML_DECPDT_EXTENSIONINFO_TAG "ExtensionInfo"
#define STR_XML_DECPDT_PDTTYPE_TAG "PdtType"
#define STR_XML_DECPDT_PDTTRACEABILTYURL_TAG "PdtTraceabilityUrl"


/**
 *  SoftwareUpgrade接口
 */
//标识
#define STR_XML_SOFTWAREVERSONINFORESPONSE_TAG "GetSoftwareVersionResponse"
//请求
#define STR_XML_SOFTUP_VERSIONINFO_TAG "SoftwareVersionInfo"
#define STR_XML_SOFTUP_NAME_TAG "SoftwareName"
//解析
#define STR_XML_SOFTUP_RESULTCODE_TAG "ResultCode"
#define STR_XML_SOFTUP_ERRORINFO_TAG "ErrorInfo"
#define STR_XML_SOFTUP_UPDATESIZE_TAG "UpdateSite"
#define STR_XML_SOFTUP_MAJORVERSIONNUMBER_TAG "MajorVersionNumber"
#define STR_XML_SOFTUP_MINORVERSIONNUMBER_TAG "MinorVersionNumber"
#define STR_XML_SOFTUP_DESCRIPTION_TAG "Description"
#define STR_XML_SOFTUP_VERSIONSTATUS_TAG "VersionStatus"


/**
 *  GetPdtFolwIdServiceInfo接口 : "一标一码"
 */
// 标识
#define STR_XML_GETPDTFOLWIDSERVICEINFORESPONSE_TAG "GetPdtFolwIdServiceInfoResponse"
//请求
#define STR_XML_GETPDTFOLWIDSERVICEINFO_TAG "GetPdtFolwIdServiceInfo"
#define STR_XML_GETPDTFOLW_SERIANO_TAG "SerialNo"
//解析
#define STR_XML_GETPDTFOLW_RESULTCODE_TAG "ResultCode"
#define STR_XML_GETPDTFOLW_ERRORINFO_TAG "ErrorInfo"
#define STR_XML_GETPDTFOLW_CURRENTNUMBER_TAG "CurrentNumber"
#define STR_XML_GETPDTFOLW_DESCRIPTION_TAG "Description"
#define STR_XML_GETPDTFOLW_PDTDECINFOLIST_TAG "PdtDecInfoList"
#define STR_XML_GETPDTFOLW_PDTDECINFO_TAG "PdtDecInfo"
#define STR_XML_GETPDTFOLW_ID_TAG "Id"
#define STR_XML_GETPDTFOLW_DECTIME_TAG "DecTime"
#define STR_XML_GETPDTFOLW_IP_TAG "IP"
#define STR_XML_GETPDTFOLW_ADDRESS_TAG "Address"



// 标识
#define STR_XML_GETPDTINFOBYSERIALNO_TAG "GetPdtInfoBySerialNOResponse"

#define STR_xml_GETSLIDEPICTURELIST_TAG "GetSlidePictureListResponse"



typedef enum
{
    ENUM_ADDDEVFINO_INTERFACE_FAILURE = 0 ,  //失败
    ENUM_ADDDEVFINO_INTERFACE_SUCCESSD = 1, //成功
    ENUM_ADDDEVFINO_INTERFACE_EXIST = 2     //已存在
}enumAddDevInfoState;


/**
 *  WEB服务接口
 */
typedef enum
{
    ENUM_REQUEST_INTERFACE_UNKNOWN = 0,                 //未知接口
    ENUM_REQUEST_INTERFACE_DECPDTSIGNET = 1,            //商品签章解码接口
    ENUM_REQUEST_INTERFACE_ADDPHONEDEVICEINFO = 2,      //添加设备(或查询设备)ID接口
    ENUM_REQUEST_INTERFACE_SOFTWAREUPGRADE = 3,         //软件更新接口
    ENUM_REQUEST_INTERFACE_GETPDTFOLWIDSERVICEINFO = 4,  //获取一标一码服务信息
    ENUM_REQUEST_INTERFACE_GETPDTINFOBYSERIALNO = 5,       //获取防伪码基础信息,通过流水号.
    ENUM_REQUEST_INTERFACE_GETSIDEPICTURELIST = 6       //获取图片集合
}enumRequestInterface;



@interface S2iXmlManager : NSObject



/**
 *  请求，WEB SERVER - GetPdtFolwIdServiceInfo
 *
 *  @param guid S2i码的GUID
 *
 *  @return 请求的XML
 */
+ (NSString *)requestGetPdtFolwIdServiceInfoXML:(NSString *)guid;


/**
 *  请求，WEB SERVER - AddPhoneDeviceInfo接口的XML
 *
 *  @return 请求XML信息
 */
+ (NSString *)requestAddPhoneDeviceInfoWithJson:(NSString *)jsonStr;



/**
 *  请求，WEB SERVER - DecPdtSignet接口的XML
 *
 *  @param image              解码图像数据
 *  @param location           经纬度
 *  @param nPhoneDeviceInfoId 设备ID值
 *
 *  @return 请求XML信息
 */
+ (NSString *)requestDecPdtXMLWithJson:(NSString *)jsonStr;


/**
 *  请求，WEB SERVER - SoftwareUpgrade接口的XML
 *
 *  @return 请求XML信息
 */
+ (NSString *)requestSoftwareUpgradeXML:(NSString *)jsonStr;






/**
 *  解析，WEB SERVER - AddPhoneDeviceInfo接口的XML
 *
 *  @param xml SERVER端返回的XML
 *
 *  @return 解析出<PhoneDeviceInfoId>标签的数据
 */
//+ (NSInteger)parseAddPhoneDeviceInfoXML:(NSString*)xml;
+ (NSString *)parseAddPhoneDeviceInfoXML:(NSString*)xml;


/**
 *  解析，WEB SERVER - DecPdtSignet接口的XML
 *
 *  @param xml SERVER端返回的XML
 *
 *  @return 返回S2iDecPdtModel实体类
 */
+ (NSString *)parseDecPdtSignetXML:(NSString *)xml;



// [new] 获取防伪码基础信息,通过流水号.
+ (NSString *)parseGetPdtInfoBySerialNOXML:(NSString *)xml;



/**
 *  解析，WEB SERVER - SoftwareUpgrade接口的XML
 *
 *  @param xml SERVER端返回的XML
 *
 *  @return 返回S2iSoftUpModel实体类
 */
+ (NSString *)parseSoftwareUpgradeXML:(NSString *)xml;


/**
 *  解析，WEB SERVER - 一标一码接口的XML
 *
 *  @param xml SERVER端返回的XML
 *
 *  @return 返回S2iPdtFlowIdModel实体类
 */
+ (S2iPdtFlowIdModel *)parsePdtFlowIdModelXML:(NSString *)xml;




/**
 *  通过服务器返回的数据（字符串），查找里面的节点，来判断调用的哪个WEB SERVICE的接口
 *
 *  @param responseXML 服务器返回的XML数据
 *
 *  @return 调用接口的枚举
 */
+ (enumRequestInterface)detectRequestInferfaceName:(NSString *)responseXML;


/**
 *  构造请求图片集合请求的XML
 */
+ (NSString *)requestSoapSlidePictureListXML:(NSString *)jsonStr ;

/**
 *  解析图片集合请求的XML
 */
+ (NSString *)parseGetSlidePictureListXML:(NSString *)xml ;

@end

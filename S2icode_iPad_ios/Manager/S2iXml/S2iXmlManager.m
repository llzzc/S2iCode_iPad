//
//  S2iXmlManager.m
//  S2iPhone
//
//  Created by txm on 14/12/17.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iXmlManager.h"


/**
 *  <PhoneName>代表是IPhone手机上传解码的。
 *  此标签字符串不得修改。
 *  如果必须修改，先与WEB组联系。
 */
NSString * STR_SOAP_IPHONE_NAME = @"IOS";


/**
 *  AddPhoneDeviceInfo接口默认参数
 */
NSString * STR_SOAP_VIDEO_WIDTH = @"0";
NSString * STR_SOAP_VIDEO_HEIGHT = @"0";
NSString * STR_SOAP_CAPTURE_WIDTH = @"0";
NSString * STR_SOAP_CAPTURE_HEIGHT = @"0";
NSString * STR_SOAP_ISCONTINUOUSFOCUS = @"1";


/**
 *  请求接口密码
 */
NSString * STR_SOAP_PASSWORD = @"S2iIosPdtDecode@S2icode.com";







@implementation S2iXmlManager








#pragma mark - 创建，WEB服务GetPdtFolwIdServiceInfo接口，请求的XML。
/*
 <?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
<soap12:Body>
    <GetPdtFolwIdServiceInfo xmlns="http://localhost/">
        <SerialNo>string</SerialNo>
    </GetPdtFolwIdServiceInfo>
</soap12:Body>
</soap12:Envelope>
 */
+ (NSString *)requestGetPdtFolwIdServiceInfoXML:(NSString *)guid
{
    xmlTextWriterPtr xmlTextWriter;
    xmlBufferPtr xmlBuffer;
    xmlBuffer = xmlBufferCreate();
    xmlTextWriter = xmlNewTextWriterMemory(xmlBuffer, 0);
    
    int ret = xmlTextWriterStartDocument(xmlTextWriter, NULL, STR_XML_ENCODING, NULL);
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_ENVELOPE, BAD_CAST STR_XML_NAMESPACE);
    ret = xmlTextWriterWriteAttribute(xmlTextWriter, BAD_CAST STR_XML_XMLNS_LOC, BAD_CAST STR_XML_SERVER_URL);
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_BODY, NULL);
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_GETPDTFOLWIDSERVICEINFO_TAG, NULL);
    ret = xmlTextWriterWriteAttribute(xmlTextWriter, BAD_CAST STR_XML_XMLNS, BAD_CAST STR_XML_SERVER_URL);
    //1. <SerialNo>全球唯一序列号</SerialNo>
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_GETPDTFOLW_SERIANO_TAG, NULL);
    ret = xmlTextWriterWriteFormatString(xmlTextWriter, "%s", [guid UTF8String]);
    ret = xmlTextWriterEndElement(xmlTextWriter);
    //封闭标签
    ret = xmlTextWriterFullEndElement(xmlTextWriter);
    ret = xmlTextWriterEndDocument(xmlTextWriter);
    
    //把XML（从char*转NSString）数据
    NSString * requestXML = [[NSString alloc] initWithFormat:@"%s", (char*)xmlBuffer->content];
    xmlBufferFree(xmlBuffer);
    xmlFreeTextWriter(xmlTextWriter);
    
    //S2iLog(@"GetPdtFolwIdServiceInfo==请求的XML==%@" , requestXML);
    
    return requestXML;
}


#pragma mark - 创建请求XML


#pragma mark 创建，WEB服务AddPhoneDeviceInfo接口，请求的XML
/*****************************************************************************************************
 *
 *  功能：
 *      创建，WEB服务AddPhoneDeviceInfo接口，请求的XML
 *  作用：
 *      添加手机型号，如果SERVER没有此类型手机，则添加后，返回一个SQL中对应的数值。
 *      如果SQL中有这个手机型号，则返回对应机型的数值。
 *
 *  请求XML结构，如下：
 *    <soap:Envelope xmlns:loc="http://localhost/" xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
 *         <soap:Body>
 *         <loc:AddPhoneDeviceInfo xmlns="http://localhost/">
 *
 *            <loc:PhoneName>IOS</loc:PhoneName>
 *            <loc:PhoneType>IPHONE_5C</loc:PhoneType>
 *            <loc:ScreenWidth>640</loc:ScreenWidth>
 *            <loc:ScreenHeight>1136</loc:ScreenHeight>
 *            <loc:SelVideoWidth>0</loc:SelVideoWidth>
 *            <loc:SelVideoHeight>0</loc:SelVideoHeight>
 *            <loc:SelCaptureWidth>0</loc:SelCaptureWidth>
 *            <loc:SelCaptureHeight>0</loc:SelCaptureHeight>
 *            <loc:IsContinuousFocus>1</loc:IsContinuousFocus>
 *
 *         </loc:AddPhoneDeviceInfo>
 *         </soap:Body>
 *    </soap:Envelope>
 *
 ****************************************************************************************************/
+ (NSString *)requestAddPhoneDeviceInfoWithJson:(NSString *)jsonStr
{
//    xmlTextWriterPtr xmlTextWriter;
//    xmlBufferPtr xmlBuffer;
//    xmlBuffer = xmlBufferCreate();
//    xmlTextWriter = xmlNewTextWriterMemory(xmlBuffer, 0);
//    
//    //<?xml version="1.0" encoding="UTF-8"?>
//    int ret = xmlTextWriterStartDocument(xmlTextWriter, NULL, STR_XML_ENCODING, NULL);
//    
//    //<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_ENVELOPE, BAD_CAST STR_XML_NAMESPACE);
//    
//    //追加上一条xmlns:loc="http://localhost/"
//    //<soap:Envelope xmlns:loc="http://localhost/" xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
//    ret = xmlTextWriterWriteAttribute(xmlTextWriter, BAD_CAST STR_XML_XMLNS_LOC, BAD_CAST STR_XML_SERVER_URL);
//    
//    //<soap:Body></soap:Body>
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_BODY, NULL);
//    
//    
//    //<loc:AddPhoneDeviceInfo></loc:AddPhoneDeviceInfo>
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_ADDPHONEDEVICEINFO_TAG, NULL);
//    
//    //追加上一条xmlns="http://localhost/"
//    //<loc:AddPhoneDeviceInfo xmlns="http://localhost/"></loc:AddPhoneDeviceInfo>
//    ret = xmlTextWriterWriteAttribute(xmlTextWriter, BAD_CAST STR_XML_XMLNS, BAD_CAST STR_XML_SERVER_URL);
//    
//
//    //1. <loc:PhoneName>IOS</loc:PhoneName>
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_ADDPHONE_PHONENAME_TAG, NULL);
//    ret = xmlTextWriterWriteFormatString(xmlTextWriter, "%s", jsonStr);
//    ret = xmlTextWriterEndElement(xmlTextWriter);
//
//    
//    //封闭标签
//    ret = xmlTextWriterFullEndElement(xmlTextWriter);
//    ret = xmlTextWriterEndDocument(xmlTextWriter);
//    
//    
//    //把XML（从char*转NSString）数据
//    NSString * requestXML = [[NSString alloc] initWithFormat:@"%s", (char*)xmlBuffer->content];
//    xmlBufferFree(xmlBuffer);
//    xmlFreeTextWriter(xmlTextWriter);
//    
//    S2iLog(@"AddPhoneDeviceInfo==请求的XML==%@" , requestXML);
    
    NSString * requestXML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                             <soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\
                             <soap12:Body> \
                             <PostMobileDevices xmlns=\"http://localhost/\">\
                             <jsonStr>%@</jsonStr>\
                             </PostMobileDevices>\
                             </soap12:Body>\
                             </soap12:Envelope>",  jsonStr];
    
    return requestXML;
}







#pragma mark 创建，WEB服务DecPdtSignet接口，请求的XML
/*****************************************************************************************************
 *
 *  功能：
 *      创建，WEB服务DecPdtSignet接口，请求的XML
 *  参数：
 *      image - 解码图像
 *      location - GPS定位
 *      nPhoneDeviceInfoId - 上传解码的手机设备ID值（此ID值，是请求AddPhoneDeviceInfo接口获得的）
 *  返回值：
 *      请求DecPdtSignet接口的XML
 *
 *  请求XML结构，如下：
 *    <?xml version="1.0" encoding="UTF-8"?>
 *     <soap:Envelope xmlns:loc="http://localhost/" xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
 *     <soap:Body>
 *           <loc:DecPdtSignet xmlns="http://localhost/">
 *               <loc:FileDB>解码图像(base64Binary)</loc:FileDB>
 *               <loc:PassWord>s2iImportimaGe@S2icode.com</loc:PassWord>
 *               <loc:Latitude>41.837747</loc:Latitude>
 *               <loc:Longitude>123.407862</loc:Longitude>
 *               <loc:PhoneDeviceInfoId>29</loc:PhoneDeviceInfoId>
 *         </loc:DecPdtSignet>
 *     </soap:Body>
 *     </soap:Envelope>
 *
 ****************************************************************************************************/
+ (NSString *)requestDecPdtXMLWithJson:(NSString *)jsonStr;
{
    /*
    //构造请求DecPdtSignet的XML
    xmlTextWriterPtr xmlTextWriter;
    xmlBufferPtr xmlBuffer;
    xmlBuffer = xmlBufferCreate();
    xmlTextWriter = xmlNewTextWriterMemory(xmlBuffer, 0);
    
    //XML声明部分
    int ret = xmlTextWriterStartDocument(xmlTextWriter, NULL, STR_XML_ENCODING, NULL);
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_ENVELOPE, BAD_CAST STR_XML_NAMESPACE);
    ret = xmlTextWriterWriteAttribute(xmlTextWriter, BAD_CAST STR_XML_XMLNS_LOC, BAD_CAST STR_XML_SERVER_URL);
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_BODY, NULL);
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_DECPDT_TAG, NULL);
    ret = xmlTextWriterWriteAttribute(xmlTextWriter, BAD_CAST STR_XML_XMLNS, BAD_CAST STR_XML_SERVER_URL);
    
    //参数部分
    //1. key： 接口密码
    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_DECPDT_KEY_TAG, NULL);
    ret = xmlTextWriterWriteFormatString(xmlTextWriter, "%s", [jsonStr UTF8String]);
    ret = xmlTextWriterEndElement(xmlTextWriter);

    //封闭标签
    ret = xmlTextWriterFullEndElement(xmlTextWriter);
    ret = xmlTextWriterEndDocument(xmlTextWriter);
    
    NSString* requestXML = [[NSString alloc] initWithFormat:@"%s", (char*)xmlBuffer->content];
    xmlBufferFree(xmlBuffer);
    xmlFreeTextWriter(xmlTextWriter);
    
    //stringByReplacingOccurrencesOfString
    requestXML = [requestXML stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    requestXML = [requestXML stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    requestXML = [requestXML stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    S2iLog(@"requestDecPdtXMLWithJson=======%@", requestXML);
     */
    
    
    NSString *requestXML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"><soap12:Body><GetPdtDec xmlns=\"http://localhost/\"><jsonStr>%@</jsonStr></GetPdtDec></soap12:Body></soap12:Envelope>", jsonStr];
    //S2iLog(@"requestXML = %@",  requestXML);
    return requestXML;
}


/**
 *  构造请求图片集合XML
 */
+ (NSString *)requestSoapSlidePictureListXML:(NSString *)jsonStr {
    NSString *requestXML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \
                            <soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"> \
                            <soap12:Body> \
                            <GetSlidePictureList xmlns=\"http://localhost/\"> \
                            <jsonStr>%@</jsonStr> \
                            </GetSlidePictureList> \
                            </soap12:Body> \
                            </soap12:Envelope>", jsonStr];
    
    S2iLog(@"requestSoapSlidePictureListXML==请求的XML==%@" , requestXML);
    
    return requestXML;

}




#pragma mark 创建，WEB服务SoftwareUpgrade接口，请求的XML
/*****************************************************************************************************
 *
 *  功能：
 *      创建，WEB服务SoftwareUpgrade接口，请求的XML
 *
 *  参数：
 *      aDeviceId -
 *
 *  请求XML结构，如下：
 *     <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 *                    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 *                    xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
 *     <soap:Body>
 *     <SoftwareUpgrade xmlns="http://localhost/">
 *          <PassWord>string</PassWord>
 *     </SoftwareUpgrade>
 *     </soap:Body>
 *     </soap:Envelope>
 *
 ****************************************************************************************************/
+ (NSString *)requestSoftwareUpgradeXML:(NSString *)jsonStr
{
//    xmlTextWriterPtr xmlTextWriter;
//    xmlBufferPtr xmlBuffer;
//    xmlBuffer = xmlBufferCreate();
//    xmlTextWriter = xmlNewTextWriterMemory(xmlBuffer, 0);
//    
//    //XML声明部分
//    int ret = xmlTextWriterStartDocument(xmlTextWriter, NULL, STR_XML_ENCODING, NULL);
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_ENVELOPE, BAD_CAST STR_XML_NAMESPACE);
//    ret = xmlTextWriterWriteAttribute(xmlTextWriter, BAD_CAST STR_XML_XMLNS_LOC, BAD_CAST STR_XML_SERVER_URL);
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_HEADER, NULL);
//    ret = xmlTextWriterEndElement(xmlTextWriter);
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_SOAP, BAD_CAST STR_XML_BODY, NULL);
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_SOFTUP_VERSIONINFO_TAG, NULL);
//    
//    //<PassWord>
//    ret = xmlTextWriterStartElementNS(xmlTextWriter, BAD_CAST STR_XML_LOC, BAD_CAST STR_XML_SOFTUP_NAME_TAG, NULL);
//    ret = xmlTextWriterWriteFormatString(xmlTextWriter, "%s", [STR_SOAP_PASSWORD UTF8String]);
//    ret = xmlTextWriterEndElement(xmlTextWriter);
//    
//    //封闭标签
//    ret = xmlTextWriterFullEndElement(xmlTextWriter);
//    ret = xmlTextWriterEndDocument(xmlTextWriter);
//    
//    
//    NSString * requestXML = [[NSString alloc] initWithFormat:@"%s", (char*)xmlBuffer->content];
//    xmlBufferFree(xmlBuffer);
//    xmlFreeTextWriter(xmlTextWriter);
    
    NSString *requestXML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?> \
                            <soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"> \
                            <soap12:Body> \
                            <GetSoftwareVersion xmlns=\"http://localhost/\"> \
                            <jsonStr>%@</jsonStr> \
                            </GetSoftwareVersion> \
                            </soap12:Body> \
                            </soap12:Envelope>", jsonStr];
    
    S2iLog(@"requestSoftwareUpgradeXML==请求的XML==%@" , requestXML);
    
    return requestXML;
}






#pragma mark - 解析SERVER 返回的XML


#pragma mark 解析GetPdtInfoBySerialNO接口返回的xml
+ (NSString *)parseGetPdtInfoBySerialNOXML:(NSString *)xml{
    
    S2iLog(@"parseGetPdtInfoBySerialNOXML===1===");
    
    NSString * result = @"";
    
    xmlDocPtr doc = xmlParseMemory([xml UTF8String], (int)strlen([xml UTF8String]));
    if (!doc)
    {
        return nil;
    }
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (!root)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    xmlNodePtr node = root->children;
    if (!node)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    
    xmlNodePtr cur_node;
    for (cur_node = node; cur_node; cur_node = cur_node->next)
    {
        xmlNodePtr children;
        for (children = cur_node->children; children; children = children->next)
        {
            
            xmlNodePtr cur_children_note = children->children;
            
            xmlNodePtr node;
            for (node = cur_children_note; node; node = node->next)
            {
                xmlChar* pNodeValue = xmlNodeListGetString(doc, node->children, 1);
                //S2iLog(@"==2===\t%s: %s", node->name, pNodeValue);
                result = [NSString stringWithUTF8String:(char*)pNodeValue];
               
            }
        }
    }
    
    xmlFreeDoc(doc);
    
    return result;
}


#pragma mark 解析AddPhoneDeviceInfo接口返回的XML
/*********************************************************
 *  功能：
 *      解析，WEB服务AddPhoneDeviceInfo接口，返回的XML
 *  参数：
 *      xml - 服务器返回的解码数据（XML）
 *  返回值：
 *      获取当前解码手机，在服务器端的 设备ID值。
 *********************************************************/
+ (NSString *)parseAddPhoneDeviceInfoXML:(NSString*)xml
{
    NSString * result = @"";
    xmlDocPtr doc = xmlParseMemory([xml UTF8String], (int)strlen([xml UTF8String]));
    if (!doc)
    {
        return nil;
    }
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (!root)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    xmlNodePtr node = root->children;
    if (!node)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    
    xmlNodePtr cur_node;
    for (cur_node = node; cur_node; cur_node = cur_node->next)
    {
        xmlNodePtr children;
        for (children = cur_node->children; children; children = children->next)
        {
            
            xmlNodePtr cur_children_note = children->children;
            
            xmlNodePtr node;
            for (node = cur_children_note; node; node = node->next)
            {
                xmlChar* pNodeValue = xmlNodeListGetString(doc, node->children, 1);
                S2iLog(@"\t%s: %s", node->name, pNodeValue);
                result = [NSString stringWithUTF8String:(char*)pNodeValue];
            }
        }
    }
    
    xmlFreeDoc(doc);
    
    return result;
}


#pragma mark - 解析图片结合返回XML
+ (NSString *)parseGetSlidePictureListXML:(NSString *)xml {
    xmlDocPtr doc = xmlParseMemory([xml UTF8String], (int)strlen([xml UTF8String]));
    if (!doc)
    {
        return nil;
    }
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (!root)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    xmlNodePtr node = root->children;
    if (!node)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    
    NSString * result = @"";
    //解析XML，给数据模型赋值
    xmlNodePtr cur_node;
    for (cur_node = node; cur_node; cur_node = cur_node->next)
    {
        xmlNodePtr children;
        for (children = cur_node->children; children; children = children->next)
        {
            xmlNodePtr cur_children_note = children->children;
            xmlNodePtr node;
            for (node = cur_children_note; node; node = node->next)
            {
                xmlChar* pNodeValue = xmlNodeListGetString(doc, node->children, 1);
                S2iLog(@"parseGetSlidePictureListXML\t%s: %s", node->name, pNodeValue);
                result = [NSString stringWithUTF8String:(char*)pNodeValue];
            }
        }
    }
    xmlFreeDoc(doc);
    
    return result;
}





#pragma mark - 解析DecPdtSignet接口，返回的XML
/*********************************************************
 *  功能：
 *      解析，WEB服务DecPdtSignet接口，返回的XML
 *  参数：
 *      xml - 服务器返回的解码数据（XML）
 *  返回值：
 *      返回对应DecPdtSignet接口的数据模型
 *********************************************************/
+ (NSString *)parseDecPdtSignetXML:(NSString *)xml
{
    //S2iLog(@"S2iDecPdtModel  xml  ===%@", xml);
    
    xmlDocPtr doc = xmlParseMemory([xml UTF8String], (int)strlen([xml UTF8String]));
    if (!doc)
    {
        return nil;
    }
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (!root)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    xmlNodePtr node = root->children;
    if (!node)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    
    NSString * result = @"";
    //解析XML，给数据模型赋值
    xmlNodePtr cur_node;
    for (cur_node = node; cur_node; cur_node = cur_node->next)
    {
        xmlNodePtr children;
        for (children = cur_node->children; children; children = children->next)
        {
            xmlNodePtr cur_children_note = children->children;
            xmlNodePtr node;
            for (node = cur_children_note; node; node = node->next)
            {
                xmlChar* pNodeValue = xmlNodeListGetString(doc, node->children, 1);
                S2iLog(@"\t%s: %s", node->name, pNodeValue);
                result = [NSString stringWithUTF8String:(char*)pNodeValue];
            }
        }
    }
    xmlFreeDoc(doc);
    
    
    return result;
}



#pragma mark - 解析SoftwareUpgrade接口，返回的XML
/*********************************************************
 *  功能：
 *      解析，WEB服务SoftwareUpgrade接口，返回的XML
 *  参数：
 *      xml - 服务器返回的数据（XML）
 *  返回值：
 *      获取返回对应SoftwareUpgrade接口的数据模型
 *********************************************************/
+ (NSString *)parseSoftwareUpgradeXML:(NSString *)xml
{
    NSString * result = @"";
    xmlDocPtr doc = xmlParseMemory([xml UTF8String], (int)strlen([xml UTF8String]));
    if (!doc)
    {
        return nil;
    }
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (!root)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    xmlNodePtr node = root->children;
    if (!node)
    {
        xmlFreeDoc(doc);
        return nil;
    }
    
    
    xmlNodePtr cur_node;
    for (cur_node = node; cur_node; cur_node = cur_node->next)
    {
        xmlNodePtr children;
        for (children = cur_node->children; children; children = children->next)
        {
            xmlNodePtr cur_children_note = children->children;
            xmlNodePtr node;
            for (node = cur_children_note; node; node = node->next)
            {
                xmlChar* pNodeValue = xmlNodeListGetString(doc, node->children, 1);
                S2iLog(@"===134====\t%s: %s", node->name, pNodeValue);
                result = [NSString stringWithUTF8String:(char*)pNodeValue];
            }
        }
    }
    xmlFreeDoc(doc);
    
    return result;
}




#pragma mark - 1标1码 解析XML
+ (S2iPdtFlowIdModel *)parsePdtFlowIdModelXML:(NSString *)xml
{
//    xmlDocPtr doc = xmlParseMemory([xml UTF8String], strlen([xml UTF8String]));
//    if (!doc)
//    {
//        return nil;
//    }
//    xmlNodePtr root = xmlDocGetRootElement(doc);
//    if (!root)
//    {
//        xmlFreeDoc(doc);
//        return nil;
//    }
//    xmlNodePtr node = root->children;
//    if (!node)
//    {
//        xmlFreeDoc(doc);
//        return nil;
//    }
//    
//    //软件版本更新数据模型初始化
//    S2iPdtFlowIdModel * pdtFlowIdModel = [[S2iPdtFlowIdModel alloc] init];
//    S2iPdtFlowIdDecInfoModel * infoModel;
//    pdtFlowIdModel.listInfo = [NSMutableArray array];   //数组初始化
//    
//    xmlNodePtr cur_node;
//    
//    for (cur_node = node; cur_node; cur_node = cur_node->next)
//    {
//        xmlNodePtr children;
//        for (children = cur_node->children; children; children = children->next)
//        {
//            xmlNodePtr cur_children_note = children->children;
//            xmlNodePtr node;
//            for (node = cur_children_note; node; node = node->next)
//            {
//                xmlChar* pNodeValue = xmlNodeListGetString(doc, node->children, 1);
//                //S2iLog(@"\t%s: %s", node->name, pNodeValue);
//                xmlNodePtr node2;
//                xmlNodePtr node3;
//                xmlNodePtr node4;
//                if (pNodeValue)
//                {
//                    xmlFree(pNodeValue);
//                }
//                else
//                {
//                    for (node2 = node->children; node2; node2 = node2->next)
//                    {
//                        xmlChar * pNodeValue2 = xmlNodeListGetString(doc, node2->children, 1);
//                        if (pNodeValue2)
//                        {
//                            
//                            if (strcmp((char*)node2->name, STR_XML_GETPDTFOLW_CURRENTNUMBER_TAG) == 0)
//                            {
//                                //当前解码次数
//                                [pdtFlowIdModel setCurrentNumber:[NSString stringWithUTF8String:(const char *)pNodeValue2]];
//                            }
//                            
//                            else if (strcmp((char*)node2->name, STR_XML_GETPDTFOLW_DESCRIPTION_TAG) == 0)
//                            {
//                                //真对解码次数文字描述
//                                [pdtFlowIdModel setStrDescription:[NSString stringWithUTF8String:(const char *)pNodeValue2]];
//                            }
//                            
//                            //遍历<PdtDecInfoList>元素节点的子节点
//                            xmlFree(pNodeValue2);
//                        }
//                        
//                        
//                        //
//                        for (node3 = node2->children; node3; node3 = node3->next)
//                        {
//                            //
//                             for (node4 = node3->children; node4; node4 = node4->next)
//                             {
//                                 xmlChar * pNodeValue4 = xmlNodeListGetString(doc, node4->children, 1);
//                                 if (pNodeValue4)
//                                 {
//                                     if (strcmp((char*)node4->name, STR_XML_GETPDTFOLW_ID_TAG) == 0)
//                                     {
//                                         //实例化模型
//                                         infoModel =  [[S2iPdtFlowIdDecInfoModel alloc] init];;
//                                         
//                                         //ID
//                                         [infoModel setNId:[NSString stringWithUTF8String:(const char *)pNodeValue4]];
//                                     }
//                                     
//                                     else if (strcmp((char*)node4->name, STR_XML_GETPDTFOLW_DECTIME_TAG) == 0)
//                                     {
//                                         //事件
//                                         [infoModel setDecTime:[NSString stringWithUTF8String:(const char *)pNodeValue4]];
//                                     }
//                                     
//                                     else if (strcmp((char*)node4->name, STR_XML_GETPDTFOLW_IP_TAG) == 0)
//                                     {
//                                         //ip
//                                         [infoModel setIp:[NSString stringWithUTF8String:(const char *)pNodeValue4]];
//                                     }
//                                     
//                                     else if (strcmp((char*)node4->name, STR_XML_GETPDTFOLW_ADDRESS_TAG) == 0)
//                                     {
//                                         //地址
//                                         [infoModel setAddress:[NSString stringWithUTF8String:(const char *)pNodeValue4]];
//                                         
//                                         //添加到数组中
//                                         [pdtFlowIdModel.listInfo addObject:infoModel];
//                                         
//                                     }
//                                 }
//                             }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    xmlFreeDoc(doc);
//    
//    return pdtFlowIdModel;
    return nil;
}









#pragma mark - 通过服务器返回的数据（字符串），查找里面的节点，来判断调用的哪个WEB SERVICE的接口。
+ (enumRequestInterface)detectRequestInferfaceName:(NSString *)responseXML
{
    enumRequestInterface enumReturn = ENUM_REQUEST_INTERFACE_UNKNOWN;
    
    S2iLog(@"enumReturn===%d", enumReturn);
    
    //遍历XML中的元素节点，找关键字。
    xmlDocPtr doc = xmlParseMemory([responseXML UTF8String], (int)strlen([responseXML UTF8String]));
    if (!doc)
    {
        return enumReturn;
    }
    xmlNodePtr root = xmlDocGetRootElement(doc);
    if (!root)
    {
        xmlFreeDoc(doc);
        return enumReturn;
    }
    xmlNodePtr node = root->children;
    if (!node)
    {
        xmlFreeDoc(doc);
        return enumReturn;
    }
    xmlNodePtr cur_node;
    for (cur_node = node; cur_node; cur_node = cur_node->next)
    {
        xmlNodePtr children;
        for (children = cur_node->children; children; children = children->next)
        {
            S2iLog(@"xml mark - interface tag : %s\n", children->name);
            //调用是SoftwareUpgrade接口（软件升级接口）
            if (strcmp((char*)children->name, STR_XML_SOFTWAREVERSONINFORESPONSE_TAG) == 0)
            {
                S2iLog(@"调用版本更新接口！");
                enumReturn = ENUM_REQUEST_INTERFACE_SOFTWAREUPGRADE;
                break;
            }
            
            //调用的是DecPdtSignet接口（商品签章解码接口）
            else if (strcmp((char*)children->name, STR_XML_DECPDTSIGNET_INTERFACE_TAG) == 0)
            {
                S2iLog(@"调用商品签章解码接口！");
                enumReturn = ENUM_REQUEST_INTERFACE_DECPDTSIGNET;
                break;
            }
            
            //调用的是AddPhoneDeviceInfo接口（添加手机型号接口）
            else if (strcmp((char*)children->name, STR_XML_ADDPHONEDEVICEINFORESPONSE_TAG) == 0)
            {
                S2iLog(@"调用添加手机型号接口！");
                enumReturn = ENUM_REQUEST_INTERFACE_ADDPHONEDEVICEINFO;
                break;
            }
            
            //调用的是GetPdtFolwIdServiceInfo接口（获取一标一码相应的服务信息接口）
            else if (strcmp((char*)children->name, STR_XML_GETPDTFOLWIDSERVICEINFORESPONSE_TAG) == 0)
            {
                S2iLog(@"获取一标一码相应的服务信息接口！");
                enumReturn = ENUM_REQUEST_INTERFACE_GETPDTFOLWIDSERVICEINFO;
                break;
            }
            
            //调用的是GetPdtInfoBySerialNO接口（获取防伪码基础信息,通过流水号）
            else if (strcmp((char*)children->name, STR_XML_GETPDTINFOBYSERIALNO_TAG) == 0)
            {
                S2iLog(@"获取一标一码相应的服务信息接口！");
                enumReturn = ENUM_REQUEST_INTERFACE_GETPDTINFOBYSERIALNO;
                break;
            }
            
            //调用的是GetSlidePictureList接口（获取图片集合）
            else if (strcmp((char*)children->name, STR_xml_GETSLIDEPICTURELIST_TAG) == 0)
            {
                S2iLog(@"获取获取图片集合接口！");
                enumReturn = ENUM_REQUEST_INTERFACE_GETSIDEPICTURELIST;
                break;
            }
        }
    }
    xmlFreeDoc(doc); 

    return enumReturn;
}




@end

//
//  TYNetworkingConst.h
//  Legend
//
//  Created by yons on 17/6/5.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef AGNetworkingConst_h
#define AGNetworkingConst_h

#ifdef DEBUG
#define AGNetworkString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define TYNetworkLog(...) printf("\n\n--- TYNetworking BEGIN ---\n%s 第%d行: %s\n--- TYNetworking END ---\n\n", [AGNetworkString UTF8String], __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define TYNetworkLog(...)
#endif

#define TYNetworkExecuteBlock(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

typedef void (^TYCompletionHandler)(id _Nullable responseObject, NSError *_Nullable error);
//typedef void (^AGProgressBlock)(NSProgress *_Nullable progress);
typedef void (^TYSuccessBlock)(id _Nullable responseObject);
typedef void (^TYFailureBlock)(id _Nullable responseObject, NSError *_Nullable error);
typedef void (^TYFinishedBlock)(id _Nullable responseObject, NSError *_Nullable error);
typedef void (^TYCancelBlock)(id _Nullable request);

typedef NS_ENUM(NSInteger, TYNetworkRequestType) {
    TYNetworkRequestNormal = 0,   //!< Normal HTTP request type, such as GET, POST, ...
    TYNetworkRequestUpload = 1,   //!< Upload request type
    TYNetworkRequestDownload = 2, //!< Download request type
};

/**
 *  请求方式
 */
typedef NS_ENUM(NSUInteger, TYNetworkHttpMethodType) {
    TYNetworkHttpMethodTypeGET = 0,
    TYNetworkHttpMethodTypePOST = 1,
    TYNetworkHttpMethodTypeDELETE = 2,
    TYNetworkHttpMethodTypeHEAD = 3,
    TYNetworkHttpMethodTypePUT = 4,
    TYNetworkHttpMethodTypePATCH = 5
};

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, TYNetworkReachabilityStatus) {
    TYNetworkReachabilityStatusUnknown = -1,
    TYNetworkReachabilityStatusNotReachable = 0,
    TYNetworkReachabilityStatusReachableViaWWAN = 1,
    TYNetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSInteger, TYNetworkRequestSerializerType) {
    TYNetworkRequestSerializerRAW = 0,   //!< Encodes parameters to a query string and put it into HTTP body, setting the `Content-Type` of the encoded request to default value `application/x-www-form-urlencoded`.
    TYNetworkRequestSerializerJSON = 1,  //!< Encodes parameters as JSON using `NSJSONSerialization`, setting the `Content-Type` of the encoded request to `application/json`.
    TYNetworkRequestSerializerPlist = 2, //!< Encodes parameters as Property List using `NSPropertyListSerialization`, setting the `Content-Type` of the encoded request to `application/x-plist`.
};

typedef NS_ENUM(NSInteger, TYNetworkResponseSerializerType) {
    TYNetworkResponseSerializerRAW = 0,   //!< Validates the response status code and content type, and returns the default response data.
    TYNetworkResponseSerializerJSON = 1,  //!< Validates and decodes JSON responses using `NSJSONSerialization`, and returns a NSDictionary/NSArray/... JSON object.
    TYNetworkResponseSerializerPlist = 2, //!< Validates and decodes Property List responses using `NSPropertyListSerialization`, and returns a property list object.
    TYNetworkResponseSerializerXML = 3,   //!< Validates and decodes XML responses as an `NSXMLParser` objects.
};

#endif /* AGNetworkingConst_h */

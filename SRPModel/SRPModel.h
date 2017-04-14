//
// Copyright (c) 2016 shinren.pan@gmail.com
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SRPModel;

/**
 *  SRPModel Protocol, 可以利用這個 protocal 客製化你的 model 包含:
 *
 *  - Keys mapping: 參考 keyMapping
 *  - 將某個 NSArray Property 轉換成 SRPModel NSArray: 參考 arrayToModels:forKey:
 *  - 自定義 Key default value: 參考 defaultKeysValues
 */
@protocol SRPModelProtocol

@optional


///-----------------------------------------------------------------------------
/// @name Optional methods
///-----------------------------------------------------------------------------

/**
 *  自定義 Key mapping.
 *
 *  Ex: `@{@"FromKey" : @"PropertyKey"}`
 *
 *  @return 返回自定義的 Key mapping.
 */
+ (NSDictionary <NSString *, NSString *> *)keyMapping;

/**
 *  自定義 Key default value.
 *
 *  EX: `@{@"Key" : @"Default value"}`
 *
 *  @return 返回自定義的 Default keys and values.
 */
+ (NSDictionary *)defaultKeysValues;

/**
 *  將指定的 Property Array 轉換成 SRPModel Array.
 *
 *  @param array 原本的 Array Source.
 *  @param key 指定轉換的 Property.
 *
 *  @return 返回 SRPModel Array.
 */
+ (NSArray *)arrayToModels:(NSArray *)array forKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("use (propertyName)TransformValue: instead.");

@end


/**
 *  簡單利用 KVC 將 NSArray, NSDictionary, JSON String 轉成 Model 型態, 支援 NSCoding.
 */
@interface SRPModel : NSObject<SRPModelProtocol, NSCoding>


///-----------------------------------------------------------------------------
/// @name Class methods
///-----------------------------------------------------------------------------

/**
 *  Models from id.
 *
 *  @param object from source.
 *
 *  @return 返回 SRPModel 集合.
 */
+ (nullable NSArray <__kindof SRPModel *> *)modelsFromObject:(nullable id)object;

/**
 *  Models from NSArray.
 *
 *  @param array from source.
 *
 *  @return 返回 SRPModel 集合.
 */
+ (nullable NSArray <__kindof SRPModel *> *)modelsFromArray:(nullable NSArray *)array;

/**
 *  Models from JSON string.
 *
 *  @param json from source.
 *
 *  @return 返回 SRPModel 集合.
 */
+ (nullable NSArray <__kindof SRPModel *> *)modelsFromJSONString:(nullable NSString *)json;

/**
 *  Model from id.
 *
 *  @param object from source.
 *
 *  @return 返回 SRPModel 物件.
 */
+ (nullable instancetype)modelFromObject:(nullable id)object;

/**
 *  Model from NSDictionary.
 *
 *  @param dic from source.
 *
 *  @return 返回 SRPModel 物件.
 */
+ (nullable instancetype)modelFromDictionary:(nullable NSDictionary *)dic;

/**
 *  Model from JSON string.
 *
 *  @param json from source.
 *
 *  @return 返回 SRPModel 物件.
 */
+ (nullable instancetype)modelFromJSONString:(nullable NSString *)json;


///-----------------------------------------------------------------------------
/// @name Public methods
///-----------------------------------------------------------------------------

/**
 *  轉成 NSDictionary.
 *
 *  @return 將 SRPModel 轉成 NSDictionary.
 */
- (NSDictionary *)toDictionary;

/**
 *  轉成 JSON String
 *
 *  @return 將 SRPModel 轉成 JSON String.
 */
- (NSString *)toJSONString;

@end

NS_ASSUME_NONNULL_END

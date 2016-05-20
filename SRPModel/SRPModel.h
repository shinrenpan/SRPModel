// SRPModel.h
// Version 1.0.0
// Copyright (c) 2016年 shinren.pan@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

/**
 *  SRPModel Protocol
 */
@protocol SRPModelProtocol

@optional


///-----------------------------------------------------------------------------
/// @name Optional methods
///-----------------------------------------------------------------------------

/**
 *  返回自定義的 property mapping
 *
 *  @return 返回自定義的 property mapping
 */
+ (NSDictionary *)propertyMapping;

/**
 *  將自定義的 property 轉換成 SRPModel 集合.
 *
 *  @param array from source.
 *  @param property 欲轉換的 property
 *
 *  @return 返回 SRPModel 集合.
 */
+ (NSArray *)newModelsFromArray:(NSArray *)array forProperty:(NSString *)property;

@end


/**
 *  簡單利用 KVC 轉換的 model.
 */
@interface SRPModel : NSObject<SRPModelProtocol>


///-----------------------------------------------------------------------------
/// @name Class methods
///-----------------------------------------------------------------------------

/**
 *  Models from NSArray.
 *
 *  @param array from source.
 *
 *  @return 返回 SRPModel 集合.
 */
+ (NSArray *)modelsFromArray:(NSArray *)array;

/**
 *  Models from JSON string.
 *
 *  @param json from source.
 *
 *  @return 返回 SRPModel 集合.
 */
+ (NSArray *)modelsFromJSONString:(NSString *)json;

/**
 *  Model from NSDictionary.
 *
 *  @param dic from source.
 *
 *  @return 返回 SRPModel 物件
 */
+ (instancetype)modelFromDictionary:(NSDictionary *)dic;

/**
 *  Model from JSON string
 *
 *  @param json from source.
 *
 *  @return 返回 SRPModel 物件
 */
+ (instancetype)modelFromJSONString:(NSString *)json;


///-----------------------------------------------------------------------------
/// @name Public methods
///-----------------------------------------------------------------------------

/**
 *  將 Model 轉成 NSDictionary
 *
 *  @return 將 Model 轉成 NSDictionary
 */
- (NSDictionary *)toDictionary;

/**
 *  將 Model 轉成 JSON String
 *
 *  @return 將 Model 轉成 JSON String
 */
- (NSString *)toJSON;

@end
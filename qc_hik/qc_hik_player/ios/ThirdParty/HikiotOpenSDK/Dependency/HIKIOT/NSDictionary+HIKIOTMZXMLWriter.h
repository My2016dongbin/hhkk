//
//  NSDictionary+MZXMLWriter.h
//  PM_MZXMLWriter_ToolCmp_Example
//
//  Created by Maybe Zh on 2018/1/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define MZXMLWriterDictionaryCombineDefault(root, dict) MZXMLWriterDictionaryCombineElements(root, dict, @"2.0", @"http://www/isapi.org/ver20/XMLSchema")

#define MZXMLWriterDictionaryCombineElements(root, dict, version, xmlns) \
({   \
    NSMutableDictionary *result = dict.mutableCopy; \
    result[MZXMLWriterAttributeKey] = @{  \
        @"version" : version,   \
        @"xmlns" : xmlns    \
    };\
    result = (id)@{root : result}; \
    result; \
})
/// 属性key
extern NSString *const MZXMLWriterAttributeKey;
/**
 元素缺省key，使用于有属性且无元素的节点
<root version="2.0">value</root>
@{
    @"root" : @{
        MZXMLWriterElementDefaultKey : @"value",
        MZXMLWriterAttributeKey : @{
            @"version" : @"2.0"
        }
    }
}
 */
extern NSString *const MZXMLWriterElementDefaultKey;
/**
 节点数据自定义
 
 @param key 节点
 @param value 数据
 @param result 转换后的数据
 @return 自定义转换后的数据
 */
typedef NSString *_Nonnull(^MZXWValueTransform)(NSString *key, id value, NSString *result);

@interface NSDictionary (HIKIOTMZXMLWriter)

/// 转换后的xml
@property (nonatomic, readonly, copy) NSString *mzxw_xmlString;

@property (nullable, nonatomic, copy) MZXWValueTransform mzxw_transform;
/// 数组key排序 (报警主机项目用到)
@property (nullable, nonatomic, copy) NSComparator mzxw_cmptr;

@end

NS_ASSUME_NONNULL_END

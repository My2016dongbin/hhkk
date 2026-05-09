
#import <Foundation/Foundation.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, SMXMLDictionaryAttributesMode)
{
    SMXMLDictionaryAttributesModePrefixed = 0, //default
    SMXMLDictionaryAttributesModeDictionary,
    SMXMLDictionaryAttributesModeUnprefixed,
    SMXMLDictionaryAttributesModeDiscard
};


typedef NS_ENUM(NSInteger, SMXMLDictionaryNodeNameMode)
{
    SMXMLDictionaryNodeNameModeRootOnly = 0, //default
    SMXMLDictionaryNodeNameModeAlways,
    SMXMLDictionaryNodeNameModeNever
};


static NSString *const SMXMLDictionaryAttributesKey   = @"__attributes";
static NSString *const SMXMLDictionaryCommentsKey     = @"__comments";
static NSString *const SMXMLDictionaryTextKey         = @"__text";
static NSString *const SMXMLDictionaryNodeNameKey     = @"__name";
static NSString *const SMXMLDictionaryAttributePrefix = @"_";


@interface HIKIOTXMLDictionaryParser : NSObject <NSCopying>

+ (HIKIOTXMLDictionaryParser *)sharedInstance;

@property (nonatomic, assign) BOOL collapseTextNodes; // defaults to YES
@property (nonatomic, assign) BOOL stripEmptyNodes;   // defaults to YES
@property (nonatomic, assign) BOOL trimWhiteSpace;    // defaults to YES
@property (nonatomic, assign) BOOL alwaysUseArrays;   // defaults to NO
@property (nonatomic, assign) BOOL preserveComments;  // defaults to NO
@property (nonatomic, assign) BOOL wrapRootNode;      // defaults to NO

@property (nonatomic, assign) SMXMLDictionaryAttributesMode attributesMode;
@property (nonatomic, assign) SMXMLDictionaryNodeNameMode nodeNameMode;

- (nullable NSDictionary<NSString *, id> *)dictionaryWithParser:(NSXMLParser *)parser;
- (nullable NSDictionary<NSString *, id> *)dictionaryWithData:(NSData *)data;
- (nullable NSDictionary<NSString *, id> *)dictionaryWithString:(NSString *)string;
- (nullable NSDictionary<NSString *, id> *)dictionaryWithFile:(NSString *)path;

@end


@interface NSDictionary (SMXMLDictionary)

+ (nullable NSDictionary<NSString *, id> *)dictionaryWithXMLParser:(NSXMLParser *)parser;
+ (nullable NSDictionary<NSString *, id> *)dictionaryWithXMLData:(NSData *)data;
+ (nullable NSDictionary<NSString *, id> *)dictionaryWithXMLString:(NSString *)string;
+ (nullable NSDictionary<NSString *, id> *)dictionaryWithXMLFile:(NSString *)path;

@property (nonatomic, readonly, copy, nullable) NSDictionary<NSString *, NSString *> *attributes;
@property (nonatomic, readonly, copy, nullable) NSDictionary<NSString *, id> *childNodes;
@property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *comments;
@property (nonatomic, readonly, copy, nullable) NSString *nodeName;
@property (nonatomic, readonly, copy, nullable) NSString *innerText;
@property (nonatomic, readonly, copy) NSString *innerXML;
@property (nonatomic, readonly, copy) NSString *XMLString;

- (nullable NSArray *)arrayValueForKeyPath:(NSString *)keyPath;
- (nullable NSString *)stringValueForKeyPath:(NSString *)keyPath;
- (nullable NSDictionary<NSString *, id> *)dictionaryValueForKeyPath:(NSString *)keyPath;

@end


@interface NSString (SMXMLDictionary)

@property (nonatomic, readonly, copy) NSString *XMLEncodedString;

@end


NS_ASSUME_NONNULL_END


#pragma GCC diagnostic pop

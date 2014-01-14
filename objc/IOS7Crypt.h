@interface IOS7Crypt: NSObject

+ (NSArray*) xlat;
+ (NSArray*) xlat: (NSUInteger) start andLength: (NSUInteger) length;

+ (NSString*) encrypt: (const NSString*) password;
+ (NSString*) decrypt: (const NSString*) hash;

@end

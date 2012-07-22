
#import <Foundation/Foundation.h>

@interface MovieRequest : NSObject

@property (readonly) BOOL active;
@property (nonatomic, assign) id delegate;

- (void) start;
- (void) stop;

@end

@protocol MovieRequestDelegate

@optional

- (void) movieRequest: (MovieRequest *) request didSucceed: (NSDictionary *) data;
- (void) movieRequest: (MovieRequest *) request didFailWithError: (NSError *) error; 

@end
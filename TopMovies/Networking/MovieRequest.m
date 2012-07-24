
#import "MovieRequest.h"
#import "SimpleRESTRequest.h"

@interface MovieRequest()

@property (nonatomic, strong) SimpleRESTRequest *restRequest;

@end


@implementation MovieRequest

@synthesize active;
@synthesize delegate;
@synthesize restRequest;


- (id) init
{
    self = [super init];
    if(self)
    {
        NSString *baseURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MovieRequestBaseURL"];
        NSMutableString *targetPath = [NSMutableString stringWithString: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MovieRequestTargetPath"]];
        [targetPath appendString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"MovieRequestAPIKey"]];
        
        restRequest = [[SimpleRESTRequest alloc] initWithBaseURL:baseURL targetURL:targetPath];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        [defaultCenter addObserver:self 
                          selector:@selector(requestFailed:) 
                              name:SimpleRESTRequestDidFailNotification 
                            object:self.restRequest];
        
        [defaultCenter addObserver:self 
                          selector:@selector(requestSucceeded:) 
                              name:SimpleRESTRequestDidSucceedNotification 
                            object:self.restRequest];
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - instance methods

- (BOOL) isActive
{
    if(self.restRequest && self.restRequest.running)
    {
        return YES;
    }
    
    return NO;
}

- (void) requestFailed: (NSNotification *) notification
{
    NSLog(@"Request failed");
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(movieRequest:didFailWithError:)])
    {
        [self.delegate movieRequest: self didFailWithError: nil];
    }
}

- (void) requestSucceeded: (NSNotification *) notification
{
    NSLog(@"Request succeeded");
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(movieRequest:didSucceed:)])
    {
        [self.delegate movieRequest: self didSucceed:[notification.userInfo valueForKey: SimpleRESTRequestJSONKey]];
    }
}

- (void) start
{
    if([self isActive]) return;
    
    [self.restRequest start];
}

- (void) stop
{
    [self.restRequest stop];
}

@end

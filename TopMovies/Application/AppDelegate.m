
#import "AppDelegate.h"
#import "MovieListViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    MovieListViewController *movieListViewController = [[MovieListViewController alloc] initWithNibName:@"MovieListViewController" bundle:nil];
    self.window.rootViewController = movieListViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

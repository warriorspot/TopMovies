
#import "AppDelegate.h"
#import "MovieListViewController.h"

@implementation AppDelegate

@synthesize navigationController;
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    MovieListViewController *movieListViewController = [[MovieListViewController alloc] initWithNibName:@"MovieListViewController" bundle:nil];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:movieListViewController];
    navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

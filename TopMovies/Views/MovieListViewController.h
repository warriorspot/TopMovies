
#import <UIKit/UIKit.h>

@class MovieRequest;

@interface MovieListViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *movieTableView;

@property (readonly, strong) MovieRequest *movieRequest;
@property (readonly, strong) NSMutableArray *movies;

@end

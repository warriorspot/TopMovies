
#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *moviePosterImageView;
@property (nonatomic, strong) IBOutlet UILabel *synopsisHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *synopsisLabel;
@property (nonatomic, strong) IBOutlet UILabel *castHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *castLabel;
@property (nonatomic, strong) IBOutlet UIView *divider;
@property (nonatomic, strong) IBOutlet UILabel *summaryLabel;

- (void) displayMovieWithMovieData: (NSDictionary *) movie;

@end


#import <UIKit/UIKit.h>

@class MovieDetailScrollView;

@interface MovieDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *movieData;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet MovieDetailScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *moviePosterImageView;
@property (nonatomic, strong) IBOutlet UILabel *synopsisHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *synopsisLabel;
@property (nonatomic, strong) IBOutlet UILabel *castHeaderLabel;
@property (nonatomic, strong) IBOutlet UIView *divider;
@property (nonatomic, strong) IBOutlet UILabel *summaryLabel;
@property (nonatomic, strong) UIBarButtonItem *tweetButton;

@end

extern CGSize const MaximumSynopsisSize;
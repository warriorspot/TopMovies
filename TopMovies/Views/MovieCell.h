
#import <UIKit/UIKit.h>

/// Displays title, rating, tomatometer rating,
/// and poster for a movie.
///
@interface MovieCell : UITableViewCell

/// The title of the movie
@property (nonatomic, strong) NSString * title;

/// The MPAA assigned rating (G, PG, etc..)
@property (nonatomic, strong) NSString * rating;

/// The critical rating (on a scale of 0.0 to 100.0) of the movie
@property CGFloat criticRating;

/// The movie poster image
@property (nonatomic, strong) UIImage * posterImage;

@end

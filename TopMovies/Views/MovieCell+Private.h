
/// Private interface to MovieCell.  "Hides" the underlying
/// UIKit implementation of the visuals of the cell.
///
@interface MovieCell()
{
@private
    CGSize defaultTitleSize;
}

/// Label to display the movie title
@property (nonatomic, strong) IBOutlet UILabel *movieTitleLabel;

/// Progress view to show the critics rating of the movie
@property (nonatomic, strong) IBOutlet UIProgressView *criticRatingProgressView;

/// Image view for the rating image 
@property (nonatomic, strong) IBOutlet UIImageView *ratingImageView;

/// Image view for the movie poster
@property (nonatomic, strong) IBOutlet UIImageView *posterImageView;

/// Maps a rating string ("G", "PG") to the image name to display
/// for that rating.
@property (nonatomic, strong) NSDictionary *ratingsDictionary;

@end
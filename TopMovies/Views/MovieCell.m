
#import "MovieCell.h"
#import <UIKit/UIStringDrawing.h>

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


@implementation MovieCell

@synthesize movieTitleLabel;
@synthesize criticRatingProgressView;
@synthesize ratingImageView;
@synthesize posterImageView;
@synthesize ratingsDictionary;

@synthesize rating;

#pragma mark - UITableViewCell methods

- (NSString *) reuseIdentifier
{
    return @"MovieCell";
}

#pragma mark - instance methods

- (UIImage *) posterImage
{
    return self.posterImageView.image;
}

- (void) setPosterImage: (UIImage *) image
{
    self.posterImageView.image = image;
}

- (void) setRating: (NSString *) newRating
{
    rating = newRating;
    
    if(!self.ratingsDictionary)
    {
        [self initializeRatingsDictionary];
    }
    
    UIImage *image = [UIImage imageNamed:[self.ratingsDictionary valueForKey:rating]];
    self.ratingImageView.image = image;
}

- (NSString *) title
{
    return self.movieTitleLabel.text;
}

- (void) setTitle: (NSString *) title
{
    [self adjustTitleAndRatingForTitle:title];
    self.movieTitleLabel.text = title;
}

- (void) setCriticRating: (CGFloat) newRating
{
    self.criticRatingProgressView.progress = newRating;
}

- (CGFloat) criticRating
{
    return self.criticRatingProgressView.progress;
}

#pragma mark - private methods

- (void) adjustTitleAndRatingForTitle: (NSString *) title
{
    CGRect titleLabelFrame = self.movieTitleLabel.frame;
    if(CGSizeEqualToSize(defaultTitleSize, CGSizeZero)) 
    {
        defaultTitleSize = CGSizeMake(titleLabelFrame.size.width, titleLabelFrame.size.height);
    }
    
    UIFont *font = self.movieTitleLabel.font;
    CGSize titleSize = [title sizeWithFont: font constrainedToSize:defaultTitleSize lineBreakMode:UILineBreakModeTailTruncation];
    
    titleLabelFrame.size = titleSize;
    self.movieTitleLabel.frame = titleLabelFrame;
    
    CGRect ratingImageFrame = self.ratingImageView.frame;
    ratingImageFrame.origin.x = self.movieTitleLabel.frame.origin.x + self.movieTitleLabel.frame.size.width + 5.0f;
    self.ratingImageView.frame = ratingImageFrame;
}

- (void) initializeRatingsDictionary
{
    ratingsDictionary = [[NSMutableDictionary alloc] init];
    [ratingsDictionary setValue:@"g.png" forKey:@"G"];
    [ratingsDictionary setValue:@"nc_17.png" forKey:@"NC-17"];
    [ratingsDictionary setValue:@"pg.png" forKey:@"PG"];
    [ratingsDictionary setValue:@"pg_13.png" forKey:@"PG-13"];
    [ratingsDictionary setValue:@"r.png" forKey:@"R"];
}
@end

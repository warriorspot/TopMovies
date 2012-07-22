
#import "MovieCell.h"
#import "MovieCell+Private.h"
#import <UIKit/UIStringDrawing.h>

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

- (void) initializeCellWithMovieData: (NSDictionary *) movie
{
    self.title = [movie valueForKey: @"title"];
    self.rating = [movie valueForKey: @"mpaa_rating"];
    NSDictionary *ratings = [movie valueForKey:@"ratings"];
    CGFloat criticRating = [[ratings valueForKey:@"critics_score"] floatValue] * .01;
    self.criticRating = criticRating;
    NSDictionary *posters = [movie valueForKey:@"posters"];
    NSString *imageURL = [posters valueForKey:@"thumbnail"];
    self.posterImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
}

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
    UIFont *font = self.movieTitleLabel.font;
    CGSize size = [title sizeWithFont: font constrainedToSize:CGSizeMake(170, 20) lineBreakMode:UILineBreakModeTailTruncation];
    CGRect frame = self.movieTitleLabel.frame;
    frame.size = size;
    self.movieTitleLabel.frame = frame;
    frame = self.ratingImageView.frame;
    frame.origin.x = self.movieTitleLabel.frame.origin.x + self.movieTitleLabel.frame.size.width + 5.0f;
    self.ratingImageView.frame = frame;
    
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

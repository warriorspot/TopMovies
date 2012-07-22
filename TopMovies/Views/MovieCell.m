
#import "MovieCell.h"
#import "MovieCell+Private.h"

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

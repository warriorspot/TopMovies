
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

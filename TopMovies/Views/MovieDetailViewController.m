
#import "MovieDetailViewController.h"
#import "MovieDetailViewController+Private.h"

@implementation MovieDetailViewController

@synthesize scrollView;
@synthesize moviePosterImageView;
@synthesize synopsisHeaderLabel;
@synthesize synopsisLabel;
@synthesize castHeaderLabel;
@synthesize castLabel;
@synthesize divider;
@synthesize summaryLabel;
@synthesize movieData;

- (void) viewWillAppear:(BOOL)animated
{
    [self initializeWithMovieData:self.movieData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private methods

- (void) adjustSynopsisLabelForString: (NSString *) string
{
    CGRect synopsisLabelFrame = self.synopsisLabel.frame;

    UIFont *font = self.synopsisLabel.font;
    CGSize synopsisSize = [string sizeWithFont: font constrainedToSize:MaximumSynopsisSize lineBreakMode:self.synopsisLabel.lineBreakMode];
    synopsisLabelFrame.size = synopsisSize;
    self.synopsisLabel.frame = synopsisLabelFrame;
}

- (void) initializeWithMovieData:(NSDictionary *)movie
{
    if(movie == nil) return;
    
    NSDictionary *posters = [movie valueForKey:@"posters"];
    NSString *imageURL = [posters valueForKey:@"detailed"];

    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    self.moviePosterImageView.image = image;
    
    NSString *synopsis = [movie valueForKey:@"synopsis"];
    [self adjustSynopsisLabelForString:synopsis];
    self.synopsisLabel.text = synopsis;
}

@end

CGSize const MaximumSynopsisSize = {.width = 280.0, .height = 840.0};

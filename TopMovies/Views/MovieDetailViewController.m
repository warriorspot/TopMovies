
#import "MovieDetailViewController.h"
#import "MovieDetailViewController+Private.h"
#import <Twitter/TWTweetComposeViewController.h>

#define SPACER 5.0f

@implementation MovieDetailViewController

@synthesize activityIndicator;
@synthesize scrollView;
@synthesize moviePosterImageView;
@synthesize synopsisHeaderLabel;
@synthesize synopsisLabel;
@synthesize castHeaderLabel;
@synthesize divider;
@synthesize summaryLabel;
@synthesize movieData;
@synthesize tweetButton;

- (void) viewDidAppear:(BOOL)animated
{
    [self initializeWithMovieData:self.movieData];
    [super viewDidAppear:animated];
}

- (void) viewDidLoad
{
    self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" 
                                                        style:UIBarButtonItemStyleBordered 
                                                       target:self 
                                                       action:@selector(didSelectTweet:)];
    self.tweetButton.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = self.tweetButton;
}

- (void) viewDidUnload
{
    self.activityIndicator = nil;
    self.scrollView = nil;
    self.moviePosterImageView = nil;
    self.synopsisHeaderLabel = nil;
    self.synopsisLabel = nil;
    self.castHeaderLabel = nil;
    self.divider = nil;
    self.summaryLabel = nil;
    self.tweetButton = nil;
    
    [super viewDidUnload];
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

- (void) didSelectTweet: (id) sender
{
    if([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
        NSURL *link = [self linkFromMovieData];
        [tweetController addURL:link];
        [self presentModalViewController:tweetController animated:YES];
    }
    else 
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:NSLocalizedString(@"TWITTER_NOT_AVAILABLE", NULL)
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) initializeWithMovieData:(NSDictionary *) movie
{
    if(movie == nil) return;
    
    NSDictionary *posters = [movie valueForKey:@"posters"];
    NSString *imageURL = [posters valueForKey:@"detailed"];

    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    self.moviePosterImageView.image = image;
    
    // Synopsis
    NSString *synopsis = [movie valueForKey:@"synopsis"];
    [self adjustSynopsisLabelForString:synopsis];
    self.synopsisLabel.text = synopsis;
    
    // Cast
    NSUInteger startY = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height;
    CGRect frame = self.castHeaderLabel.frame;
    frame.origin.y = startY + SPACER;
    self.castHeaderLabel.frame = frame;
    startY = startY + frame.size.height + SPACER;
    
    CGRect castEntryFrame = CGRectZero;
    NSArray *abridgedCast = [movie valueForKey:@"abridged_cast"];
    for(NSDictionary *castMember in abridgedCast)
    {
        NSString *actor = [castMember valueForKey:@"name"];
        NSArray *characters = [castMember valueForKey:@"characters"];
        // Only show first character played
        NSString *character = [characters objectAtIndex:0];
        NSString *castEntry = [NSString stringWithFormat:@"%@ as %@", actor, character];
        
        UILabel *castEntryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, startY, 320.0f, 25.0f)];
        castEntryLabel.font = [UIFont systemFontOfSize:12.0f];
        castEntryLabel.textAlignment = UITextAlignmentLeft;
        castEntryLabel.textColor = [UIColor blackColor];
    
        CGRect castEntryFrame = castEntryLabel.frame;
        castEntryFrame.origin.y = startY;
        castEntryLabel.text = castEntry;
        
        startY = startY + castEntryFrame.size.height + SPACER;
        
        [self.scrollView addSubview:castEntryLabel];
    }
    
    startY = startY + castEntryFrame.origin.y + SPACER;
    
    // Divider
    
    frame = self.divider.frame;
    frame.origin.y = startY;
    self.divider.frame = frame;
    startY = startY + frame.size.height + SPACER;
    
    // Summary
    NSString *rated = [movie valueForKey:@"mpaa_rating"];
    NSDictionary *ratings = [movie valueForKey:@"ratings"];
    NSString *freshness = [ratings valueForKey:@"critics_score"];
    NSString *runtime = [movie valueForKey:@"runtime"];
    NSInteger runtimeMinutes = [runtime intValue];
    NSInteger runtimeHours = runtimeMinutes / 60;
    runtimeMinutes = runtimeMinutes - (runtimeHours * 60);
    
    NSString *summaryString = [NSString stringWithFormat:@"Rated %@ - Freshness: %@%% - Runtime: %dhr %dmin", rated, freshness, runtimeHours, runtimeMinutes];
    self.summaryLabel.text = summaryString;
    
    frame = self.summaryLabel.frame;
    frame.origin.y = startY;
    summaryLabel.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(320.0f, frame.origin.y + frame.size.height + SPACER);
}

- (NSURL *) linkFromMovieData
{
    NSDictionary *links = [self.movieData valueForKey:@"links"];
    NSString *linkString = [links valueForKey:@"alternate"];
    NSURL *url = [NSURL URLWithString:linkString];
    
    return url;
}

@end

CGSize const MaximumSynopsisSize = {.width = 280.0, .height = 840.0};

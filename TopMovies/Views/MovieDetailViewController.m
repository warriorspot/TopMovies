
#import "MovieDetailViewController.h"

@implementation MovieDetailViewController

@synthesize moviePosterImageView;
@synthesize synopsisHeaderLabel;
@synthesize synopsisLabel;
@synthesize castHeaderLabel;
@synthesize castLabel;
@synthesize divider;
@synthesize summaryLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - instance methods

- (void) displayMovieWithMovieData:(NSDictionary *)movie
{
    
}

@end

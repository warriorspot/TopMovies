
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "MovieListViewController.h"
#import "MovieListViewController+Private.h"
#import "MovieRequest.h"
#import "Reachability.h"

@implementation MovieListViewController

@synthesize imageCache;
@synthesize movieRequest;
@synthesize movies;
@synthesize movieTableView;

- (void) didReceiveMemoryWarning
{
    self.movies = nil;
    self.imageCache = nil;
}

- (void) viewDidLoad
{
    self.title = @"Top 10 Movies";
    self.movieTableView.alpha = 0.0f;
    [super viewDidLoad];
}

- (void) viewDidUnload
{
    self.movies = nil;
    self.imageCache = nil;
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSIndexPath *selectedRow = [self.movieTableView indexPathForSelectedRow];
    if(selectedRow)
    {
        [self.movieTableView deselectRowAtIndexPath:selectedRow animated:NO];
    }
    
    if(self.movies == nil)
    {
        [self toggleView:self.movieTableView visible:NO animated: NO];
        [self requestMovies];
    }
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MovieRequest delegate

- (void) movieRequest: (MovieRequest *) request didSucceed: (NSDictionary *) data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"Data: %@", [data description]);
    
    if(movies == nil)
    {
        movies = [[NSMutableArray alloc] init];
    }
    
    [movies addObjectsFromArray:[self moviesFromData:data]];
    
    [self loadAndCacheImages];
    
    [self.movieTableView reloadData];
    
    [self toggleView:self.movieTableView visible:YES animated:YES];
}

- (void) movieRequest: (MovieRequest *) request didFailWithError: (NSError *) error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NETWORK_REQUEST_FAILED_TITLE", NULL) 
                                                    message:NSLocalizedString(@"NETWORK_REQUEST_FAILED", NULL) 
                                                   delegate:self 
                                          cancelButtonTitle:@"Ok" 
                                          otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - UIAlertViewDelegate methods

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self requestMovies];
    }
}

#pragma mark - UITableViewDelegate methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *movie = [self.movies objectAtIndex:indexPath.row];
    
    [self initializeCell: cell withMovieData:movie];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *movieData = [self.movies objectAtIndex:indexPath.row];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    MovieDetailViewController *detailViewController = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];
    detailViewController.movieData = movieData;
    
    [delegate.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableViewDataSource delegate methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   
{
    return [self.movies count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

#pragma mark - private methods

- (BOOL) connected
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        return NO;
    }
    
    return YES;
}

- (void) cacheImage: (UIImage *) image withURLString: (NSString *) URLString
{
    if(self.imageCache == nil)
    {
        self.imageCache = [[NSMutableDictionary alloc] init];
    }
    
    [self.imageCache  setValue:image forKey:URLString];
}

- (UIImage *) imageFromCacheWithURLString: (NSString *) URLString
{
    return [self.imageCache valueForKey:URLString];
}

- (void) initializeCell: (MovieCell *) cell withMovieData: (NSDictionary *) movie
{
    cell.title = [movie valueForKey: @"title"];
    cell.rating = [movie valueForKey: @"mpaa_rating"];
    NSDictionary *ratings = [movie valueForKey:@"ratings"];
    CGFloat criticRating = [[ratings valueForKey:@"critics_score"] floatValue] * .01;
    cell.criticRating = criticRating;
    NSDictionary *posters = [movie valueForKey:@"posters"];
    NSString *imageURL = [posters valueForKey:@"thumbnail"];

    UIImage *image = [self imageFromCacheWithURLString:imageURL];
    if(image == nil)
    {
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        [self cacheImage:image withURLString:imageURL];
    }
    
    cell.posterImage = image;
}

- (void) loadAndCacheImages
{
    for(NSDictionary *movie in self.movies)
    {
        NSDictionary *posters = [movie valueForKey:@"posters"];
        NSString *imageURL = [posters valueForKey:@"thumbnail"];
        
        UIImage *image = [self imageFromCacheWithURLString:imageURL];
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        [self cacheImage:image withURLString:imageURL];
    }
}

- (NSArray *) moviesFromData: (NSDictionary *) data
{
    NSMutableArray *newMovies = [NSMutableArray array];
    
    NSArray *movieList = [data valueForKey:@"movies"];
    if(movieList)
    {
        [newMovies addObjectsFromArray:movieList];
    }
    
    return newMovies;
}

- (void) requestMovies
{
    if(![self connected])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NETWORK_REQUEST_FAILED_TITLE", NULL)  
                                                            message:NSLocalizedString(@"NETWORK_NOT_CONNECTED", NULL) 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"NETWORK_NOT_CONNECTED_RETRY", NULL)  
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(self.movies)
    {
        [self.movies removeAllObjects];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    movieRequest = [[MovieRequest alloc] init];
    movieRequest.delegate = self;
    [movieRequest start];
}

- (void) toggleView: (UIView *) toggleView visible: (BOOL) visible animated: (BOOL) animated
{
    CGFloat newAlpha;
    
    if(visible)
    {
        newAlpha = 1.0f;
    }
    else
    {
        newAlpha = 0.0f;
    }
    
    if(animated)
    {
        [UIView beginAnimations:@"toggle_view" context:nil];
        [UIView setAnimationDuration:0.5f];
    }
    
    toggleView.alpha = newAlpha;
    
    if(animated)
    {
        [UIView commitAnimations];
    }
}

@end


#import "MBProgressHUD.h"
#import "MovieCell.h"
#import "MovieListViewController.h"
#import "MovieListViewController+Private.h"
#import "MovieRequest.h"

@interface MovieListViewController ()

@end

@implementation MovieListViewController

@synthesize imageCache;
@synthesize movieRequest;
@synthesize movies;
@synthesize movieTableView;

- (void) didReceiveMemoryWarning
{
    self.imageCache = nil;
}

- (void) viewDidLoad
{
    self.title = @"Top 10 Movies";
}

- (void) viewDidUnload
{
    self.imageCache = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self requestMovies];
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
    
    [self.movieTableView reloadData];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    movieRequest = [[MovieRequest alloc] init];
    movieRequest.delegate = self;
    [movieRequest start];
}

@end

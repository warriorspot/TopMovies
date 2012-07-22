
#import "MBProgressHUD.h"
#import "MovieCell.h"
#import "MovieListViewController.h"
#import "MovieRequest.h"

@interface MovieListViewController ()

@end

@implementation MovieListViewController

@synthesize movieRequest;
@synthesize movies;
@synthesize movieTableView;

- (void) viewDidLoad
{
    
}

- (void) viewDidUnload
{
    
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    NSDictionary *movie = [self.movies objectAtIndex:indexPath.row];
    
    cell.title = [movie valueForKey: @"title"];
    cell.rating = [movie valueForKey: @"mpaa-rating"];
    NSDictionary *ratings = [movie valueForKey:@"ratings"];
    cell.criticRating = [[ratings valueForKey:@"critics_score"] floatValue];
    NSDictionary *posters = [movie valueForKey:@"posters"];
    //NSString *imageURL = [posters valueForKey:@"thumbnail"];
    
    return cell;
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

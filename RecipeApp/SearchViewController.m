//
//  ViewController.m
//  RecipeApp
//
//  Created by Djavan Bertrand on 13/03/2015.
//
//

#import "SearchViewController.h"
#import "RecipeTableViewCell.h"
#import "RecipeDetailViewController.h"
#import "RequestManager.h"

@interface SearchViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) RecipeDetailViewController *detailVC;

@end

@implementation SearchViewController

- (void)customInit
{
    _dataSource = [[NSArray alloc] init];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enableSearchBar:(BOOL)enable {
    if (enable) {
        _searchBar.userInteractionEnabled = YES;
        _searchBar.translucent = YES;
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.backgroundColor = [UIColor clearColor];

    } else {
        // disable search bar during process
        _searchBar.userInteractionEnabled = NO;
        _searchBar.translucent = NO;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.backgroundColor = [UIColor lightGrayColor];
        [_searchBar resignFirstResponder];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // ShowDetail is mentionned in the storyboard segue
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {

        _detailVC = [segue destinationViewController];

        if ([_tableView indexPathForSelectedRow]) {
            _detailVC.recipeObject = [_dataSource objectAtIndex:[_tableView indexPathForSelectedRow].row];
            [_detailVC.view setHidden:NO];
        }
        else {
            [_detailVC.view setHidden:YES];
        }
    } else if ([[segue identifier] isEqualToString:@"ReplaceDetail"]) {
        if (_detailVC) {
            if ([_tableView indexPathForSelectedRow]) {
                _detailVC.recipeObject = [_dataSource objectAtIndex:[_tableView indexPathForSelectedRow].row];
                [_detailVC.view setHidden:NO];
            }
            else {
                [_detailVC.view setHidden:YES];
            }
        }
    }
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // the number of rows is equal to the number of entries in the data source
    int nbRows = 0;
    if (_dataSource)
    {
        nbRows = [_dataSource count];
    }
    return nbRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeTableViewCellId" forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[RecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecipeTableViewCellId"];
    }
    
    [cell setRecipeObject:[_dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchedText = [searchBar text];
    
    [[RequestManager manager] searchForRecipe:searchedText block:^(BOOL succeed, NSArray* results){
        if (succeed) {
            _dataSource = results;
            // this tell the table view that the data source has changed, so it needs to reload its content
            [_tableView reloadData];
        } else {
            // TODO: this should be shown in the UI
            NSLog(@"Error during recipe search. Maybe check your connectivity or your API key");
        }
        [self enableSearchBar:YES];
    }];
    
    [self enableSearchBar:NO];
}

@end

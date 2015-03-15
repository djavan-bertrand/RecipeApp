//
//  RequestManager.m
//  RecipeApp
//
//  Created by Djavan Bertrand on 15/03/2015.
//
//

#import "RequestManager.h"
#import "RecipeObject.h"
#import "Helper.h"


#define BASE_URL                    @"http://api.bigoven.com/"
#define RECIPES_SEARCH_URL          @"recipes"
#define RECIPE_DETAIL_URL           @"recipe/"

#define RECIPES_SEARCH_KEYWORD      @"&title_kw="
#define PAGE_KEYWORD                @"&pg="
#define RESULT_PER_PAGE_KEYWORD     @"&rpp="

#define API_KEY_KEYWORD             @"?api_key="

#define SEARCH_RESULTS_KEY          @"Results"
#define SEARCH_RECIPE_ID_KEY        @"RecipeID"
#define SEARCH_RECIPE_TITLE_KEY     @"Title"
#define SEARCH_RECIPE_THUMB_KEY     @"ImageURL120"
#define SEARCH_RECIPE_IMAGE_KEY     @"ImageURL"

#define DETAIL_RECIPE_INSTRUCTION   @"Instructions"

@interface RequestManager()

@property (nonatomic, assign) BOOL isRequestingSearch;

@end

@implementation RequestManager

static RequestManager* sharedInstance;

+(RequestManager *)manager {
    if (!sharedInstance)
    {
        sharedInstance = [[RequestManager alloc] init];
    }
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self) {
        _isRequestingSearch = NO;
    }
    
    return self;
}

#pragma mark search request
- (void)searchForRecipe:(NSString *)keyword block:(void (^)(BOOL, NSArray *))callbackBlock {
    // this is a way to make background task (other way is performSelectorInBackground, or NSThread)
    // this background task is done by giving a block to execute in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL succeed = NO;
        NSArray *results = nil;
        
        // create url
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%i%@%i", BASE_URL, RECIPES_SEARCH_URL, API_KEY_KEYWORD, [Helper getApiKey], RECIPES_SEARCH_KEYWORD, keyword, PAGE_KEYWORD, 1, RESULT_PER_PAGE_KEYWORD, 6];
        NSLog(@"Url is %@", urlStr);
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLResponse *response;
        NSError *error;
        //send it synchronous since we are in a bg thread
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        // check for an error. If there is a network error, you should handle it here.
        if(!error)
        {
            //log response
            /*NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"Response from server = %@", responseString);*/
            results = [self parseRecipeSearchResponse:responseData];
            if (results) {
                succeed = YES;
            }
        }
        
        // now, execute the block callbackBlock in the main thread
        dispatch_async( dispatch_get_main_queue(), ^{
            callbackBlock(succeed, results);
        });
    });
}

- (NSArray*)parseRecipeSearchResponse:(NSData*)response {
    NSMutableArray *results = nil;
    
    NSError *error;
    NSDictionary* resultAsJSON = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if (!error) {
        NSArray *resultList = [resultAsJSON objectForKey:SEARCH_RESULTS_KEY];
        if (resultList) {
            results = [[NSMutableArray alloc] init];
            // create recipe objects from the dictionary and add it to the results array
            for (int i = 0; i < [resultList count]; i++) {
                NSDictionary *recipeAsDict = [resultList objectAtIndex:i];
                if (recipeAsDict)
                {
                    // get string in the dictionary according to their key
                    NSString *recipeId = [recipeAsDict objectForKey:SEARCH_RECIPE_ID_KEY];
                    NSString *title = [recipeAsDict objectForKey:SEARCH_RECIPE_TITLE_KEY];
                    NSString *thumbUrl = [recipeAsDict objectForKey:SEARCH_RECIPE_THUMB_KEY];
                    NSString *imageUrl = [recipeAsDict objectForKey:SEARCH_RECIPE_IMAGE_KEY];
                    RecipeObject *recipe = [[RecipeObject alloc] initWithId:recipeId title:title thumbnailUrl:thumbUrl imageUrl:imageUrl];
                    [results addObject:recipe];
                }
            }
        }
    }
    
    return results;
}

#pragma mark detail request
- (void)downloadRecipeDetail:(NSString*)recipeId block:(void (^)(BOOL, NSString *))callbackBlock {
    // this is a way to make background task (other way is performSelectorInBackground, or NSThread)
    // this background task is done by giving a block to execute in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL succeed = NO;
        NSString *recipeDetail = nil;
        
        // create url
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@%@", BASE_URL, RECIPE_DETAIL_URL, recipeId, API_KEY_KEYWORD, [Helper getApiKey]];
        NSLog(@"Url is %@", urlStr);
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLResponse *response;
        NSError *error;
        //send it synchronous
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        // check for an error
        if(!error)
        {
            //log response
            /*NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"Response from server = %@", responseString);*/
            recipeDetail = [self parseRecipeDetailResponse:responseData];
            if (recipeDetail) {
                succeed = YES;
            }
        }
        
        // now, execute the block callbackBlock in the main thread
        dispatch_async( dispatch_get_main_queue(), ^{
            callbackBlock(succeed, recipeDetail);
        });
    });
}

- (NSString*)parseRecipeDetailResponse:(NSData*)response {
    NSString *detail = nil;
    
    NSError *error;
    NSDictionary* resultAsJSON = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if (!error) {
        detail = [resultAsJSON objectForKey:DETAIL_RECIPE_INSTRUCTION];
    }
    
    return detail;
}
@end

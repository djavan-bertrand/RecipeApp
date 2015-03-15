//
//  RequestManager.h
//  RecipeApp
//
//  Created by Djavan Bertrand on 15/03/2015.
//
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject

+ (RequestManager*)manager;

- (void)searchForRecipe:(NSString*)keyword block:(void (^)(BOOL succeed, NSArray *recipeObjectArray))callbackBlock;
- (void)downloadRecipeDetail:(NSString*)recipeId block:(void (^)(BOOL, NSString *))callbackBlock;
@end

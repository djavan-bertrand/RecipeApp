//
//  RecipeObject.h
//  RecipeApp
//
//  Created by Djavan Bertrand on 14/03/2015.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RecipeObject; // this is needed to use RecipeObject in the delegate

@protocol RecipeObjectDetailDelegate <NSObject>
@required   // oposite of @optional
- (void)recipeObject:(RecipeObject*)receipeObject didReceiveDetail:(NSString*)detail;
@end

@protocol RecipeObjectImageDelegate <NSObject>
@required   // oposite of @optional
- (void)recipeObject:(RecipeObject*)receipeObject didReceiveImage:(UIImage*)image;
@end

@protocol RecipeObjectThumbnailDelegate <NSObject>
@required   // oposite of @optional
- (void)recipeObject:(RecipeObject*)recipeObject didReceiveThumbnail:(UIImage*)thumbnail;
@end

@interface RecipeObject : NSObject

@property (nonatomic, weak) id<RecipeObjectDetailDelegate> detailDelegate;
@property (nonatomic, weak) id<RecipeObjectImageDelegate> imageDelegate;
@property (nonatomic, weak) id<RecipeObjectThumbnailDelegate> thumbDelegate;

@property (nonatomic, strong) NSString *recipeId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbUrl;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *recipeText;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *image;

- (id)initWithId:(NSString*)recipeId title:(NSString*)title thumbnailUrl:(NSString*)thumbnailUrl imageUrl:(NSString*)imageUrl;

- (void)downloadThumbnail;
- (void)downloadImage;
- (void)downloadRecipeDetail;

@end

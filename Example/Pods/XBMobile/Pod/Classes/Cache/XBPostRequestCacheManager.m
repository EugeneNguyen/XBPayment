//
//  XBPostRequestCacheManager.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/14/14.
//
//

#import "XBPostRequestCacheManager.h"

static XBPostRequestCacheManager *__sharedPostRequestCache = nil;

@implementation XBPostRequestCacheManager
@synthesize url, dataPost, delegate, request;

+ (XBPostRequestCacheManager *)sharedInstance
{
    if (!__sharedPostRequestCache)
    {
        __sharedPostRequestCache = [[XBPostRequestCacheManager alloc] init];
    }
    return __sharedPostRequestCache;
}

- (void)start
{
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    for (NSString *key in [dataPost allKeys])
    {
        [request setPostValue:dataPost[key] forKey:key];
    }
    [request startAsynchronous];
    XBM_storageRequest *cache = [XBM_storageRequest getCache:url postData:dataPost];
    if (cache)
    {
        [delegate requestFinishedWithString:cache.response];
    }
}

+ (XBPostRequestCacheManager *)startRequest:(NSURL *)_url postData:(NSDictionary *)_dataPost delegate:(id<XBPostRequestCacheManager>)_delegate
{
    XBPostRequestCacheManager *cache = [[XBPostRequestCacheManager alloc] init];
    cache.url = _url;
    cache.dataPost = _dataPost;
    cache.delegate = _delegate;
    [cache start];
    return cache;
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)_request
{
    [XBM_storageRequest addCache:url postData:dataPost response:_request.responseString];
    if (delegate && [delegate respondsToSelector:@selector(requestFinished:)])
    {
        [delegate requestFinished:_request];
    }
    if (delegate && [delegate respondsToSelector:@selector(requestFinishedWithString:)])
    {
        [delegate requestFinishedWithString:_request.responseString];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)_request
{
    if (delegate && [delegate respondsToSelector:@selector(requestFailed:)])
    {
        [delegate requestFailed:_request];
    }
}

- (void)dealloc
{
    [request setDelegate:nil];
    [request cancel];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.libreteam._9closets" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"XBMobile" ofType:@"bundle"]];
    NSURL *modelURL = [bundle URLForResource:@"XBMRequestCache" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XBMRequestCache.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

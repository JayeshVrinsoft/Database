//
//  Database.h
//  BookReader
//
//  Created by  on 18/07/12.
//  Copyright ©2012, Coho Software LLC. All rights reserved

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Database : NSObject {

	sqlite3 *databaseObj;

}
+(Database*) shareDatabase;

-(BOOL) createEditableCopyOfDatabaseIfNeeded;
-(NSString *) GetDatabasePath:(NSString *)dbName;

-(NSMutableArray *)SelectAllFromTable:(NSString *)query;
-(int)getCount:(NSString *)query;
-(BOOL)CheckForRecord:(NSString *)query;
- (void)Insert:(NSString *)query;
-(void)Delete:(NSString *)query;
-(void)Update:(NSString *)query;


/* app_delegate.m

 [[Database shareDatabase]createEditableCopyOfDatabaseIfNeeded];

*/
 
/* ViewController.h
 
Database *db;
 
*/

/* ViewController.m
 
db = [Database shareDatabase];

 // Select Query
 
 NSString *strGet = @"SELECT * FROM tblVirtualGuard";
 NSArray *arr = [db SelectAllFromTable:strGet];
 NSLog(@"%@",arr);
 
 // Insert Query
 
 strInsert = [NSString stringWithFormat:@"INSERT INTO tblVirtualGuard (user_id,manager_id,image_name,audio_name,message,digital_signature_name,timestamp) VALUES ('%@','%@','%@','%@','%@','%@','%@')",APP_DELEGATE.strUserID,APP_DELEGATE.strManagerID,[NSString stringWithFormat:@"%@_img_%@",APP_DELEGATE.strUserID,currentTime],[NSString stringWithFormat:@"%@_audio_%@",APP_DELEGATE.strUserID,currentTime],self.txtViewMsg.text,[NSString stringWithFormat:@"%@_sign_%@",APP_DELEGATE.strUserID,currentTime],[NSString stringWithFormat:@"%@ UTC",dateString]];
 NSLog(@"%@",strInsert);
 [db Insert:strInsert];
 
 // Delete Query
 
 NSString *query1 = [NSString stringWithFormat:@"DELETE from tblVirtualGuard"];
 [db Delete:query1];
 
 */

@end

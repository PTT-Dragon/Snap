//
//  FMDBManager.m
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import "FMDBManager.h"
#import <fmdb/FMDB.h>

@interface FMDBManager()

@property(nonatomic, strong) NSString *userDbPath;
@property(nonatomic,strong) FMDatabase *userDb;
@end

@implementation FMDBManager

static FMDBManager *_onetimeClass;

+ (FMDBManager *)sharedInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _onetimeClass = [[FMDBManager alloc]init];
        [_onetimeClass createUserDb];
    });
    return _onetimeClass;
}

- (NSString *)userDbPath {
    if (!_userDbPath) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _userDbPath = [doc stringByAppendingPathComponent:@"user.sqlite"];
    }
    return _userDbPath;
}

- (FMDatabase *)userDb {
    if (!_userDb) {
        _userDb = [FMDatabase databaseWithPath: self.userDbPath];
    }
    return _userDb;
}

- (void)createUserDb {
    if ([self.userDb open]) {
        BOOL result=[self.userDb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_user (account text PRIMARY KEY NOT NULL, password text NOT NULL);"];
        if (result){
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
        [self.userDb close];
    }
}

- (void)deleteUserData {
    if ([self.userDb open]) {
        NSString *sql = @"delete from t_user";
        BOOL res = [self.userDb executeUpdate:sql];
        if (!res) {
            NSLog(@"数据删除失败");
        } else {
            NSLog(@"数据删除成功");
        }
        [self.userDb close];
    }
}

- (void)insertUser: (UserModel *)user {
    if ([self.userDb open]) {
        BOOL res = [self.userDb executeUpdate:@"INSERT INTO t_user (account, password) VALUES (?, ?);", user.account, user.password];
        if (!res) {
            NSLog(@"增加数据失败");
        }else{
            NSLog(@"增加数据成功");
        }
        [self.userDb close];
    }
}

- (void)updateUser: (UserModel *)user {
    if ([self.userDb open]) {
        BOOL res = [self.userDb executeUpdate:@"UPDATE t_user SET password = ? WHERE  account = ?", user.password, user.account];
        if (!res) {
            NSLog(@"数据修改失败");
        }else{
            NSLog(@"数据修改成功");
        }
        [self.userDb close];
    }
}

- (UserModel *) queryUserWith: (NSString *)account {
    if ([self.userDb open]) {
        FMResultSet *resultSet = [self.userDb executeQuery:@"SELECT * FROM t_user"];
        
        while ([resultSet next]) {
            NSString *theAccount = [resultSet stringForColumn: @"account"];
            if ([theAccount isEqualToString:account]) {
                UserModel *user = [[UserModel alloc] init];
                user.account = account;
                user.password = [resultSet stringForColumn: @"password"];
                
                [self.userDb close];
                return user;
            }
        }
        [self.userDb close];
    }
    return nil;
}



@end

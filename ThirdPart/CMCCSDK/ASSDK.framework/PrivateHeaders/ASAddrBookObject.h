//
//  ASAddrBookObject.h
//  CaiYun
//
//  Created by Apple on 26/03/13.
//
//  1、同步读写联系人 2、通讯录权限获取

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

/**
 *  Sets the value of a record property.
 
 *
 *  @param record    The record containing the property in question.
 *  @param property  The property whose value is being set. See properties in “Constants” in ABPerson Reference and “Constants” in ABGroup Reference.
 *  @param value     The new value. Pass NULL will return false
 *  @param error     On failure, information about its cause.
 *
 *  @return  true when successful, false otherwise.
 */
AB_EXTERN bool ASABRecordSetValue(ABRecordRef record, ABPropertyID property, CFTypeRef value, CFErrorRef* error);

/**
 *  Adds a value and its corresponding label to a multivalue property.
 This function performs no type checking. It allows the addition of values whose type does not match the type declared for multiValue.
 *
 *  @param multiValue    The multivalue property to add value and label to.
 *  @param value         The value to add to multiValue. Pass NULL will return false
 *  @param label         The label for value.
 *  @param outIdentifier The address at which to place the identifier of the added value. Pass NULL to ignore the identifier.
 *
 *  @return true when value is added to multiValue successfully, false otherwise.
 */
AB_EXTERN bool ASABMultiValueAddValueAndLabel(ABMutableMultiValueRef multiValue, CFTypeRef value, CFStringRef label, ABMultiValueIdentifier *outIdentifier);

@class ASSyncResult;
@class ASAddrBookObject;

// Delegate定义
@protocol ASAddrBookDelegate <NSObject>

@optional

/*!
 @brief  完成回写本地联系人数据的回调
 */
- (void)allDataControlFinished;

/*
 @fn
 */
/*!
 @brief  回写本地联系人时的进度条
 
 @param curIndex the writen contacts count
 @param total    total count
 */
- (void)ItemForAddrBookAtIndexPath:(NSUInteger)curIndex total:(NSUInteger)total;

/*!
 @brief  读取本地联系人时的进度条
 
 @param progress 进度，0 ~ 1
 */
- (void)readLocalProgress:(float)progress;

@end

@protocol ASAddressBookIODelegate <NSObject>

@optional

- (void)addrBookObject:(ASAddrBookObject *)addrBookObject willWrittenToAddressWithContactInfos:(NSArray *)contactInfos;

- (void)addrBookObject:(ASAddrBookObject *)addrBookObject didWrittenToAddressWithContactInfos:(NSArray *)contactInfos;

@end

@interface ASAddrBookObject : NSObject

@property (nonatomic,weak) id<ASAddrBookDelegate> delegate;

@property (weak, nonatomic) id<ASAddressBookIODelegate> addressBookIODelegate;

@property (assign, nonatomic, getter = isWriting) BOOL writing;

/**
 *  转换联系人的日期属性（生日、纪念日），并日期的小时置为正午 12 点，防止时区的转换导致日期不对
 *
 *  @param dateString 日期的 string 值
 *
 *  @return NSDate
 */
+ (NSDate *)dateObjectFromString:(NSString *)dateString;

/**
 *  Creates a new address book object with data from the Address Book database.
 *
 *  Changes made to the returned address book are reflected in the Address Book database only after saving the address book with ABAddressBookSave.
 
 *  On iOS 6.0 and later, if the caller does not have access to the Address Book database:
 
 *  *For apps linked against iOS 6.0 and later, this function returns NULL.
 
 *  *For apps linked against previous version of iOS, this function returns an empty read-only database.
 
 *  If your app syncs information with the database, it must not sync data when it does not have access to the database.
 *
 *  Important
 
 *  You must ensure that an instance of ABAddressBookRef is used by only one thread.
 *
 *
 *  @return An address book object, NULL, or an empty database.
 */
+ (ABAddressBookRef)newABAddressBook;

/*
 @fn 获取 ABAddressBookRef
 
 @return 该类的 ABAddressBookRef
 */
- (ABAddressBookRef)addressBook;

/*
 @fn 重新创建ABAddressBookRef
 */
- (void)allocNewAddressBookRef;

/*
 @fn 取消读取、回写通讯录
 */
- (void)cancel:(BOOL)isCancel;

/**
 *  获取通讯录的权限（同步接口）
 
 iOS6 以上（包括 iOS6 ），需要获取通讯录权限，才能获取联系人数据
 
 重要：该方法在获取权限过程中将会阻塞当前线程，请尽量不要放在主线程运行
 
 *
 *  @return 是否允许获取。iOS6 以下直接返回 YES，iOS6 及以上，将会调用系统接口获取权限。
 */
- (BOOL)accessToContacts;

/*
 @fn 读取变动联系人数据
 
 调用该方法时，需要提前设置 delegate，用于显示进度，也可设置为nil
 
 @param syncInfoArray @[ASSyncInfo, ...]
 @return vCard
 */
- (NSMutableDictionary *)loadContacts:(NSMutableArray *)syncInfoArray;

/*
 @fn 回写通讯录
 
 @param resultObject 同步返回的json数据
 @param ASSyncResult
 @return [ASSyncInfo, ...]
 */
- (NSMutableArray *)writeAddressBook:(id)resultObject ASSyncResult:(ASSyncResult *)syncResult;

@end
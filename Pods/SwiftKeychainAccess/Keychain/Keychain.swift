//
//  Keychain.swift
//  Keychain
//
//  Created by Rauhul Varma on 3/4/17.
//  Copyright © 2017 rvarma. All rights reserved.
//

import Foundation

///
extension CFString: Hashable {
    public var hashValue: Int {
        return Int(bitPattern: CFHash(self))
    }
}

/// Equality operator for CFStrings. Two CFString objects are equal if they represent identical sequences of characters, regardless of encoding
public func ==(_ lhs: CFString, _ rhs: CFString) -> Bool {
    return CFEqual(lhs, rhs)
}

/// Keychain is a class to make keychain access in Swift easy.
open class Keychain {
    
    /// Predefined Accessibility levels used to secure Keychain items with various security levels.
    public enum Accessibility {
        
        /// Default kSecAttrAccessible all keychain items are stored with unless otherwise specified
        public static let `default` = Keychain.Accessibility.whenUnlocked

        /// Item data can only be accessed once the device has been unlocked after a restart. This is recommended for items that need to be accesible by background applications. Items with this attribute will migrate to a new device when using encrypted backups.
        case afterFirstUnlock
        
        /// Item data can only be accessed once the device has been unlocked after a restart. This is recommended for items that need to be accessible by background applications. Items with this attribute will never migrate to a new device, so after a backup is restored to a new device these items will be missing.
        case afterFirstUnlockThisDeviceOnly
        
        /// Item data can always be accessed regardless of the lock state of the device. This is not recommended for anything except system use. Items with this attribute will migrate to a new device when using encrypted backups.
        case always
        
        /// Item data can always be accessed regardless of the lock state of the device. This option is not recommended for anything except system use. Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing.
        case alwaysThisDeviceOnly
        
        /// Item data can only be accessed while the device is unlocked. This is recommended for items that only need to be accessible while the application is in the foreground and requires a passcode to be set on the device. Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing. This attribute will not be available on devices without a passcode. Disabling the device passcode will cause all previously protected items to be deleted.
        case whenPasscodeSetThisDeviceOnly
        
        /// Item data can only be accessed while the device is unlocked. This is recommended for items that only need be accesible while the application is in the foreground. Items with this attribute will migrate to a new device when using encrypted backups.
        case whenUnlocked
        
        /// Item data can only be accessed while the device is unlocked. This is recommended for items that only need be accesible while the application is in the foreground. Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing.
        case whenUnlockedThisDeviceOnly
        
        fileprivate var rawValue: CFString {
            switch self {
                case .afterFirstUnlock:                 return kSecAttrAccessibleAfterFirstUnlock
                case .afterFirstUnlockThisDeviceOnly:   return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
                case .always:                           return kSecAttrAccessibleAlways
                case .alwaysThisDeviceOnly:             return kSecAttrAccessibleAlwaysThisDeviceOnly
                case .whenPasscodeSetThisDeviceOnly:    return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
                case .whenUnlocked:                     return kSecAttrAccessibleWhenUnlocked
                case .whenUnlockedThisDeviceOnly:       return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            }
        }
        
        fileprivate init?(rawValue: CFString) {
            switch rawValue {
                case kSecAttrAccessibleAfterFirstUnlock:                self = .afterFirstUnlock
                case kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly:  self = .afterFirstUnlockThisDeviceOnly
                case kSecAttrAccessibleAlways:                          self = .always
                case kSecAttrAccessibleAlwaysThisDeviceOnly:            self = .alwaysThisDeviceOnly
                case kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly:   self = .whenPasscodeSetThisDeviceOnly
                case kSecAttrAccessibleWhenUnlocked:                    self = .whenUnlocked
                case kSecAttrAccessibleWhenUnlockedThisDeviceOnly:      self = .whenUnlockedThisDeviceOnly
                default: return nil
            }
        }
    }

    /// Default Keychain instance
    open static let `default` = Keychain(serviceName: Keychain.defaultServiceName)
    
    /// Default iCloud Keychain instance
    open static let iCloud = Keychain(serviceName: Keychain.defaultServiceName, synchronizable: true)
    
    /// Default serviceName for the default `Keychain` instance
    public static let defaultServiceName: String = {
        return Bundle.main.bundleIdentifier ?? "keychain_default_service_name"
    }()
    
    /**
        Synchronizable indicates whether the Keychain in question is synchronized to other devices through iCloud. Any operation made with a Keychain where synchronizable is true will be synced accross all iCloud devices connected to the user's account.
     
        Updating or deleting items in a synchronizable Keychain will affect all copies of the item, not just the one on your local device. Be sure that it makes sense to use the same password on all devices before making a password synchronizable.
    
        - note:
            Items stored or retrieved using a synchronizable Keychain may not also specify a Keychain.Accessibility value that is incompatible with syncing (namely, those whose names end with `ThisDeviceOnly`.)
    
            Items stored or retrieved by a synchronizable Keychain cannot be specified by reference.
    
            Do not use persistent references to synchronizable items. They cannot be moved between devices, and may not resolve if the item is modified on some other device.
     */
    open let synchronizable: Bool
    
    
    /// ServiceName is used for the kSecAttrService property to uniquely identify this keychain accessor. If no service name is specified, Keychain will default to using the bundleIdentifier.
    open let serviceName: String
    
    /// AccessGroup is used for the kSecAttrAccessGroup property to identify which Keychain Access Group this entry belongs to. This allows you to use the Keychain with shared keychain access between different applications.
    open let accessGroup: String?
    
    /**
        Create a new Keychain instance with a custom Service Name and optional custom access group.
     
        - parameters:
            - serviceName: The ServiceName for this instance. Used to uniquely identify all keys stored using this keychain wrapper instance.
            - accessGroup: Optional unique AccessGroup for this instance. Use a matching AccessGroup between applications to allow shared keychain access.
     */
    public init(serviceName: String = Keychain.defaultServiceName, accessGroup: String? = nil, synchronizable: Bool = false) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }
    
    /**
        Checks if keychain data exists for a specified key.
     
        - parameters:
            - forKey: The key whose value should be check
            - withAccessibility: Optional accessibility to use when retrieving the keychain item
     
        - returns: True if a value exists for the key. False otherwise.
     */
    open func hasValue(forKey key: String, withAccessibility accessibility: Keychain.Accessibility? = nil) -> Bool {
        if invalid(accessibility: accessibility) {
            return false
        }
        
        if let _ = retrieve(Data.self, forKey: key, withAccessibility: accessibility) {
            return true
        } else {
            return false
        }
    }
    
    /**
        Find the Accessibility level of a key
     
         - parameters:
            - ofKey: The key whose Accessibility level should be checked
     
         - returns: Returns the Accessibility level of a key if it exists. `nil` otherwise.
     */
    open func accessibility(ofKey key: String) -> Keychain.Accessibility? {
        var query = setupQuery(forKey: key, withAccessibility: nil)
        
        // Limit search results to one
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want SecAttrAccessible returned
        query[kSecReturnAttributes] = kCFBooleanTrue
        
        // Ensure we are querying the correct Keychain, iCloud vs Local
        query[kSecAttrSynchronizable] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        
        // Search
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        switch status {
        case errSecSuccess:
            if let attributes = result as? [AnyHashable: Any],
                let accessibility = attributes[kSecAttrAccessible] as? String {
                return Keychain.Accessibility(rawValue: accessibility as CFString)
            }
            
            return nil
            
        default:
            return nil
        }
    }
    
    /**
        Retrieve an DataConvertible object or persistent data reference for a specified key.
     
        - parameters:
            - type: the return type of the desired DataConvertible object
            - forKey: The key to lookup data for.
            - withAccessibility: Optional accessibility to use when retrieving the keychain item.
            - asReference: Optional flag for returning as a persistent data reference
     
        - returns: The object associated with the key if it exists, nil otherwise.
     */
    open func retrieve<ValueType: DataConvertible>(_ type: ValueType.Type, forKey key: String, withAccessibility accessibility: Keychain.Accessibility? = nil, asReference reference: Bool = false) -> ValueType? {
        if invalid(accessibility: accessibility) {
            return nil
        }

        var query = setupQuery(forKey: key, withAccessibility: accessibility)
        
        // Limit search results to one
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        if reference {
            // Specify we want persistent Data/CFData reference returned
            query[kSecReturnPersistentRef] = kCFBooleanTrue
        } else {
            // Specify we want Data/CFData returned
            query[kSecReturnData] = kCFBooleanTrue
        }
        
        // Search
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                fatalError("Failure to convert object returned as kSecReturnData to Data")
            }
            
            return ValueType(data: data)
        default:
            return nil
        }
    }
    
    /**
        Store a DataConvertible object to the keychain with a specified key. Any data previously saved with this key be overwritten with the new value.
     
        - parameters:
            - value: The DataConvertible object to store
            - forKey: The key to store the object under
            - withAccessibility: Optional accessibility to use when storing the keychain item
     
        - returns: True if the store was successful, false otherwise.
     */
    @discardableResult open func store<ValueType: DataConvertible>(_ value: ValueType, forKey key: String, withAccessibility accessibility: Keychain.Accessibility = Keychain.Accessibility.default) -> Bool {
        if invalid(accessibility: accessibility) {
            return false
        }

        var query = setupQuery(forKey: key, withAccessibility: accessibility)
        query[kSecValueData] = value.data

        switch SecItemAdd(query as CFDictionary, nil) {
        case errSecSuccess:
            return true
        case errSecDuplicateItem:
            return update(value.data, forKey: key, withAccessibility: accessibility)
        default:
            return false
        }
    }
    
    /**
        Removes an object associated with a specified key. If re-using a key but with a different accessibility, first remove the previous key value using removeObjectForKey(:withAccessibility) using the same accessibilty it was saved with.

        - parameters:
            - forKey: The key value to remove data for
            - withAccessibility: Optional accessibility level to use when looking up the keychain item

        - returns: True if successful, false otherwise.
     */
    @discardableResult open func removeObject(forKey key: String, withAccessibility accessibility: Keychain.Accessibility? = nil) -> Bool {
        if invalid(accessibility: accessibility) {
            return false
        }

        let query = setupQuery(forKey: key, withAccessibility: accessibility)
        
        // Delete
        switch SecItemDelete(query as CFDictionary) {
        case errSecSuccess:
            return true
        default:
            return false
        }
    }
    
    /**
        Removes all keychain items matching the current ServiceName and AccessGroup, if set.
     
        - returns: True if successful, false otherwise
     */
    open func purge() -> Bool {
        var query = [AnyHashable: Any]()
        
        // Setup default access as generic password (rather than a certificate, internet password, etc)
        query[kSecClass] = kSecClassGenericPassword
        
        // Uniquely identify this keychain accessor
        query[kSecAttrService] = serviceName
        
        // Set the keychain access group if defined
        query[kSecAttrAccessGroup] = accessGroup
        
        // Ensure we are querying the correct Keychain, iCloud vs Local
        query[kSecAttrSynchronizable] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        
        switch SecItemDelete(query as CFDictionary) {
        case errSecSuccess:
            return true
        default:
            return false
        }
    }
    
    
    /// Get the keys of all keychain entries matching the current ServiceName and AccessGroup if one is set.
    open func allKeys() -> Set<String> {
        var query = [AnyHashable: Any]()
        
        // Setup default access as generic password (rather than a certificate, internet password, etc)
        query[kSecClass] = kSecClassGenericPassword
        
        // Uniquely identify this keychain accessor
        query[kSecAttrService] = serviceName
        
        // Set the keychain access group if defined
        query[kSecAttrAccessGroup] = accessGroup
        
        // Do not limit search results
        query[kSecMatchLimit] = kSecMatchLimitAll
        
        // Specify we want SecAttrAccessible returned
        query[kSecReturnAttributes] = kCFBooleanTrue
        
        // Ensure we are querying the correct Keychain, iCloud vs Local
        query[kSecAttrSynchronizable] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse

        // Search
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        switch status {
        case errSecSuccess:
            var keys = Set<String>()
            if let results = result as? [[AnyHashable: Any]] {
                for attributes in results {
                    if let account = attributes[kSecAttrAccount as String] as? String {
                        keys.insert(account)
                    }
                }
            }
            return keys

        default:
            return []
        }
    }

    
    
    // MARK: - Private
    
    private func invalid(accessibility: Keychain.Accessibility?) -> Bool {
        if synchronizable &&
            (accessibility == .afterFirstUnlockThisDeviceOnly ||
            accessibility == .alwaysThisDeviceOnly ||
            accessibility == .whenPasscodeSetThisDeviceOnly ||
            accessibility == .whenUnlockedThisDeviceOnly) {
            return true
        }
        return false
    }
    
    /**
        Update existing data associated with a specified key name. The existing data will be overwritten by the new data.
     
        - parameters:
            - _ The new data to store
            - forKey: The key to store the object under
            - withAccessibility: Optional accessibility to use when setting the keychain item
     
        - returns: A dictionary with all the needed properties setup to access the keychain on iOS
     */
    private func update(_ value: Data, forKey key: String, withAccessibility accessibility: Keychain.Accessibility) -> Bool {
        let query  = setupQuery(forKey: key, withAccessibility: accessibility)
        let update = [kSecValueData: value]
        
        switch SecItemUpdate(query as CFDictionary, update as CFDictionary) {
        case errSecSuccess:
            return true
        default:
            return false
        }
    }
    
    /**
        Create a keychain query dictionary used to access the keychain on iOS for a specified key name. Takes into account the Service Name and Access Group if one is set.
     
        - parameters:
            - forKey: The key this query is for
            - withAccessibility: Optional accessibility to use when setting the keychain item.
     
        - returns: A dictionary with all the needed properties setup to access the keychain on iOS
     */
    private func setupQuery(forKey key: String, withAccessibility accessibility: Keychain.Accessibility?) -> [AnyHashable: Any] {
        var query = [AnyHashable: Any]()
        
        // Setup default access as generic password (rather than a certificate, internet password, etc)
        query[kSecClass] = kSecClassGenericPassword
        
        // Uniquely identify this keychain accessor
        query[kSecAttrService] = serviceName
        
        // Only set accessibilty if its passed in
        query[kSecAttrAccessible] = accessibility?.rawValue
        
        // Ensure we are querying the correct Keychain, iCloud vs Local
        query[kSecAttrSynchronizable] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        
        // Set the keychain access group if defined
        query[kSecAttrAccessGroup] = accessGroup
        
        // Uniquely identify the account who will be accessing the keychain
        query[kSecAttrAccount] = key
        
        return query
    }
}

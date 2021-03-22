//
//  Cache.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-08.
//

import Foundation

// MARK: - Cache API
// Using a wrapper for Key, We can use struct or any data type taht's hashable, instead of just String
final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    // Current date
    private let dateProvider: () -> Date
    // Lifetime with a default value of 24hrs
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 24 * 60 * 60,
         maximumEntryCount: Int = 20) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        wrapped.countLimit = maximumEntryCount
        wrapped.delegate = keyTracker
    }
}

// MARK: - Utiltity methods
extension Cache {
    // Inserting a value for a given key
    func insert(_ value: Value, forKey key: Key) {
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        wrapped.setObject(entry, forKey: WrappedKey(key))
        keyTracker.keys.insert(key)
    }
    
    // Retrieving values for a given key
    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        guard dateProvider() < entry.expirationDate else {
            // Discard value that have expired
            removeValue(forKey: key)
            return nil
        }
        return entry.value
    }
    
    // Removing and existing Value
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

// MARK: - Utility methods
extension Cache {
    // get entry for a given key
    func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        return entry
    }
    // insert an entry
    func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
}

// MARK: - WrappedKey class
extension Cache {
    // Wraps public facing Key to make them NSCache compatible
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            
            return value.key == key
        }
    }
}

// MARK: - Entry class
extension Cache {
    // Stores a value instance
    final class Entry {
        let key: Key
        let value: Value
        let expirationDate: Date
        
        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

// MARK: - Subscripting
extension Cache {
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            guard let value = newValue else {
                // If nil was assigned using subscript, remove any value for taht key
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

// MARK: - NSCacheDelegate
// keeps track of all the keys
// Gets notified whenever an entry is removed from cache
private extension Cache {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
            guard let entry = object as? Entry else {
                return
            }
            keys.remove(entry.key)
        }
    }
}

// MARK: - Entry class Codable
extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

// MARK: - Codable
// Confirms cache to Codable, can encode and decode all entries.
extension Cache: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
    
    func saveToDisk(with fileName: String) {
        let encoder = JSONEncoder()
        let cacheDirectory = self.getDirectoryURL(fileName)
        do {
            let data = try encoder.encode(self)
            try data.write(to: cacheDirectory)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func retrieveFromDisk(_ path: String, forKey key: Key) -> Value? {
        let decoder = JSONDecoder()
        let cacheDirectory = getDirectoryURL(path)
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: cacheDirectory.path))
            let cached = try decoder.decode(Cache.self, from: data)
            return cached.value(forKey: key)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    func getDirectoryURL(_ fileName: String) -> URL {
        let folderURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = folderURLs[0].appendingPathComponent(fileName)
        return cacheDirectory
    }
    
}

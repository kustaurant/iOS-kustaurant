//
//  Logger.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/20/24.
//

import Foundation
import OSLog

enum LogCategory: String {
    case network
    case ui
    case none
}

final class Logger {

    private static let subsystem = Bundle.main.bundleIdentifier ?? "kustaurant.Kustaurant"

    static func osLog(for category: LogCategory) -> OSLog {
        return OSLog(subsystem: subsystem, category: category.rawValue)
    }

    static func debug(_ message: String, category: LogCategory = .none) {
        os_log("%{public}@", log: Logger.osLog(for: category), type: .debug, message)
    }

    static func info(_ message: String, category: LogCategory = .none) {
        os_log("%{public}@", log: Logger.osLog(for: category), type: .info, message)
    }

    static func error(_ message: String, category: LogCategory = .none) {
        os_log("%{public}@", log: Logger.osLog(for: category), type: .error, message)
    }

    func fault(_ message: String, category: LogCategory = .none) {
        os_log("%{public}@", log: Logger.osLog(for: category), type: .fault, message)
    }
}

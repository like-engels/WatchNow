//
//  Extensions.swift
//  WatchNow
//
//  Created by User-D on 7/21/22.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

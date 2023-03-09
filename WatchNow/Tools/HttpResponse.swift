//
//  HttpResponse.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 8/3/23.
//

import Foundation

class HttpResponse {
    let isOK: Bool
    let body: Any?
    let message: String?
    
    init(isOK: Bool, body: Any?, message: String?) {
        self.isOK = isOK
        self.body = body
        self.message = message
    }
}

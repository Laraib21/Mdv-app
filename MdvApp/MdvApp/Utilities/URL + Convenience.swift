//
//  URL + Convenience.swift
//  MdvApp
//
//  Created by School on 2020-10-02.
//

import Foundation

extension URL {
    static var documentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
}

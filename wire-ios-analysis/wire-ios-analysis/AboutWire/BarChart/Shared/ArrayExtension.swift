//
//  ArrayExtension.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 12/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}

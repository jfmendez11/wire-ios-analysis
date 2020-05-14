//
//  Expandable.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 13/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation
import UIKit

protocol Expandable {
    func collapse()
    func expand(in collectionView: UICollectionView)
}

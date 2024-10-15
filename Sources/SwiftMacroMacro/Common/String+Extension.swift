//
//  String+Extension.swift
//  iBankMacroMacro
//
//  Created by Chu Thin on 23/7/24.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

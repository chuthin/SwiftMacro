//
//  Cloneable.swift
//  iBankMacroMacro
//
//  Created by Chu Thin on 24/7/24.
//

import Foundation

public protocol Cloneable {
    var clone: Self { get }
}

public extension Cloneable {
    var clone: Self {
        return self
    }

    func clone<Part>(_ keyPath: WritableKeyPath<Self, Part>, value: Part) -> Self {
        var result = self.clone
        result[keyPath: keyPath] = value
        return result
    }

    func then<Part>(_ keyPath: WritableKeyPath<Self, Part>, value: Part) -> Self {
        var result = self
        result[keyPath: keyPath] = value
        return result
    }

    func clone<Part>(_ keyPath: WritableKeyPath<Self, Part>) -> (Part) -> Self {
        return { value in
            var result = self.clone
            result[keyPath: keyPath] = value
            return result
        }
    }

    func then<Part>(_ keyPath: WritableKeyPath<Self, Part>) -> (Part) -> Self {
        return { value in
            var result = self
            result[keyPath: keyPath] = value
            return result
        }
    }
}


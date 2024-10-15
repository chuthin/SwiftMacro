//
//  InjectionHotReloadMacro.swift
//  iBankMacroMacro
//
//  Created by Chu Thin on 23/7/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct InjectionHotReload: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Create the new property declaration
        let countProperty: DeclSyntax = """
        #if DEBUG
            @ObservedObject var iO = injectionObserver
        #endif
        """
        return [countProperty]
    }
}

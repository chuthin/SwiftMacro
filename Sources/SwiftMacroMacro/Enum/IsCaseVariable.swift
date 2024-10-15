//
//  IsCaseVariable.swift
//  iBankMacroMacro
//
//  Created by Chu Thin on 23/7/24.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
public struct IsCaseVariable: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
                                 Context: MacroExpansionContext>(of node: AttributeSyntax,
                                                                 providingMembersOf declaration: Declaration,
                                                                 in context: Context) throws -> [DeclSyntax] {
        guard let members = declaration.as(EnumDeclSyntax.self)?
            .memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self)?.elements }) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to an Enum type")
        }
        return try members.flatMap { list-> [DeclSyntax] in
            try list.compactMap { element -> DeclSyntax? in

                let varSyntax = try VariableDeclSyntax("\(declaration.modifiers )var is\(raw: element.name.description.capitalizingFirstLetter()): Bool") {
                    try IfExprSyntax(
                        "if case .\(element.name) = self",
                        bodyBuilder: {
                            StmtSyntax("return true")
                        })
                    StmtSyntax(#"return false"#)
                }
                return DeclSyntax(varSyntax)
            }
        }
    }
}

//
//  EnumPrismMacro.swift
//
//
//  Created by Chu Thin on 17/12/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
public struct EnumPrismMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
                                 Context: MacroExpansionContext>(of node: AttributeSyntax,
                                                                 providingMembersOf declaration: Declaration,
                                                                 in context: Context) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
                    throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to an Enum type")
                }

        guard let members = declaration.as(EnumDeclSyntax.self)?
            .memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self)?.elements }) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to an Enum type")
        }


        let enumName = enumDecl.name.trimmed
        return try members.flatMap { list-> [DeclSyntax] in
            try list.compactMap { element -> DeclSyntax? in
                return """
                        \(declaration.modifiers)static var \(raw: element.name.description)Prism: Prism<\(enumName),\(raw: element.trimmedTypeDescription)>{
                        return Prism<\(enumName),\(raw: element.trimmedTypeDescription)>(
                         embed: {\(enumName).\(raw: element.name.description)($0)},
                         extract: { if case let .\(raw: element.name.description)(command) = $0 { return command } else { return nil } }
                    )
                }
                """
            }
        }
    }
}

public struct EnumPrismWithMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax,
                                 Context: MacroExpansionContext>(of node: AttributeSyntax,
                                                                 providingMembersOf declaration: Declaration,
                                                                 in context: Context) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
                    throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to an Enum type")
                }

        guard let members = declaration.as(EnumDeclSyntax.self)?
            .memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self)?.elements }) else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to an Enum type")
        }


        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self), let param = arguments.first?.expression.as(StringLiteralExprSyntax.self)?.trimmed
        else {
            throw MacroDiagnostics.errorMacroUsage(message: "Can only be applied to an Enum type")
        }
        let paramValue: String = param.description.replacingOccurrences(of: "\"", with: "")

        let enumName = enumDecl.name.trimmed
        return try members.flatMap { list-> [DeclSyntax] in
            try list.compactMap { element -> DeclSyntax? in
                return """
                        \(declaration.modifiers)static var \(raw: element.name.description)Prism: Prism<\(enumName),\(raw: element.trimmedTypeDescription)>{
                        return Prism<\(enumName),\(raw: element.trimmedTypeDescription)>(
                         embed: {\(enumName).\(raw: element.name.description)(\(raw: paramValue.isEmpty ? "" : "\(paramValue): ")$0)},
                         extract: { if case let .\(raw: element.name.description)(command) = $0 { return command } else { return nil } }
                    )
                }
                """
            }
        }
    }
}


extension EnumCaseElementListSyntax.Element {
  var trimmedTypeDescription: String {
    if var associatedValue = self.parameterClause, !associatedValue.parameters.isEmpty {
      if associatedValue.parameters.count == 1,
        let type = associatedValue.parameters.first?.type.trimmed
      {
        return type.is(SomeOrAnyTypeSyntax.self)
          ? "(\(type))"
          : "\(type)"
      } else {
        for index in associatedValue.parameters.indices {
          associatedValue.parameters[index].type.trailingTrivia = ""
          associatedValue.parameters[index].defaultValue = nil
          if associatedValue.parameters[index].firstName?.tokenKind == .wildcard {
            associatedValue.parameters[index].colon = nil
            associatedValue.parameters[index].firstName = nil
            associatedValue.parameters[index].secondName = nil
          }
        }
        return "(\(associatedValue.parameters.trimmed))"
      }
    } else {
      return "Void"
    }
  }
}

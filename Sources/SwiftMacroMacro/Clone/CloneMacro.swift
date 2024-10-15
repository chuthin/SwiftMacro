//
//  CloneMacro.swift
//  iBankMacroMacro
//
//  Created by Chu Thin on 24/7/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct CloneMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
                    throw CodingKeysError.invalidDeclarationSyntax
                }

        let members = structDecl.memberBlock.members
        let variableDecl = members.filter{
            $0.decl.as(VariableDeclSyntax.self)?.bindings.first?.initializer?.value != nil
        }.filter {
            guard let variableDecl = $0.decl.as(VariableDeclSyntax.self) else { return false }
            return variableDecl.attributes.first {
                $0.as(AttributeSyntax.self)?
                    .attributeName
                    .as(IdentifierTypeSyntax.self)?
                    .description == "CloneIgnore"
            } != nil

        }.compactMap { $0.decl.as(VariableDeclSyntax.self)?.bindings }
                let variables = variableDecl.compactMap({$0.first})

        let parameters = variables
                    .map { variable in
                        "result.\(variable.pattern) = \(variable.initializer!.value.description)"
                    }
                    .joined(separator: "\n")
        var cloneType = "var"
        if parameters.isEmpty {
            cloneType = "let"
        }

        let cloneProperty =  try ExtensionDeclSyntax ( """
         extension \(type.trimmed): Cloneable {
                     public var clone : \(type.trimmed) {
                          \(raw: cloneType) result = self
                          \(raw: parameters)
                          return result
                      }
        }
        """)
        return [cloneProperty]
    }

    private static func attributesElement(
            withIdentifier macroName: String,
            in attributes: AttributeListSyntax?
        ) -> AttributeListSyntax.Element? {
            attributes?.first {
                $0.as(AttributeSyntax.self)?
                    .attributeName
                    .as(IdentifierTypeSyntax.self)?
                    .description == macroName
            }
        }
}


private enum CodingKeysError: Error {
     case invalidDeclarationSyntax
     case keyPathNotFound
 }

public struct CloneIgnoreMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}

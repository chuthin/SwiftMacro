//
//  Plugin.swift
//  iBankMacroMacro
//
//  Created by Chu Thin on 23/7/24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct iBankMacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    InjectionHotReload.self,
    IsCaseVariable.self,
    CloneMacro.self,
    CloneIgnoreMacro.self,
    EnumPrismMacro.self,
    EnumPrismWithMacro.self
  ]
}

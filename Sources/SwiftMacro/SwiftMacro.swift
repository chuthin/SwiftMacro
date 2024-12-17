// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces a peer struct which implements the builder pattern

@attached(member, names: arbitrary)
public macro InjectionHotReload() = #externalMacro(
    module: "SwiftMacroMacro", type: "InjectionHotReload"
)

public enum AccessLevelConfig {
  case `private`
  case `fileprivate`
  case `internal`
  case `package`
  case `public`
  case `open`
}

// MARK: @Init macro

public enum IgnoreConfig {
  case ignore
}

// MARK: - Deprecated

// Deprecated; remove in 1.0
public enum EscapingConfig { case escaping }

@attached(member, names: arbitrary)
public macro IsCaseVariable() = #externalMacro(module: "SwiftMacroMacro", type: "IsCaseVariable")


@attached(extension, names: arbitrary, conformances: Cloneable)
public macro Clone() = #externalMacro(module: "SwiftMacroMacro", type: "CloneMacro")

@attached(peer)
public macro CloneIgnore() = #externalMacro(module: "SwiftMacroMacro", type: "CloneIgnoreMacro")


@attached(member, names: arbitrary)
public macro EnumPrism() = #externalMacro(module: "SwiftMacroMacro", type: "EnumPrismMacro")

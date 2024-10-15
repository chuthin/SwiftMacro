//
//  HotSwiftUI.swift
//  HotSwiftUI
//
//  Created by John Holdsworth on 03/01/2021.
//  Copyright © 2017 John Holdsworth. All rights reserved.
//
//  $Id: //depot/HotSwiftUI/Sources/HotSwiftUI/HotSwiftUI.swift#19 $
//

import SwiftUI

import Combine
#if DEBUG
public let injectionObserver = InjectionObserver()

public class InjectionObserver: ObservableObject {
    @Published var injectionNumber = 0
    var cancellable: AnyCancellable?
    let publisher = PassthroughSubject<Void, Never>()
    init() {
        cancellable = NotificationCenter.default.publisher(for:
                                                            Notification.Name("INJECTION_BUNDLE_NOTIFICATION"))
        .sink { [weak self] _ in
            self?.injectionNumber += 1
            self?.publisher.send()
        }
    }
}
#endif

extension SwiftUI.View {
    public func eraseToAnyView() -> some SwiftUI.View {
#if DEBUG
        return AnyView(self)
        #else
        return self
        #endif
    }
}

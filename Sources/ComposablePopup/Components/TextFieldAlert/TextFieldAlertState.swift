import ComposableArchitecture
import SwiftUI

public struct TextFieldAlertState<Action>: Identifiable {
    public typealias CommitAction = AnyCasePath<Action, String>

    public let id: UUID
    public var buttons: [ButtonState<CommitAction>]
    public var message: TextState?
    public var title: TextState
    public var placeholder: TextState?
    public var defaultText: TextState?

    init(
        id: UUID,
        buttons: [ButtonState<CommitAction>],
        message: TextState?,
        title: TextState,
        placeholder: TextState?,
        defaultText: TextState?
    ) {
        self.id = id
        self.buttons = buttons
        self.message = message
        self.title = title
        self.placeholder = placeholder
        self.defaultText = defaultText
    }

    public init(
        title: () -> TextState,
        @ButtonStateBuilder<CommitAction> actions: () -> [ButtonState<CommitAction>] = { [] },
        message: (() -> TextState)? = nil,
        placeholder: (() -> TextState)? = nil,
        defaultText: (() -> TextState)? = nil
    ) {
        self.init(
            id: UUID(),
            buttons: actions(),
            message: message?(),
            title: title(),
            placeholder: placeholder?(),
            defaultText: defaultText?()
        )
    }

    public func map<NewAction>(
        _ transform: (CommitAction?) -> AnyCasePath<NewAction, String>?
    ) -> TextFieldAlertState<NewAction> {
        TextFieldAlertState<NewAction>(
            id: id,
            buttons: buttons.map { $0.map(transform) },
            message: message,
            title: title,
            placeholder: placeholder,
            defaultText: defaultText
        )
    }
}

extension TextFieldAlertState: CustomDumpReflectable {
    public var customDumpMirror: Mirror {
        var children: [(label: String?, value: Any)] = [
            ("title", title),
        ]
        if !buttons.isEmpty {
            children.append(("actions", buttons))
        }
        if let message {
            children.append(("message", message))
        }
        if let placeholder {
            children.append(("placeholder", placeholder))
        }
        if let defaultText {
            children.append(("defaultText", defaultText))
        }
        return Mirror(
            self,
            children: children,
            displayStyle: .struct
        )
    }
}

extension AnyCasePath: Equatable where Root: Equatable, Value == String {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs ~= rhs.embed("")
    }
}

extension AnyCasePath: Hashable where Root: Hashable, Value == String {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(embed(""))
    }
}

extension TextFieldAlertState: Equatable where Action: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
            && lhs.message == rhs.message
            && lhs.buttons == rhs.buttons
            && lhs.placeholder == rhs.placeholder
            && lhs.defaultText == rhs.defaultText
    }
}

extension TextFieldAlertState: Hashable where Action: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(message)
        hasher.combine(buttons)
        hasher.combine(placeholder)
        hasher.combine(defaultText)
    }
}

extension TextFieldAlert.Button.Role {
    init(_ role: ButtonStateRole) {
        switch role {
        case .cancel:
            self = .cancel
        case .destructive:
            self = .destructive
        }
    }
}

extension TextFieldAlert.Button {
    init<Action>(
        _ button: ButtonState<AnyCasePath<Action, String>>,
        action handler: @escaping (AnyCasePath<Action, String>?) -> Void
    ) {
        self.init(
            label: String(state: button.label),
            action: { _ in
                button.withAction(handler)
            },
            role: button.role.map(TextFieldAlert.Button.Role.init) ?? .default
        )
    }
}

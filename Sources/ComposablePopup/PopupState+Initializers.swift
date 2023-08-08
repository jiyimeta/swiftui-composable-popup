import Foundation
import ComposableArchitecture

public extension PopupState {
    static func alert(
        title: () -> TextState,
        @ButtonStateBuilder<Action> actions: () -> [ButtonState<Action>] = { [] },
        message: (() -> TextState)? = nil
    ) -> PopupState {
        .alert(
            AlertState(
                title: title,
                actions: actions,
                message: message
            )
        )
    }
    
    static func confirmationDialog(
        titleVisibility: ConfirmationDialogStateTitleVisibility = .automatic,
        title: () -> TextState,
        @ButtonStateBuilder<Action> actions: () -> [ButtonState<Action>] = { [] },
        message: (() -> TextState)? = nil
    ) -> PopupState {
        .confirmationDialog(
            ConfirmationDialogState(
                titleVisibility: titleVisibility,
                title: title,
                actions: actions,
                message: message
            )
        )
    }
    
    static func textFieldAlert(
        title: () -> TextState,
        @ButtonStateBuilder<CasePath<Action, String>> actions: () -> [ButtonState<CasePath<Action, String>>] = { [] },
        message: (() -> TextState)? = nil,
        placeholder: (() -> TextState)? = nil,
        defaultText: (() -> TextState)? = nil
    ) -> PopupState {
        .textFieldAlert(
            TextFieldAlertState(
                title: title,
                actions: actions,
                message: message,
                placeholder: placeholder,
                defaultText: defaultText
            )
        )
    }
}

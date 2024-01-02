import ComposableArchitecture
import Foundation

extension PopupState {
    public static func alert(
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

    public static func confirmationDialog(
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

    public static func textFieldAlert(
        title: () -> TextState,
        @ButtonStateBuilder<AnyCasePath<Action, String>>
        actions: () -> [ButtonState<AnyCasePath<Action, String>>] = { [] },
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

import ComposableArchitecture
import SwiftUI

public enum PopupState<Action> {
    case alert(AlertState<Action>)
    case confirmationDialog(ConfirmationDialogState<Action>)
    case textFieldAlert(TextFieldAlertState<Action>)
}

extension PopupState: Identifiable {
    public var id: UUID {
        switch self {
        case let .alert(alert):
            return alert.id

        case let.confirmationDialog(confirmationDialog):
            return confirmationDialog.id
            
        case let .textFieldAlert(textFieldAlert):
            return textFieldAlert.id
        }
    }
}

extension PopupState: _EphemeralState {
    public static var actionType: Any.Type { Action.self }
}
extension PopupState: Equatable where Action: Equatable {}

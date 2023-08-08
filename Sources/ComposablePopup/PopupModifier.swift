@_spi(Presentation) @_spi(Internals) import ComposableArchitecture
import SwiftUI

extension View {
    public func popup<ButtonAction>(
        store: Store<PresentationState<PopupState<ButtonAction>>, PresentationAction<ButtonAction>>
    ) -> some View {
        self.popup(store: store, state: { $0 }, action: { $0 })
    }
    
    public func popup<State, Action, ButtonAction>(
        store: Store<PresentationState<State>, PresentationAction<Action>>,
        state toDestinationState: @escaping (_ state: State) -> PopupState<ButtonAction>?,
        action fromDestinationAction: @escaping (_ popupAction: ButtonAction) -> Action
    ) -> some View {
        self
            .alert(
                store: store,
                state: { state in
                    if case let .alert(alertState) = toDestinationState(state) {
                        return alertState
                    }
                    
                    return nil
                },
                action: fromDestinationAction
            )
            .confirmationDialog(
                store: store,
                state: { state in
                    if case let .confirmationDialog(confirmationDialog) = toDestinationState(state) {
                        return confirmationDialog
                    }
                    
                    return nil
                },
                action: fromDestinationAction
            )
            .textFieldAlert(
                store: store,
                state: { state in
                    if case let .textFieldAlert(textFieldAlert) = toDestinationState(state) {
                        return textFieldAlert
                    }
                    
                    return nil
                },
                action: fromDestinationAction
            )
    }
}


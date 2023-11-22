@_spi(Presentation) @_spi(Internals) import ComposableArchitecture
import SwiftUI

extension View {
    public func textFieldAlert<ButtonAction>(
        store: Store<PresentationState<TextFieldAlertState<ButtonAction>>, PresentationAction<ButtonAction>>
    ) -> some View {
        self.textFieldAlert(store: store, state: { $0 }, action: { $0 })
    }
    
    public func textFieldAlert<State, Action, ButtonAction>(
        store: Store<PresentationState<State>, PresentationAction<Action>>,
        state toDestinationState: @escaping (_ state: State) -> TextFieldAlertState<ButtonAction>?,
        action fromDestinationAction: @escaping (_ alertAction: ButtonAction) -> Action
    ) -> some View {
        self.presentation(
            store: store,
            state: toDestinationState,
            action: fromDestinationAction
        ) { `self`, $isPresented, destination in
            let textFieldAlertState = store.stateSubject.value.wrappedValue.flatMap(toDestinationState)
            
            self.textFieldAlert(
                (textFieldAlertState?.title).map { String(state: $0) } ?? "",
                isPresented: $isPresented,
                presenting: textFieldAlertState,
                buttons: { textFieldAlertState in
                    textFieldAlertState.buttons.map { button in
                        TextFieldAlert.Button(
                            label: String(state: button.label),
                            action: { text in
                                switch button.action.type {
                                case let .send(commitAction):
                                    if let commitAction {
                                        store.send(.presented(fromDestinationAction(commitAction.embed(text))))
                                    }
                                case let .animatedSend(commitAction, animation):
                                    if let commitAction {
                                        store.send(.presented(fromDestinationAction(commitAction.embed(text))), animation: animation)
                                    }
                                }
                            },
                            role: button.role.map(TextFieldAlert.Button.Role.init) ?? .default
                        )
                    }
                },
                message: {
                    $0.message.map { String(state: $0) } ?? ""
                },
                placeholder: {
                    $0.placeholder.map { String(state: $0) } ?? ""
                },
                defaultText: {
                    $0.defaultText.map { String(state: $0) } ?? ""
                }
            )
        }
    }
}

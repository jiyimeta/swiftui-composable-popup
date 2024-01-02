//
//  ContentView.swift
//  PopupExample
//
//  Created by 伊藤紀一 on 2023/08/04.
//

import ComposableArchitecture
import ComposablePopup
import SwiftUI

struct Content: Reducer {
    struct State: Equatable {
        @PresentationState var popup: PopupState<Action.Popup>?

        var count = 0
        var name = "name"
    }

    enum Action: Equatable {
        case popup(PresentationAction<Popup>)
        case showAlertButtonTapped
        case showConfirmationDialogButtonTapped
        case showTextFieldAlertButtonTapped

        enum Popup: Equatable {
            case incrementButtonTapped
            case decrementButtonTapped
            case renameButtonTapped(String)
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .popup(.presented(.incrementButtonTapped)):
                state.popup = .alert { TextState("Incremented!") }
                state.count += 1
                return .none

            case .popup(.presented(.decrementButtonTapped)):
                state.popup = .alert { TextState("Decremented!") }
                state.count -= 1
                return .none

            case let .popup(.presented(.renameButtonTapped(name))):
                state.name = name
                return .none

            case .popup:
                return .none

            case .showAlertButtonTapped:
                state.popup = .alert {
                    TextState("Alert!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .incrementButtonTapped) {
                        TextState("Increment")
                    }
                } message: {
                    TextState("This is an alert")
                }

                return .none

            case .showConfirmationDialogButtonTapped:
                state.popup = .confirmationDialog {
                    TextState("ConfirmationDialog!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .incrementButtonTapped) {
                        TextState("Increment")
                    }
                    ButtonState(action: .decrementButtonTapped) {
                        TextState("Decrement")
                    }
                } message: {
                    TextState("This is a confirmation dialog")
                }

                return .none

            case .showTextFieldAlertButtonTapped:
                let name = state.name

                state.popup = .textFieldAlert {
                    TextState("TextFieldAlert")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: /Action.Popup.renameButtonTapped) {
                        TextState("Rename")
                    }
                } message: {
                    TextState("This is a text field alert")
                } placeholder: {
                    TextState("This is a placeholder")
                } defaultText: {
                    TextState(name)
                }

                return .none
            }
        }
        .ifLet(\.$popup, action: /Action.popup)
    }
}

struct ContentView: View {
    let store: StoreOf<Content>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Button {
                    viewStore.send(.showAlertButtonTapped)
                } label: {
                    Text("Show Alert")
                }
                .padding(.bottom)

                Button {
                    viewStore.send(.showConfirmationDialogButtonTapped)
                } label: {
                    Text("Show Confirmation Dialog")
                }
                .padding(.bottom)

                Button {
                    viewStore.send(.showTextFieldAlertButtonTapped)
                } label: {
                    Text("Show Text Field Alert")
                }
                .padding(.bottom)

                Text("Count: \(viewStore.count)")
                Text("Name: \(viewStore.name)")
            }
            .popup(store: store.scope(state: \.$popup, action: { .popup($0) }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(initialState: Content.State()) {
                Content()
            }
        )
    }
}

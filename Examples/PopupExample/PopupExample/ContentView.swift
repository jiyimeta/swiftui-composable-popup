//
//  ContentView.swift
//  PopupExample
//
//  Created by 伊藤紀一 on 2023/08/04.
//

import SwiftUI
import ComposablePopup
import ComposableArchitecture

struct Content: Reducer {
    struct State: Equatable {
        @PresentationState var popup: PopupState<Action.Popup>?
        
        var count = 0
    }
    
    enum Action: Equatable {
        case popup(PresentationAction<Popup>)
        case showAlertButtonTapped
        case showConfirmationDialogButtonTapped
        
        enum Popup {
            case incrementButtonTapped
            case decrementButtonTapped
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
                
                Text("Count: \(viewStore.count)")
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

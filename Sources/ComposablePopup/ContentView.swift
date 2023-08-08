#if DEBUG
import SwiftUI
import ComposableArchitecture

struct ContentReducer: Reducer {
    struct State: Equatable {
        @PresentationState var popup: PopupState<Action.Popup>?
        
        var count = 0
        var text = "default"
    }
    
    enum Action: Equatable {
        case popup(PresentationAction<Popup>)
        case showAlertButtonTapped
        case showConfirmationDialogButtonTapped
        case showTextFieldAlertButtonTapped
        
        enum Popup: Equatable {
            case incrementButtonTapped
            case decrementButtonTapped
            case okButtonTapped(String)
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
                
            case let .popup(.presented(.okButtonTapped(text))):
                state.popup = .alert { TextState("Text changed: \(text)") }
                state.text = text
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
                state.popup = .textFieldAlert {
                    TextState("TextFieldAlert!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: /Action.Popup.okButtonTapped) {
                        TextState("OK")
                    }
                } message: {
                    TextState("This is a text field alert")
                } placeholder: {
                    TextState("Enter a text")
                } defaultText: { [text = state.text] in
                    TextState(text)
                }
                
                return .none
            }
        }
        .ifLet(\.$popup, action: /Action.popup)
    }
}

struct ContentView: View {
    let store: StoreOf<ContentReducer>
    
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
                .padding(.bottom, 100)
                
                Text("Count: \(viewStore.count)")
                    .padding(.bottom)
                
                Text("Text: \(viewStore.text)")
            }
            .popup(store: store.scope(state: \.$popup, action: { .popup($0) }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(initialState: ContentReducer.State()) {
                ContentReducer()
            }
        )
    }
}
#endif

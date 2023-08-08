import SwiftUI

private class TextFieldAlertViewController: UIViewController {
    var alert: UIAlertController
    
    weak var textFieldDelegate: UITextFieldDelegate?
    
    init(alert: UIAlertController) {
        self.alert = alert
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentAlert(animated: Bool, completion: (() -> Void)? = nil) {
        self.present(alert, animated: animated, completion: completion)
    }
}

public struct TextFieldAlert: UIViewControllerRepresentable {
    @State var text: String
    @Binding var isPresented: Bool
    var title: String
    var message: String?
    var placeholder: String?
    var buttons: [TextFieldAlert.Button]
    
    let id = UUID().uuidString
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
            textField.returnKeyType = .done
            textField.delegate = context.coordinator
        }
        
        buttons.forEach { button in
            let action = UIAlertAction(title: button.label, style: .init(button.role)) { _ in
                alert.dismiss(animated: true) {
                    button.action?(text)
                    isPresented = false
                }
            }
            alert.addAction(action)
        }
        
        let viewController = TextFieldAlertViewController(alert: alert)
        
        DispatchQueue.main.async {
            viewController.presentAlert(animated: true)
        }
        
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    public func makeCoordinator() -> TextFieldAlert.Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldAlert
        
        init(_ parent: TextFieldAlert) {
            self.parent = parent
        }
        
        public func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            if let text = textField.text as NSString? {
                parent.text = text.replacingCharacters(in: range, with: string)
            } else {
                parent.text = ""
            }
        
            return true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            textField.resignFirstResponder()
        }
    }
}

extension TextFieldAlert {
    public struct Button {
        var label: String
        var action: ((String) -> Void)?
        var role: Role
        
        enum Role {
            case `default`
            case cancel
            case destructive
        }
    }
}

extension UIAlertAction.Style {
    init(_ role: TextFieldAlert.Button.Role) {
        switch role {
        case .default:
            self = .`default`
        case .cancel:
            self = .cancel
        case .destructive:
            self = .destructive
        }
    }
}

extension View {
    public func textFieldAlert(
        _ title: String,
        isPresented: Binding<Bool>,
        buttons: [TextFieldAlert.Button],
        message: String,
        placeholder: String,
        defaultText: String
    ) -> some View {
        self
            .background {
                TextFieldAlert(
                    text: defaultText,
                    isPresented: isPresented,
                    title: title,
                    message: message,
                    placeholder: placeholder,
                    buttons: buttons
                )
            }
    }
    
    public func textFieldAlert<T>(
        _ title: String,
        isPresented: Binding<Bool>,
        presenting data: T?,
        buttons: @escaping (T) -> [TextFieldAlert.Button],
        message: @escaping (T) -> String,
        placeholder: @escaping (T) -> String,
        defaultText: @escaping (T) -> String
    ) -> some View {
        self.background {
            if let data {
                TextFieldAlert(
                    text: defaultText(data),
                    isPresented: isPresented,
                    title: title,
                    message: message(data),
                    placeholder: placeholder(data),
                    buttons: buttons(data)
                )
            }
        }
    }
}

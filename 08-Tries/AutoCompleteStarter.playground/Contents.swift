//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {

    let resultStack = UIStackView()
    let textField = UITextField()
    var trie = Trie<String>()

    // MARK: - Textfield
    var textfieldFrame = CGRect(x: 150, y: 200, width: 400, height: 40)
    var textFieldText = ""

    override func loadView() {

        sampleData.forEach { trie.insert($0) }
        let view = UIView()
        view.backgroundColor = .white

        textField.borderStyle = .roundedRect
        textField.frame = textfieldFrame
        textField.addTarget(self, action: #selector(didChangeValue(_:)), for: .allEditingEvents)

        view.addSubview(textField)
        self.view = view
    }

    @objc func didChangeValue(_ textField: UITextField) {
        guard let text = textField.text else { return }

        trie.collections(startingWith: text)
    }
}


// Present the view controller in the Live View window
let window = UIWindow(frame: CGRect(x: 0,
                                    y: 0,
                                    width: 768,
                                    height: 1024))
let viewController = MyViewController()
window.rootViewController = viewController
window.makeKeyAndVisible()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = window


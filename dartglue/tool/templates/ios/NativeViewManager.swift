import UIKit

class NativeViewManager {
    private var viewCache = [Int64: UIView]()
    private var handleCounter: Int64 = 1
    let rootView = UIView()

    func createView(_ type: Int32) -> Int64 {
        let view: UIView = {
            switch type {
            case 0: return UIView()
            case 1: return UILabel()
            default: return UIView()
            }
        }()
        
        let handle = handleCounter
        handleCounter += 1
        viewCache[handle] = view
        return handle
    }
    
    func updateViewProps(_ handle: Int64, _ propsJson: String) {
        guard let view = viewCache[handle],
              let data = propsJson.data(using: .utf8),
              let props = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        
        // Update common properties
        if let width = props["width"] as? CGFloat {
            view.frame.size.width = width
        }
        
        if let height = props["height"] as? CGFloat {
            view.frame.size.height = height
        }
        
        // Handle text properties
        if let label = view as? UILabel {
            if let text = props["text"] as? String {
                label.text = text
            }
            if let fontSize = props["fontSize"] as? CGFloat {
                label.font = .systemFont(ofSize: fontSize)
            }
        }
    }
}
import UIKit

class NativeViewManager {
    private var viewCache = [Int64: UIView]()
    private var handleCounter: Int64 = 1

    func createView(_ type: Int) -> Int64 {
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

    func setViewProps(_ handle: Int64, _ props: String) {
        guard let view = viewCache[handle] else { return }
        // Apply properties based on props string
    }
}

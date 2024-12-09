import 'dart:io';

class IosProjectTemplate {
  Future<void> createXcodeProject(Directory iosDir) async {
    await iosDir.create(recursive: true);
    
    final xcodeProjectDir = Directory('${iosDir.path}/Runner.xcodeproj');
    await xcodeProjectDir.create(recursive: true);
    
    final projectContent = '''
// !\$*UTF8*\$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 46;
	objects = {
/* Begin XCConfigurationList section */
		97C146E91CF9000F007C117D /* Build configuration list for PBXProject "Runner" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				97C147031CF9000F007C117D /* Debug */,
				97C147041CF9000F007C117D /* Release */,
				249021D3217E4FDB00AE95B9 /* Profile */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = 8A7B9CB424D6B1A7003C7993 /* Project object */;
}
''';

    await File('${xcodeProjectDir.path}/project.pbxproj').writeAsString(projectContent);
  }

  Future<void> createSwiftFiles(Directory projectIosDir) async {
    final classesDir = Directory('${projectIosDir.path}/Classes');
    await classesDir.create(recursive: true);
    
    await _createAppDelegate(classesDir);
    await _createViewController(classesDir);
    await _createUIColorExtension(classesDir);
    await _createBridgeFiles(classesDir);
    await _updateViewControllerWithBridge(classesDir);
  }

  Future<void> _createAppDelegate(Directory classesDir) async {
    await File('${classesDir.path}/AppDelegate.swift').writeAsString('''
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
''');
  }

  Future<void> _createViewController(Directory classesDir) async {
    await File('${classesDir.path}/ViewController.swift').writeAsString('''
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Welcome to Direct Native"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
''');
  }

  Future<void> _createUIColorExtension(Directory classesDir) async {
    await File('${classesDir.path}/UIColor+Extension.swift').writeAsString('''
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
''');
  }



  Future<void> _createBridgeFiles(Directory classesDir) async {
  final bridgeDir = Directory('${classesDir.path}/Bridge');
  await bridgeDir.create();
  
  // Create DNBridge.swift
  await File('${bridgeDir.path}/DNBridge.swift').writeAsString('''
import UIKit

@_cdecl("DNCreateView")
public func DNCreateView(_ viewId: UnsafePointer<CChar>, _ propsJson: UnsafePointer<CChar>) {
    let viewIdString = String(cString: viewId)
    let propsJsonString = String(cString: propsJson)
    
    DispatchQueue.main.async {
        DNBridge.shared.createView(viewId: viewIdString, propsJson: propsJsonString)
    }
}

class DNBridge {
    static let shared = DNBridge()
    private var viewRegistry: [String: UIView] = [:]
    private weak var rootViewController: ViewController?
    
    func initialize(rootViewController: ViewController) {
        self.rootViewController = rootViewController
    }
    
    func createView(viewId: String, propsJson: String) {
        guard let data = propsJson.data(using: .utf8),
              let props = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let rootViewController = rootViewController else {
            return
        }
        
        let view = UIView()
        configureView(view, with: props)
        viewRegistry[viewId] = view
        
        rootViewController.view.addSubview(view)
    }
    
    private func configureView(_ view: UIView, with props: [String: Any]) {
        if let style = props["style"] as? [String: Any] {
            if let backgroundColor = style["backgroundColor"] as? String {
                view.backgroundColor = UIColor(hexString: backgroundColor)
            }
            if let width = style["width"] as? CGFloat {
                view.frame.size.width = width
            }
            if let height = style["height"] as? CGFloat {
                view.frame.size.height = height
            }
        }
    }
}
''');
}

Future<void> _updateViewControllerWithBridge(Directory classesDir) async {
  await File('${classesDir.path}/ViewController.swift').writeAsString('''
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Initialize bridge
        DNBridge.shared.initialize(rootViewController: self)
        
        let label = UILabel()
        label.text = "Welcome to Direct Native"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
''');
}
}

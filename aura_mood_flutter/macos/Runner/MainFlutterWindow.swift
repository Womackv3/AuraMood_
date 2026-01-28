import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    // Set initial size to Samsung Flip 7 approximation (1080x2640 @ ~2.7 density -> ~400x978)
    // Using 400x850 to be safe on most screens while testing layout
    self.setFrame(NSRect(x: windowFrame.origin.x, y: windowFrame.origin.y, width: 400, height: 850), display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}

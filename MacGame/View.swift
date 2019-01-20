import AppKit
import SpriteKit

class View:NSWindow {
    private weak var view:SKView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
        outlets()
    }
    
    private func outlets() {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.ignoresSiblingOrder = true
        view.presentScene(SceneView())
        contentView!.addSubview(view)
        self.view = view
        
        view.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant:800).isActive = true
        view.heightAnchor.constraint(equalToConstant:600).isActive = true
    }
}

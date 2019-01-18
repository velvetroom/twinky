import SpriteKit

class SceneView:SKScene {
    var left:(() -> Void)!
    var right:(() -> Void)!
    var up:(() -> Void)!
    private var time = TimeInterval()
    private var key = Int()
    
    override func didMove(to view:SKView) {
        super.didMove(to:view)
        backgroundColor = .blue
        scaleMode = .resizeFill
    }
    
    override func update(_ time:TimeInterval) {
        super.update(time)
        if time - self.time > 0.1 {
            switch key {
            case 123: left()
            case 124: right()
            case 126: up()
            default: break
            }
            key = 0
            self.time = time
        }
    }
    
    override func keyDown(with event:NSEvent) {
        key = Int(event.keyCode)
    }
}

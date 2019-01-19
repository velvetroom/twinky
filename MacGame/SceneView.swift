import SpriteKit

class SceneView:SKScene {
    var left:(() -> Void)!
    var right:(() -> Void)!
    var up:(() -> Void)!
    var space:(() -> Void)!
    private var time = TimeInterval()
    private var key = Int()
    private var arrowLeft = false
    private var arrowRight = false
    private var arrowUp = false
    
    override func didMove(to view:SKView) {
        super.didMove(to:view)
        backgroundColor = .blue
        scaleMode = .resizeFill
    }
    
    override func update(_ time:TimeInterval) {
        super.update(time)
        if time - self.time > 0.05 {
            if arrowLeft { left() }
            if arrowRight { right() }
            if arrowUp { up() }
            self.time = time
        }
    }
    
    override func keyDown(with event:NSEvent) { key(event.keyCode, modifier:true) }
    override func keyUp(with event:NSEvent) { key(event.keyCode, modifier:false) }
    
    private func key(_ code:uint16, modifier:Bool) {
        switch code {
        case 123: arrowLeft = modifier
        case 124: arrowRight = modifier
        case 126: arrowUp = modifier
        case 49: if modifier { space() }
        default: break
        }
    }
}

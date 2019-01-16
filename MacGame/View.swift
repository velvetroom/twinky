import AppKit

class View:NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
        outlets()
    }
    
    private func outlets() {
        
    }
}

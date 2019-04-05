# Game Audio Player (Swift 4.2)

**How to use (easier way):** <br />
• Add the `GameAudioPlayer.swift` file to your project <br/>
• Create a `GameAudioPlayer` instance <br />
• Play your sounds with the `playSoundFileNamed` method <br />
• That's it! <br />

**How to use (better performance way):** <br />
• Add the `GameAudioPlayer.swift` file to your project
• Create a `GameAudioPlayer` instance <br />
• Load your sounds with the `prepareSound` or `prepareSounds` method <br />
• Set the maximum number of times a certain sound can play at the same time with the `setMaxConrurrentPlayback` method <br />
• Disable cached sounds with the `disableCachedSounds` method for even better performance (optional) <br />
• Play your sounds with the `playPreparedSound` method <br />
• That's it! <br />

# Example (easier way)
```swift
class TestGameScene : SKScene {
    
    // Declaring the GameAudioPlayer Instance:
    var audioPlayer : GameAudioPlayer?
    
    override init() {
        super.init()
        
        // Initializing GameAudioPlayer's Instance:
        audioPlayer = GameAudioPlayer(scene: self)
        
        // Playing a sound:
        audioPlayer?.playSoundFileNamed("explosion1", duration: 2, doesLoop: false)
        
    }
    
}
```

# Example (better performance way)
```swift
class TestGameScene : SKScene {
    
    // Declaring the GameAudioPlayer Instance:
    var audioPlayer : GameAudioPlayer?
    
    override init() {
        super.init()
        
        // Initializing GameAudioPlayer's Instance:
        audioPlayer = GameAudioPlayer(scene: self)
        
        // Preparing the sounds:
        let soundNames = ["explosion1", "backgroundMusic3", "powerUpSound"]
        audioPlayer?.prepareSounds(soundFileNames: soundNames)
        
        // Playing a sound:
        audioPlayer?.playPreparedSound("explosion1", duration: 2, doesLoop: false)
        
    }
    
}
```
# License
Game Audio Player project is licensed under MIT License ([MIT-License](MIT-License) or https://opensource.org/licenses/MIT)

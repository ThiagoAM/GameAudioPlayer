# Game Audio Player (Swift 4.1)

**How to use (easier way):** <br />
• Create a `GameAudioPlayer` instance <br />
• Play your sounds with the `playSoundFileNamed` method <br />
• That's it! <br />

**How to use (better performance way):** <br />
• Create a `GameAudioPlayer` instance <br />
• Load your sounds with the `prepareSound` or `prepareSounds` method <br />
• Play your sounds with the `playPreparedSound` method <br />
• Set the maximum number of times a certain sound can play at the same time with the `setMaxConrurrentPlayback` method <br />
• Disable cached sounds with the `disableCachedSounds` method for even better performance (optional) <br />
• That's it! <br />

# Example (easier way)
```
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
```
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

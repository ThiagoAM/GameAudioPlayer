# Game Audio Player (Swift 4.1)
**How to use :** <br />
• Create a GameAudioPlayer instance <br />
• Load your sounds with the `prepareSound` or `prepareSounds` method <br />
• Play your sounds with the `playPreparedSound` method <br />
• That's it! <br />

# Example (inside a SKScene)
```
// Creating the instance:
let audioPlayer = GameAudioPlayer(scene: self)
        
// Preparing the sounds:
let soundNames = ["explosion1", "backgroundMusic3", "powerUpSound"]        
audioPlayer.prepareSounds(soundFileNames: soundNames)
        
// Playing a sound:
audioPlayer.playPreparedSound("explosion1", duration: 2, doesLoop: false)
```

# Performance Advices
• For improved performance, disable the creation of temporary SKAudioNode instances by calling the `disableTemporarySounds` method. Finally, set the maxium number of instances a certain sound can have by calling the `setMaxConrurrentPlayback` method. <br />
• You can use the `playSoundFileNamed` method without preparing sounds before, but the performance will not be optional since it will be constantly creating new SKAudioNode instances each time you call it.

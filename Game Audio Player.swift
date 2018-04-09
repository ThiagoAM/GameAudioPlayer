//
//  Game Audio Player.swift
//  Created by Thiago Martins on 07/04/2018.
//

import SpriteKit

class GameAudioPlayer {
    
    // MARK: Properties
    private weak var scene : SKScene?
    private var audioNodes : [GameAudioNode] = [GameAudioNode]()
    private var temporaryAudioNodesEnabled : Bool = true
    private var holderNode : SKNode = SKNode()
    
    // MARK: Initialization
    init(scene : SKScene) {
        self.scene = scene
        setupHolderNode()
    }
    
    // MARK: Public Methods
    
    /**
     Improves performance by disabling the creation of temporary SKAudioNodes. Use the `setMaxConrurrentPlayback` method to setup the number of times certain sounds will be able to play at the same time.
     */
    public func disableTemporarySounds() {
        self.temporaryAudioNodesEnabled = false
    }
    
    /**
     Enables the creation of temporary SKAudioNodes. This option may negatively impact performance if the `playPreparedSound` method is called too many times in a short period of time. Use the `setMaxConrurrentPlayback` method for sounds that will play many times, and disable temporary sounds.
     */
    public func enableTemporarySounds() {
        self.temporaryAudioNodesEnabled = true
    }
    
    /**
     Plays a sound already preapred by the `prepareSound` method. If the sound was not prepared, dot it beforehand, or use the `playSoundFileNamed` method of this class.
     */
    public func playPreparedSound(_ soundName : String, duration : TimeInterval = 1, doesLoop : Bool) {
        if let preparedAudioNodes = getAudioNodesFromArray(audioName: soundName) {
            var didPlayPausedSounds : Bool = false
            for audioNode in preparedAudioNodes {
                if !audioNode.isPlaying {
                    if audioNode.isPaused {
                        playAnAudioNode(audioNode, duration: duration, doesLoop: doesLoop)
                        didPlayPausedSounds = true
                    } else {
                        playAnAudioNode(audioNode, duration: duration, doesLoop: doesLoop)
                        return
                    }
                }
            }
            if !didPlayPausedSounds && temporaryAudioNodesEnabled {
                playTemporaryAudioNode(named: soundName, duration: duration, doesLoop: doesLoop)
            }
        }
    }
    
    /**
     Plays a sound using a temporary SKAudioNode. This method may negatively impact performance if called many times in a short period of time. Use the `prepareSound` method to load resources, and `playPreparedSound` to play the loaded sound for performance improvements.
     */
    public func playSoundFileNamed(_ soundFile : String, duration : TimeInterval, doesLoop : Bool) {
        playTemporaryAudioNode(named: soundFile, duration: duration, doesLoop: doesLoop)
    }
    
    /**
     Prepares a sound to be played later by the `playPreparedSound' method.
    */
    public func prepareSound(soundFileName : String) {
        let newAudioNode = GameAudioNode(fileNamed: soundFileName)
        newAudioNode.autoplayLooped = false
        newAudioNode.id = soundFileName
        audioNodes.append(newAudioNode)
        holderNode.addChild(newAudioNode)
    }
    
    /**
     Prepares multiple sounds to be played later by the `playPreparedSound' method.
     */
    public func prepareSounds(soundFileNames : [String]) {
        for name in soundFileNames {
            prepareSound(soundFileName: name)
        }
    }
    
    /**
     Sets the maximum number of times a certain prepared sound can be played in a short period of time.
    */
    public func setMaxConrurrentPlayback(_ forPreparedSoundNamed : String, value : Int) {
        removePreparedSound(forPreparedSoundNamed)
        if value > 0 {
            for _ in 1...value {
                prepareSound(soundFileName: forPreparedSoundNamed)
            }
        } else {
            prepareSound(soundFileName: forPreparedSoundNamed)
        }
    }
    
    /**
     Checks if a certain prepared sound is currently playing.
    */
    public func soundIsPlaying(_ soundName : String) -> Bool {
        var isPlaying : Bool = false
        if let tempAudioNodes = getAudioNodesFromArray(audioName: soundName) {
            for audioNode in tempAudioNodes {
                if audioNode.id == soundName {
                    if audioNode.isPlaying {
                        isPlaying = true
                    } else {
                        return false
                    }
                }
            }
        }
        return isPlaying
    }
    
    /**
     Pauses a prepared sound.
    */
    public func pausePreparedSound(_ soundName : String) {
        if let preparedAudioNodes = getAudioNodesFromArray(audioName: soundName) {
            for audioNode in preparedAudioNodes {
                audioNode.isPlaying = false
                audioNode.run(.pause())
                audioNode.isPaused = true
            }
        }
    }
    
    /**
     Removes a prepared sound.
    */
    public func removePreparedSound(_ soundName : String) {
        for child in holderNode.children {
            if let audioNode = child as? GameAudioNode {
                if audioNode.id == soundName {
                    audioNode.removeFromParent()
                }
            }
        }
        var counter : Int = 0
        for audioNode in self.audioNodes {
            if audioNode.id == soundName {
                self.audioNodes.remove(at: counter)
            }
            counter += 1
        }
    }
    
    /**
     Removes every prepared sound.
    */
    public func removeEveryPreparedSound() {
        holderNode.removeAllChildren()
        audioNodes.removeAll()
    }
    
    // MARK: Private Methods
    private func playTemporaryAudioNode(named : String, duration : TimeInterval, doesLoop : Bool) {
        let audioNode = SKAudioNode(fileNamed: named)
        audioNode.autoplayLooped = doesLoop
        let wait = SKAction.wait(forDuration: duration)
        holderNode.addChild(audioNode)
        audioNode.run(SKAction.sequence([.play(), wait]), completion: {
            audioNode.removeFromParent()
        })
                                                                
    }
    
    private func setupHolderNode() {
        self.scene?.addChild(holderNode)
        holderNode.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }
    
    private func audioNodeIsHoldersChild(_ audioNode : GameAudioNode) -> Bool {
        for child in holderNode.children {
            if let audioNodeChild = child as? GameAudioNode {
                if audioNodeChild == audioNode {
                    return true
                }
            }
        }
        return false
    }
    
    private func playAnAudioNode(_ audioNode : GameAudioNode, duration : TimeInterval, doesLoop : Bool) {
        audioNode.autoplayLooped = doesLoop
        audioNode.isPaused = false
        audioNode.isPlaying = true
        if !doesLoop {
            let wait = SKAction.wait(forDuration: duration)
            let sequence = SKAction.sequence([.play(), wait])
            audioNode.run(sequence, completion: {
                audioNode.isPlaying = false
                audioNode.run(.stop())
            })
        } else {
            audioNode.run(.play())
        }
    }
    
    private func getAudioNodesFromArray(audioName : String) -> [GameAudioNode]? {
        var tempAudioNodes = [GameAudioNode]()
        for audioNode in self.audioNodes {
            if audioNode.id == audioName {
                tempAudioNodes.append(audioNode)
            }
        }
        if !tempAudioNodes.isEmpty {
            return tempAudioNodes
        } else {
            return nil
        }
    }
    
    // MARK: GameAudioNode Class
    class GameAudioNode : SKAudioNode {
        var id : String = ""
        var maxSimultaneousPlayback : Int = 1
        var isPlaying : Bool = false
    }
    
}


//
//  SoundManager.swift
//  CaipirinIA
//
//  Created by Clément Deust on 31/08/2024.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?

    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}

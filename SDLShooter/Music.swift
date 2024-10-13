//
//  Music.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/13.
//

import SDL_mixer

var music: Mix_Music?

func loadMusic(filename: String) {
    // 如果已经加载了音乐, 则停止并释放旧的音乐资源
    if music != nil {
        Mix_HaltMusic()
        Mix_FreeMusic(music)
        music = nil
    }

    // 加载新音乐
    music = Mix_LoadMUS(filename)

    if music == nil {
        print("Failed to load music: \(String(cString: SDL_GetError()))")
    }
}

func playMusic(loop: Bool) {
    guard let music = music else {
        print("Music is not loaded")
        return
    }

    // 播放音乐, loop 为 true 时循环播放
    if Mix_PlayMusic(music, loop ? -1 : 0) == -1 {
        print("Failed to play music: \(String(cString: SDL_GetError()))")
    }
}

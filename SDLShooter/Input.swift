//
//  Input.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2

func doInput() -> Void {
    var event = SDL_Event()
    
    while SDL_PollEvent(&event) != 0 {
        
        switch event.type {
        case SDL_QUIT.rawValue:
            exit(0)
            break
        default:
            break
        }
    }
}

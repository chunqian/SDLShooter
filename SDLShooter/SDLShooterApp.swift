//
//  SDLShooterApp.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2

var app = App()

@main
struct SDLShooterApp {
    static func main() {
        initSDL()
        
        atexit(cleanup)
        
        while true {
            prepareScene()
            
            doInput()
            
            presentScene()
            
            SDL_Delay(16)
        }
    }
}

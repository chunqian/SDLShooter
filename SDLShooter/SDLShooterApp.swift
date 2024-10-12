//
//  SDLShooterApp.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2
import SDL_ttf

var app = App()

@main
struct SDLShooterApp {
    static func main() {
        initSDL()
        
        atexit(cleanup)
        
        let helloWorld = getTextTexture(text: "Hello World!",
                                        font: app.font!,
                                        renderer: app.renderer!,
                                        color: SDL_Color(r: 255, g: 255, b: 255, a: 255))
        
        while true {
            prepareScene()
            
            doInput()
            
            blit(texture: helloWorld!, x: 50, y: 50, center: false)
            
            presentScene()
            
            SDL_Delay(16)
        }
    }
}

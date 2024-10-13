//
//  SDLShooterApp.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2
import SDL_ttf

var app = App()
var player = Entity()

@main
struct SDLShooterApp {
    static func main() {
        initSDL()
        
        initMusic()
        
        player.x = 100
        player.y = 100
        player.texture = loadTexture(filename: playerPath!)
        
        atexit(cleanup)
        
        let helloWorld = getTextTexture(text: "Hello, World! 你好，世界！",
                                        font: app.font!,
                                        renderer: app.renderer!,
                                        color: SDL_Color(r: 255, g: 255, b: 255, a: 255))
        
        while true {
            prepareScene()
            
            doInput()
            
            blit(texture: helloWorld!, x: 50, y: 50, center: false)
            
            blit(texture: player.texture!, x: player.x!, y: player.y!, center: false)
            
            presentScene()
            
            SDL_Delay(16)
        }
    }
}

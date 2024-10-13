//
//  Structs.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2

struct App {
    var renderer: SDL_Renderer?
    var window: SDL_Window?
    var font: TTF_Font?
}

struct Entity {
    var x: Int?
    var y: Int?
    var texture: SDL_Texture?
}

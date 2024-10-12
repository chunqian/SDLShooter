//
//  Text.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/12.
//

import SDL2
import SDL_ttf

func getTextTexture(text: String, font: TTF_Font, renderer: SDL_Renderer, color: SDL_Color) -> SDL_Texture? {
    // 创建 SDL_Surface
    guard let surface = TTF_RenderUTF8_Blended(font, text, color) else {
        print("Failed to create text surface: \(String(cString: SDL_GetError()))")
        return nil
    }

    // 转换 SDL_Surface 为 SDL_Texture
    let texture = SDL_CreateTextureFromSurface(renderer, surface)
    
    // 检查转换是否成功
    if texture == nil {
        print("Failed to create texture from surface: \(String(cString: SDL_GetError()))")
    }

    // 释放 SDL_Surface 内存
    SDL_FreeSurface(surface)

    return texture
}

//
//  Draw.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2

func prepareScene() -> Void {
    SDL_SetRenderDrawColor(app.renderer, 32, 32, 32, 255)
    SDL_RenderClear(app.renderer)
}

func presentScene() -> Void {
    SDL_RenderPresent(app.renderer)
}

func blit(texture: SDL_Texture, x: Int, y: Int, center: Bool) {
    var dest = SDL_Rect()
    
    // 设置坐标
    dest.x = Int32(x)
    dest.y = Int32(y)
    
    // 获取纹理的宽高
    SDL_QueryTexture(texture, nil, nil, &dest.w, &dest.h)
    
    // 如果居中
    if center {
        dest.x -= dest.w / 2
        dest.y -= dest.h / 2
    }
    
    // 执行渲染
    SDL_RenderCopy(app.renderer, texture, nil, &dest)
}

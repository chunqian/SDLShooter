//
//  Draw.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2
import SDL_image

func prepareScene() -> Void {
    SDL_SetRenderDrawColor(app.renderer, 32, 32, 32, 255)
    SDL_RenderClear(app.renderer)
}

func presentScene() -> Void {
    SDL_RenderPresent(app.renderer)
}

func loadTexture(filename: String) -> SDL_Texture? {
    // 打印加载日志
    // SDL_LogMessage(SDL_LOG_CATEGORY_APPLICATION, SDL_LOG_PRIORITY_INFO, "Loading \(filename)")
    
    // 加载纹理
    let texture = IMG_LoadTexture(app.renderer, filename)
    
    if texture == nil {
        print("无法加载纹理文件 \(filename): \(String(cString: SDL_GetError()))")
    }
    
    return texture
}

func blit(texture: SDL_Texture, x: Int, y: Int, center: Bool) {
    var dest = SDL_Rect()
    
    // 设置坐标
    dest.x = Int32(x)
    dest.y = Int32(y)
    
    // 获取纹理的宽高
    SDL_QueryTexture(texture, nil, nil, &dest.w, &dest.h)
    
    // 获取渲染器的逻辑大小和实际输出大小
    var logicalWidth: Int32 = 0
    var logicalHeight: Int32 = 0
    SDL_GetWindowSize(app.window, &logicalWidth, &logicalHeight)
    
    var outputWidth: Int32 = 0
    var outputHeight: Int32 = 0
    SDL_GetRendererOutputSize(app.renderer, &outputWidth, &outputHeight)
    
    // 计算缩放因子
    let scaleX = Float(outputWidth) / Float(logicalWidth)
    let scaleY = Float(outputHeight) / Float(logicalHeight)
    
    // 根据缩放因子调整纹理的绘制坐标和大小
    dest.x = Int32(Float(dest.x) * scaleX)
    dest.y = Int32(Float(dest.y) * scaleY)
    dest.w = Int32(Float(dest.w) * scaleX)
    dest.h = Int32(Float(dest.h) * scaleY)
    
    // 如果居中
    if center {
        dest.x -= dest.w / 2
        dest.y -= dest.h / 2
    }
    
    // 执行渲染
    SDL_RenderCopy(app.renderer, texture, nil, &dest)
}

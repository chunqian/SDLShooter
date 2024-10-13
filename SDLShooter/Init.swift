//
//  Init.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2
import SDL_ttf

func initSDL() -> Void {
    let rendererFlags = 0
    // let windowFlags: SDL_WindowFlags = SDL_WindowFlags(rawValue: SDL_RENDERER_ACCELERATED.rawValue | SDL_WINDOW_ALLOW_HIGHDPI.rawValue)
    let windowFlags: SDL_WindowFlags = SDL_WindowFlags(rawValue: SDL_RENDERER_ACCELERATED.rawValue)
    
    if SDL_Init(SDL_INIT_VIDEO) < 0 {
        print("Couldn't initialize SDL: \(String(cString: SDL_GetError()))")
        exit(1)
    }
    
    app.window = SDL_CreateWindow("Shooter 01",
                                  Int32(SDL_WINDOWPOS_UNDEFINED_MASK),
                                  Int32(SDL_WINDOWPOS_UNDEFINED_MASK),
                                  Int32(SCREEN_WIDTH),
                                  Int32(SCREEN_HEIGHT),
                                  windowFlags.rawValue)
    
    if (app.window == nil) {
        print("Failed to open \(SCREEN_WIDTH) x \(SCREEN_HEIGHT) window: \(String(cString: SDL_GetError()))")
        exit(1)
    }
    
    if (TTF_Init() < 0) {
        print("Couldn't initialize SDL TTF: \(String(cString: SDL_GetError()))")
        exit(1)
    }
    
    // 调用 TTF_OpenFont
    app.font = TTF_OpenFont(fontPath, Int32(FONT_SIZE))

    if app.font == nil {
        print("Failed to load font: \(String(cString: SDL_GetError()))")
        exit(1)
    }
    
    // 将窗口置于前台
    SDL_RaiseWindow(app.window)
    
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "linear")
    
    app.renderer = SDL_CreateRenderer(app.window, -1, Uint32(rendererFlags))
    
    if (app.renderer == nil) {
        print("Failed to create renderer: \(String(cString: SDL_GetError()))")
        exit(1)
    }
}

func cleanup() -> Void {
    SDL_DestroyRenderer(app.renderer)
    
    SDL_DestroyWindow(app.window)
    
    TTF_CloseFont(app.font)
    
    TTF_Quit()
    
    SDL_Quit()
}

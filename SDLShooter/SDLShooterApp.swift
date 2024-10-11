//
//  SDLShooterApp.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import Cocoa
import SDL2

@main
struct SDLShooterApp {
    static func main() {
        SDLMain.run() // 调用静态方法启动SDL窗口
    }
}

class SDLMain {
    static func run() {
        initializeSDL()
    }

    static func initializeSDL() {
        // 初始化SDL视频系统
        guard SDL_Init(SDL_INIT_VIDEO) == 0 else {
            fatalError("SDL could not initialize! SDL_Error: \(String(cString: SDL_GetError()))")
        }

        // 创建一个SDL窗口
        let sdlWindow = SDL_CreateWindow(
            "SDL2 in SwiftUI",
            Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK),
            800, 600,
            UInt32(SDL_WINDOW_SHOWN.rawValue) | UInt32(SDL_WINDOW_INPUT_FOCUS.rawValue)
        )

        // 如果创建失败，打印错误信息
        if sdlWindow == nil {
            fatalError("SDL window could not be created! SDL_Error: \(String(cString: SDL_GetError()))")
        }
        
        // 将窗口置于前台
        SDL_RaiseWindow(sdlWindow)

        // SDL事件处理
        var quit = false
        var event = SDL_Event()

        while !quit {
            while SDL_PollEvent(&event) != 0 {
                if event.type == SDL_QUIT.rawValue {
                    quit = true
                }
            }

            SDL_Delay(16) // 60帧/秒
        }

        // 销毁SDL窗口并退出
        SDL_DestroyWindow(sdlWindow)
        SDL_Quit()
    }
}

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

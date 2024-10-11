//
//  SDL2.swift
//  SDLShooter
//
//  Created by 沈莼乾 on 2024/10/11.
//

import SDL2

extension SDL_KeyCode: @retroactive Equatable {}
extension SDL_KeyCode: @retroactive Hashable {}

@_transparent
public func SDL_Flag<I: FixedWidthInteger, R: RawRepresentable>(_ flag: R) -> I where R.RawValue: FixedWidthInteger {
    I(flag.rawValue)
}

#!/usr/bin/env bash

set -eu

#################### 构建 SDL2 ####################

# 克隆 SDL 仓库
# git clone --recursive https://github.com/libsdl-org/SDL.git build/SDL

pushd build/SDL
echo $PWD

# 检出指定的 SDL 版本
git checkout release-2.30.8 --force

# 公共的头文件列表
COMMON_HEADER_FILES=(
"SDL.h"
"SDL_assert.h"
"SDL_atomic.h"
"SDL_audio.h"
"SDL_blendmode.h"
"SDL_clipboard.h"
"SDL_config.h"
"SDL_cpuinfo.h"
"SDL_endian.h"
"SDL_error.h"
"SDL_events.h"
"SDL_filesystem.h"
"SDL_gamecontroller.h"
"SDL_gesture.h"
"SDL_guid.h"
"SDL_haptic.h"
"SDL_hidapi.h"
"SDL_hints.h"
"SDL_joystick.h"
"SDL_keyboard.h"
"SDL_keycode.h"
"SDL_loadso.h"
"SDL_locale.h"
"SDL_log.h"
"SDL_main.h"
"SDL_messagebox.h"
"SDL_metal.h"
"SDL_misc.h"
"SDL_mouse.h"
"SDL_mutex.h"
"SDL_pixels.h"
"SDL_platform.h"
"SDL_power.h"
"SDL_quit.h"
"SDL_rect.h"
"SDL_render.h"
"SDL_rwops.h"
"SDL_rwops.h"
"SDL_scancode.h"
"SDL_sensor.h"
"SDL_shape.h"
"SDL_stdinc.h"
"SDL_surface.h"
"SDL_system.h"
"SDL_thread.h"
"SDL_timer.h"
"SDL_touch.h"
"SDL_version.h"
"SDL_video.h"
"SDL_vulkan.h"
"begin_code.h"
"close_code.h"
)

# 创建 macOS 和 iOS 的头文件目录
rm -rdf "../Headers-macos"
rm -rdf "../Headers-ios"
mkdir -p "../Headers-macos"
mkdir -p "../Headers-ios"
for hFile in ${COMMON_HEADER_FILES[@]}; do
	cp "include/${hFile}" "../Headers-macos"
	cp "include/${hFile}" "../Headers-ios"
done

# 复制平台相关的配置文件
cp "include/SDL_config_macosx.h" "../Headers-macos"
cp "include/SDL_config_iphoneos.h" "../Headers-ios"

BUILD_DIR=".."

# 生成模块映射文件(module map)
COMMON_LINKED_FRAMEWORKS=(
"AudioToolbox"
"AVFoundation"
"CoreAudio"
"CoreGraphics"
"CoreHaptics"
"CoreMotion"
"Foundation"
"GameController"
"IOKit"
"Metal"
"QuartzCore"
)

# SDL2 modulemap
MM_OUT_MACOS="module SDL2 {\n    header \"SDL.h\"\n    header \"SDL_vulkan.h\"\n    export *\n    link \"SDL2\"\n"
MM_OUT_IOS="module SDL2 {\n    header \"SDL.h\"\n    header \"SDL_vulkan.h\"\n    export *\n    link \"SDL2\"\n"

for fw in ${COMMON_LINKED_FRAMEWORKS[@]}; do
	MM_OUT_MACOS+="    link framework \"${fw}\"\n"
	MM_OUT_IOS+="    link framework \"${fw}\"\n"
done

LINKED_FRAMEWORKS_MACOS=(
"Carbon"
"Cocoa"
"ForceFeedback"
)

for fw in ${LINKED_FRAMEWORKS_MACOS[@]}; do
	MM_OUT_MACOS+="    link framework \"${fw}\"\n"
done

LINKED_FRAMEWORKS_IOS=(
"OpenGLES"
"UIKit"
)

for fw in ${LINKED_FRAMEWORKS_IOS[@]}; do
	MM_OUT_IOS+="    link framework \"${fw}\"\n"
done

MM_OUT_MACOS+="}\n\n"
MM_OUT_IOS+="}\n\n"

# SDL_ttf modulemap
MM_OUT_MACOS+="module SDL_ttf {\n    header \"SDL_ttf.h\"\n    export *\n    link \"SDL2_ttf\"\n"
MM_OUT_IOS+="module SDL_ttf {\n    header \"SDL_ttf.h\"\n    export *\n    link \"SDL2_ttf\"\n"

MM_OUT_MACOS+="}\n\n"
MM_OUT_IOS+="}\n\n"

# SDL_image modulemap
MM_OUT_MACOS+="module SDL_image {\n    header \"SDL_image.h\"\n    export *\n    link \"SDL2_image\"\n"
MM_OUT_IOS+="module SDL_image {\n    header \"SDL_image.h\"\n    export *\n    link \"SDL2_image\"\n"

MM_OUT_MACOS+="}\n\n"
MM_OUT_IOS+="}\n\n"

# SDL_mixer modulemap
MM_OUT_MACOS+="module SDL_mixer {\n    header \"SDL_mixer.h\"\n    export *\n    link \"SDL2_mixer\"\n"
MM_OUT_IOS+="module SDL_mixer {\n    header \"SDL_mixer.h\"\n    export *\n    link \"SDL2_mixer\"\n"

MM_OUT_MACOS+="}\n\n"
MM_OUT_IOS+="}\n\n"

# freetype modulemap
MM_OUT_MACOS+="module freetype {\n    link \"freetype\"\n"
MM_OUT_IOS+="module freetype {\n    link \"freetype\"\n"

MM_OUT_MACOS+="}\n\n"
MM_OUT_IOS+="}\n\n"

# 输出 module map 到相应的目录
printf "%b" "${MM_OUT_MACOS}" > "../Headers-macos/module.modulemap"
printf "%b" "${MM_OUT_IOS}" > "../Headers-ios/module.modulemap"

# 构建 SDL 静态库
pushd Xcode/SDL
echo $PWD

BUILD_DIR="../../.."

# build archives
xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-macosx/" -destination "generic/platform=macOS" BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
# xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-iOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-iphoneos/" -destination "generic/platform=iOS"  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
# xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-iOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-iphonesimulator/" -destination "generic/platform=iOS Simulator"  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
# xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-tvOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-appletvos/" -destination "generic/platform=tvOS"  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO
# xcodebuild archive -quiet ONLY_ACTIVE_ARCH=NO -scheme "Static Library-tvOS" -project "SDL.xcodeproj" -archivePath "${BUILD_DIR}/SDL-appletvsimulator/" -destination "generic/platform=tvOS Simulator" BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

popd
echo $PWD
popd
echo $PWD

BUILD_DIR="build"
HEADERS_DIR="build/Headers"

mkdir -p "${BUILD_DIR}/XCFramework"

rm -rdf "${BUILD_DIR}/XCFramework/SDL2.xcframework"

# 创建 xcframework
# xcodebuild -create-xcframework \
# 	-library "${BUILD_DIR}/SDL-macosx.xcarchive/Products/usr/local/lib/libSDL2.a" \
# 	-headers "${HEADERS_DIR}-macos" \
# 	-library "${BUILD_DIR}/SDL-iphoneos.xcarchive/Products/usr/local/lib/libSDL2.a" \
# 	-headers "${HEADERS_DIR}-ios" \
# 	-library "${BUILD_DIR}/SDL-iphonesimulator.xcarchive/Products/usr/local/lib/libSDL2.a" \
# 	-headers "${HEADERS_DIR}-ios" \
# 	-library "${BUILD_DIR}/SDL-appletvos.xcarchive/Products/usr/local/lib/libSDL2.a" \
# 	-headers "${HEADERS_DIR}-ios" \
# 	-library "${BUILD_DIR}/SDL-appletvsimulator.xcarchive/Products/usr/local/lib/libSDL2.a" \
# 	-headers "${HEADERS_DIR}-ios" \
# 	-output "${BUILD_DIR}/SDL2.xcframework"

xcodebuild -create-xcframework \
	-library "${BUILD_DIR}/SDL-macosx.xcarchive/Products/usr/local/lib/libSDL2.a" \
	-headers "${HEADERS_DIR}-macos" \
	-output "${BUILD_DIR}/XCFramework/SDL2.xcframework"

#################### 构建 SDL_ttf ####################

# 克隆并构建 SDL_ttf
# git clone --recursive https://github.com/libsdl-org/SDL_ttf.git build/SDL_ttf

pushd build/SDL_ttf
echo $PWD

git checkout release-2.22.0 --force

# 使用 CMake 构建 SDL_ttf
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DSDL2TTF_VENDORED=ON -DSDL2TTF_SAMPLES=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libSDL2_ttf.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: SDL_ttf 静态库未生成"
	exit 1
fi

# 复制 SDL_ttf 头文件
rm -rdf "../../Headers-macos"
rm -rdf "../../Headers-ios"
mkdir -p "../../Headers-macos"
mkdir -p "../../Headers-ios"
cp ../SDL_ttf.h "../../Headers-macos"
cp ../SDL_ttf.h "../../Headers-ios"

# 返回主目录
popd
echo $PWD

# 创建 SDL_ttf xcframework
rm -rdf "${BUILD_DIR}/XCFramework/SDL_ttf.xcframework"

xcodebuild -create-xcframework \
	-library "build/SDL_ttf/build/$LIB_TTF_PATH" \
	-headers "${HEADERS_DIR}-macos" \
	-output "${BUILD_DIR}/XCFramework/SDL_ttf.xcframework"

# 创建 SDL_ttf xcframework

#################### 构建 SDL_image ####################

# 克隆并构建 SDL_image
# git clone --recursive https://github.com/libsdl-org/SDL_image.git build/SDL_image

pushd build/SDL_image
echo $PWD

git checkout release-2.8.2 --force

# 使用 CMake 构建 SDL_image
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DSDL2IMAGE_SAMPLES=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libSDL2_image.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: SDL_image 静态库未生成"
	exit 1
fi

# 复制 SDL_image 头文件
rm -rdf "../../Headers-macos"
rm -rdf "../../Headers-ios"
mkdir -p "../../Headers-macos"
mkdir -p "../../Headers-ios"
cp ../include/SDL_image.h "../../Headers-macos"
cp ../include/SDL_image.h "../../Headers-ios"

# 返回主目录
popd
echo $PWD

# 创建 SDL_image xcframework
rm -rdf "${BUILD_DIR}/XCFramework/SDL_image.xcframework"

xcodebuild -create-xcframework \
	-library "build/SDL_image/build/$LIB_TTF_PATH" \
	-headers "${HEADERS_DIR}-macos" \
	-output "${BUILD_DIR}/XCFramework/SDL_image.xcframework"

# #################### 构建 SDL_mixer ####################

# 克隆并构建 SDL_mixer
# git clone --recursive https://github.com/libsdl-org/SDL_mixer.git build/SDL_mixer

pushd build/SDL_mixer
echo $PWD

git checkout release-2.8.0 --force

# 使用 CMake 构建 SDL_mixer
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DSDL2MIXER_VENDORED=ON -DSDL2MIXER_SAMPLES=OFF -DSDL2MIXER_VORBIS=VORBISFILE -DSDL2MIXER_DEPS_SHARED=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libSDL2_mixer.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: SDL_mixer 静态库未生成"
	exit 1
fi

# 复制 SDL_mixer 头文件
rm -rdf "../../Headers-macos"
rm -rdf "../../Headers-ios"
mkdir -p "../../Headers-macos"
mkdir -p "../../Headers-ios"
cp ../include/SDL_mixer.h "../../Headers-macos"
cp ../include/SDL_mixer.h "../../Headers-ios"

# 返回主目录
popd
echo $PWD

# 创建 SDL_mixer xcframework
rm -rdf "${BUILD_DIR}/XCFramework/SDL_mixer.xcframework"

xcodebuild -create-xcframework \
	-library "build/SDL_mixer/build/$LIB_TTF_PATH" \
	-headers "${HEADERS_DIR}-macos" \
	-output "${BUILD_DIR}/XCFramework/SDL_mixer.xcframework"

#################### 构建 freetype ####################

FREETYPE_BUILD_DIR=build/SDL_ttf/build/external/freetype

pushd ${FREETYPE_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libfreetype.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: freetype 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 freetype xcframework
rm -rdf "${BUILD_DIR}/XCFramework/freetype.xcframework"

xcodebuild -create-xcframework \
	-library "${FREETYPE_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/freetype.xcframework"

#################### 构建 ogg ####################

OGG_BUILD_DIR=build/SDL_mixer/build/external/ogg

pushd ${OGG_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libogg.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: ogg 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 ogg xcframework
rm -rdf "${BUILD_DIR}/XCFramework/ogg.xcframework"

xcodebuild -create-xcframework \
	-library "${OGG_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/ogg.xcframework"

#################### 构建 wavpack ####################

WAVPACK_BUILD_DIR=build/SDL_mixer/build/external/wavpack

pushd ${WAVPACK_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libwavpack.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: wavpack 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 wavpack xcframework
rm -rdf "${BUILD_DIR}/XCFramework/wavpack.xcframework"

xcodebuild -create-xcframework \
	-library "${WAVPACK_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/wavpack.xcframework"

#################### 构建 libxmp ####################

LIBXMP_BUILD_DIR=build/SDL_mixer/build/external/libxmp

pushd ${LIBXMP_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libxmp.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: libxmp 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 libxmp xcframework
rm -rdf "${BUILD_DIR}/XCFramework/libxmp.xcframework"

xcodebuild -create-xcframework \
	-library "${LIBXMP_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/libxmp.xcframework"

#################### 构建 opus ####################

OPUS_BUILD_DIR=build/SDL_mixer/build/external/opus

pushd ${OPUS_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libopus.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: opus 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 opus xcframework
rm -rdf "${BUILD_DIR}/XCFramework/opus.xcframework"

xcodebuild -create-xcframework \
	-library "${OPUS_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/opus.xcframework"

#################### 构建 opusfile ####################

OPUSFILE_BUILD_DIR=build/SDL_mixer/build/external/opusfile

pushd ${OPUSFILE_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libopusfile.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: opusfile 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 opusfile xcframework
rm -rdf "${BUILD_DIR}/XCFramework/opusfile.xcframework"

xcodebuild -create-xcframework \
	-library "${OPUSFILE_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/opusfile.xcframework"

#################### 构建 vorbis ####################

VORBIS_BUILD_DIR=build/SDL_mixer/build/external/vorbis

pushd ${VORBIS_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libvorbis.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: vorbis 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 vorbis xcframework
rm -rdf "${BUILD_DIR}/XCFramework/vorbis.xcframework"

xcodebuild -create-xcframework \
	-library "${VORBIS_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/vorbis.xcframework"

#################### 构建 vorbisfile ####################

VORBISFILE_BUILD_DIR=build/SDL_mixer/build/external/vorbis

pushd ${VORBISFILE_BUILD_DIR}
echo $PWD

# 查找并验证生成的库文件路径
LIB_TTF_PATH=$(find . -name "libvorbisfile.a")

# 如果库文件未生成, 抛出错误
if [ -z "$LIB_TTF_PATH" ]; then
	echo "Error: vorbisfile 静态库未生成"
	exit 1
fi

# 返回主目录
popd
echo $PWD

# 创建 vorbisfile xcframework
rm -rdf "${BUILD_DIR}/XCFramework/vorbisfile.xcframework"

xcodebuild -create-xcframework \
	-library "${VORBISFILE_BUILD_DIR}/$LIB_TTF_PATH" \
	-output "${BUILD_DIR}/XCFramework/vorbisfile.xcframework"

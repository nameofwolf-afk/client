cmake_minimum_required(VERSION 3.20)
project(enhance)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Java JDK
find_package(JNI REQUIRED)

# MinHook library paths
set(MINHOOK_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/utils/minhook/include")
set(MINHOOK_LIB "${CMAKE_SOURCE_DIR}/utils/minhook/lib/libMinHook-x64.lib")

# JNIHook include
set(JNIHOOK_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/utils/jnihook-master/include")

# ImGui sources
set(IMGUI_DIR "${CMAKE_SOURCE_DIR}/utils/imgui")
file(GLOB IMGUI_SOURCES 
    "${IMGUI_DIR}/*.cpp"
)

# SDK sources
file(GLOB_RECURSE SDK_SOURCES 
    "sdk/*.cpp"
)

# Enhance sources (excluding wolf_menu.cpp to avoid duplicate symbols)
file(GLOB_RECURSE ENHANCE_SOURCES 
    "enhance/*.cpp"
)
list(FILTER ENHANCE_SOURCES EXCLUDE REGEX ".*wolf_menu\\.cpp$")

# JNIHook sources
file(GLOB JNIHOOK_SOURCES
    "utils/jnihook-master/src/*.cpp"
)

# Main DLL project
add_library(enhance SHARED
    dllmain.cpp
    ${IMGUI_SOURCES}
    ${SDK_SOURCES}
    ${ENHANCE_SOURCES}
    ${JNIHOOK_SOURCES}
)

target_include_directories(enhance PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${JNI_INCLUDE_DIRS}
    ${MINHOOK_INCLUDE_DIR}
    ${JNIHOOK_INCLUDE_DIR}
    ${IMGUI_DIR}
)

target_link_libraries(enhance PRIVATE
    ${JNI_LIBRARIES}
    ${MINHOOK_LIB}
    opengl32
    winmm
)

target_compile_definitions(enhance PRIVATE
    ENHANCE_EXPORTS
    _WINDOWS
    _USRDLL
    _CRT_SECURE_NO_WARNINGS
)

set_target_properties(enhance PROPERTIES OUTPUT_NAME "opengl32")

# Injector project requires zig, so we'll skip it in CMake for now.
# add_executable(injector
#    injector/main.cpp
# )

# target_include_directories(injector PRIVATE
#    ${CMAKE_SOURCE_DIR}/injector
# )

# Add Windows libraries for injector
# if(WIN32)
#    # Use MultiByte character set instead of Unicode to match the code
#    target_compile_definitions(injector PRIVATE
#        _MBCS
#    )
# endif()

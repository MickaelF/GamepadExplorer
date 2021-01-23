cmake_minimum_required(VERSION 3.17)
set (PROJECT_NAME "GamepadExplorer")
project(${PROJECT_NAME})

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_STATIC_LIBS TRUE)

# ********* SDL2 *********
set(SDL2_DIR ${CMAKE_SOURCE_DIR}/thirdParty/SDL2/cmake)
if (WIN32)
    set(SDL2_BASE_DIR ${CMAKE_SOURCE_DIR}/thirdParty/SDL2/)
    set(SDL2_INCLUDE_DIRS "${SDL2_BASE_DIR}/include")

    # Support both 32 and 64 bit builds
    if (${CMAKE_BUILD_TYPE} MATCHES Debug)
        set(SDL2_LIBRARIES "${SDL2_BASE_DIR}/lib/SDL2d.lib;${SDL2_BASE_DIR}/lib/SDL2maind.lib")
    else ()
        set(SDL2_LIBRARIES "${SDL2_BASE_DIR}/lib/SDL2.lib;${SDL2_BASE_DIR}/lib/SDL2main.lib")
    endif ()
    string(STRIP "${SDL2_LIBRARIES}" SDL2_LIBRARIES)
endif()

# ********** Json *********
set(nlohmann_json_DIR  ${CMAKE_SOURCE_DIR}/thirdParty/json/lib/cmake/nlohmann_json/)

find_package(SDL2 REQUIRED)
find_package(nlohmann_json REQUIRED)

# ********* Application *********
set(SRCS src/main.cpp)

add_executable(${PROJECT_NAME} ${SRCS})
target_link_libraries(${PROJECT_NAME} ${SDL2_LIBRARIES} nlohmann_json::nlohmann_json)
target_include_directories(${PROJECT_NAME} PUBLIC ${SDL2_INCLUDE_DIRS})
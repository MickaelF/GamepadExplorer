#include <SDL2/SDL.h>
#include <string>
#include <vector>
#include <nlohmann/json.hpp>
#include <iostream>

using json = nlohmann::json;
struct GamepadData
{
    SDL_JoystickGUID guid;
    std::string name;
};

std::string guidToString(const SDL_JoystickGUID& guid)
{
    std::string str;
    for (int i = 0; i< 16; ++i)
        str += std::to_string(guid.data[i]);
    return str;
}

int main(int argc, char** argv)
{
    if (SDL_Init(SDL_INIT_JOYSTICK) < 0)
    {
        return -1;
    }
    
    int nbGamepad = SDL_NumJoysticks();
    
    if (nbGamepad < 1)
        return -2; 
    std::vector<GamepadData> gamepads;
    for (int i = 0; i < nbGamepad; ++i)
    {
       auto gamepad = SDL_JoystickOpen(i);
       if (!gamepad) continue;
       
       gamepads.push_back({
           SDL_JoystickGetDeviceGUID(i),
           SDL_JoystickName(gamepad)
       });
       
       SDL_JoystickClose(gamepad);
    }
    
    json output = json::array();
    for (auto& controller : gamepads)
    {
        json controllerJson;
        controllerJson["GUID"] = guidToString(controller.guid);
        controllerJson["name"] = controller.name;
        output.push_back(controllerJson);
    }
    std::cout << output;
    return 0;
}
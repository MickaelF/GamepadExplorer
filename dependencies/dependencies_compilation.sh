#!/bin/bash
cmakeExe=$1
if [ ! $1 ] ; then
    echo "The path to used cmake executable must be passed to this script!"
    exit
fi
Compiler="Visual Studio 16 2019"
installDir=$PWD/../thirdParty
sdl2Version=SDL2-2.0.14

GitUpdate()
{
    folder=$PWD/$1
    echo $folder
    if [ ! -d $PWD/$1 ] ; then
        git clone $2
        if [ ! $? -eq 0 ]; then
            return
        fi
    fi
    cd $1
    git fetch --all
    LastTag
    if [ "$3" = true ]; then
        GenerateProject $1 $3
    else
        CopyFile $1
    fi
    cd ..
}

GenerateProject()
{
    cd $1
    $cmakeExe -DCMAKE_INSTALL_PREFIX="$installDir/$1" -G "$Compiler" -S "." -B "$PWD/build" -DCMAKE_CXX_STANDARD=20
    if [ ! $? -eq 0 ]; then
        echo "Issue while generating project $1"
    fi

    $cmakeExe --build "$PWD/build" -j 8 --config Release
    if [ ! $? -eq 0 ]; then
        echo "Issue while compiling project $1 in Release"
    fi
    $cmakeExe --install "$PWD/build" --config Release -v

    $cmakeExe --build "$PWD/build" -j 8 --config Debug
    if [ ! $? -eq 0 ]; then
        echo "Issue while compiling project $1 in Debug"
    fi
    $cmakeExe --install "$PWD/build" --config Debug
    cd ..
}

LastTag()
{
    latesttag=$(git describe --tags)
    git checkout $latesttag
}

CopyFile()
{
    cp -R . $installDir/$1
}

# TODO : Using the variable in the url doesn't work, somehow.
if [ ! -d $PWD/SDL2 ] ; then
    curl https://www.libsdl.org/release/SDL2-2.0.14.zip --output "$sdl2Version.zip"
    7z x "$sdl2Version.zip"
    rm "$sdl2Version.zip"
    mv $sdl2Version SDL2
fi

GenerateProject SDL2
GitUpdate json https://github.com/nlohmann/json true
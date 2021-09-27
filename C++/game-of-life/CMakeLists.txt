cmake_minimum_required(VERSION 3.3)
project(GameOfLife)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++98")

add_executable(GameOfLife gameOfBram.cpp)
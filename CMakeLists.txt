cmake_minimum_required(VERSION 3.20)
project(hw2_group)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(hw2_group
        demo_commd_arg/commArg.c
        demo_commd_arg/commArg2.c
        demo_commd_arg/demoParser.c
        pgmProcess.cu
        pgmProcess.h
        pgmUtility.c
        pgmUtility.h)

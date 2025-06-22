# 设置cmake的最低版本和项目名称
cmake_minimum_required(VERSION 3.22)
project(KVRaftCpp)

# 明確指定 protobuf 路徑
set(Protobuf_INCLUDE_DIRS /usr/local/protobuf-3.12.4/include)
set(Protobuf_LIBRARIES /usr/local/protobuf-3.12.4/lib/libprotobuf.so)
set(Protobuf_PROTOC_EXECUTABLE /usr/local/protobuf-3.12.4/bin/protoc)

# 將 Protobuf 的頭文件路徑添加到全局包含目錄
include_directories(${Protobuf_INCLUDE_DIRS})

set(CMAKE_CXX_STANDARD 20)
# 生成debug版本，可以进行gdb调试
set(CMAKE_BUILD_TYPE "Debug")

# 设置项目可执行文件输出的路径
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
# 设置项目库文件输出的路径
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

# 设置项目编译头文件搜索路径 -I
# 目前可能存在路径污染的问题，需要进一步解决
include_directories(${PROJECT_SOURCE_DIR}/src/common/include)
include_directories(${PROJECT_SOURCE_DIR}/src/fiber/include)
include_directories(${PROJECT_SOURCE_DIR}/src/rpc/include)
include_directories(${PROJECT_SOURCE_DIR}/example)
include_directories(${PROJECT_SOURCE_DIR}/src/raftCore/include)
include_directories(${PROJECT_SOURCE_DIR}/src/raftRpcPro/include)
include_directories(${PROJECT_SOURCE_DIR}/src/raftClerk/include)
include_directories(${PROJECT_SOURCE_DIR}/src/skipList/include)


# 设置项目库文件搜索路径 -L
link_directories(${PROJECT_SOURCE_DIR}/lib)

# src包含了所有的相关代码
add_subdirectory(src)
# example包含了使用的示例代码
add_subdirectory(example)

add_library(skip_list_on_raft STATIC  ${src_rpc} ${src_fiber} ${rpc_example} ${raftsource} ${src_raftCore} ${src_raftRpcPro})
target_link_libraries(skip_list_on_raft muduo_net muduo_base pthread dl ${Protobuf_LIBRARIES})
target_include_directories(skip_list_on_raft PUBLIC ${Protobuf_INCLUDE_DIRS})


add_custom_target(format
        COMMAND bash ${PROJECT_SOURCE_DIR}/format.sh
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMAND echo "format done!"
)


# 添加格式化目标 end

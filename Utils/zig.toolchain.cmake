if(DEFINED ENV{TARGET_SYS})
  set(TARGET_SYS $ENV{TARGET_SYS})
endif()

if(TARGET_SYS AND NOT ZIG_INIT)
  set(ZIG_INIT ON)

  set(ZBUILDTYPE)
  if(CMAKE_BUILD_TYPE)
    string(TOLOWER ${CMAKE_BUILD_TYPE} ZBUILDTYPE)
    if(${ZBUILDTYPE} MATCHES "release")
      set(BUILDFLAGS "-O3")
    elseif(${ZBUILDTYPE} MATCHES "debug")
      set(BUILDFLAGS "-g -fno-stack-protector -fno-omit-frame-pointer")
    endif()
  endif()

  if(${TARGET_SYS} STREQUAL native)
    set(CMAKE_SIZEOF_VOID_P 8)
    set(HAVE_FLAG_SEARCH_PATHS_FIRST 0)
  else()
    string(REPLACE "-" ";" TARGETS ${TARGET_SYS})

    list(GET TARGETS 0 ARCH)
    list(GET TARGETS 1 TARGET)

    string(SUBSTRING ${TARGET} 0 1 T1)
    string(TOUPPER ${T1} T1)
    string(SUBSTRING ${TARGET} 1 10 TARGET)
    set(TARGET "${T1}${TARGET}")

    if(${ARCH} STREQUAL i386)
      set(ARCH i686)
    endif()

    if(${TARGET} STREQUAL Macos)
      set(TARGET Darwin)
      set(APPLE TRUE)
      set(HAVE_FLAG_SEARCH_PATHS_FIRST 0)
    endif()

    set(CMAKE_CROSSCOMPILING ON)
    set(CMAKE_SYSTEM_NAME ${TARGET})
    set(CMAKE_SYSTEM_PROCESSOR ${ARCH})
    message(STATUS "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")

    string(FIND ${ARCH} "64" BIT64)
    if(NOT ${BIT64} EQUAL -1)
      set(CMAKE_SIZEOF_VOID_P 8)
    else()
      set(CMAKE_SIZEOF_VOID_P 4)
    endif()
  endif()

  include(CMakeForceCompiler)

  set(CMAKE_C_COMPILER_FORCED 1)
  set(CMAKE_C_COMPILER_ID_RUN TRUE)
  set(CMAKE_ASM_COMPILER_FORCED 1)
  set(CMAKE_ASM_COMPILER_ID_RUN TRUE)
  set(CMAKE_CXX_COMPILER_FORCED 1)
  set(CMAKE_CXX_COMPILER_ID_RUN TRUE)

  set(CMAKE_C_COMPILER "zcc")
  set(CMAKE_C_COMPILER_ID "zig")
  set(CMAKE_C_COMPILER_VERSION 11.0)
  set(CMAKE_C_COMPILER_TARGET   ${TARGET_SYS})
  set(CMAKE_C_FLAGS_INIT "-target ${TARGET_SYS} ${BUILDFLAGS}")

  set(CMAKE_ASM_COMPILER "zcc")
  set(CMAKE_ASM_COMPILER_ID "zig")
  set(CMAKE_ASM_COMPILER_VERSION 11.0)
  set(CMAKE_ASM_COMPILER_TARGET   ${TARGET_SYS})
  set(CMAKE_ASM_FLAGS_INIT "-target ${TARGET_SYS} ${BUILDFLAGS}")

  set(CMAKE_CXX_COMPILER "zc++")
  set(CMAKE_CXX_COMPILER_ID "zig")
  set(CMAKE_CXX_COMPILER_VERSION 11.0)
  set(CMAKE_CXX_COMPILER_TARGET   ${TARGET_SYS})
  set(CMAKE_CXX_FLAGS_INIT "-target ${TARGET_SYS} ${BUILDFLAGS}")

  SET(CMAKE_AR "/usr/local/opt/llvm/bin/llvm-ar")
  SET(CMAKE_RANLIB "/usr/local/opt/llvm/bin/llvm-ranlib")

  #SET(CMAKE_C_ARCHIVE_CREATE   "<CMAKE_AR> build-lib -target ${TARGET_SYS} --name $<TARGET_FILE_BASE_NAME:$<TARGET>>  <LINK_FLAGS> <OBJECTS>")
  #SET(CMAKE_C_ARCHIVE_FINISH   "<CMAKE_RANLIB> <TARGET>")

  #SET(CMAKE_ASM_ARCHIVE_CREATE ${CMAKE_C_ARCHIVE_CREATE})
  #SET(CMAKE_ASM_ARCHIVE_FINISH ${CMAKE_C_ARCHIVE_FINISH})

  #SET(CMAKE_CXX_ARCHIVE_CREATE ${CMAKE_C_ARCHIVE_CREATE})
  #SET(CMAKE_CXX_ARCHIVE_FINISH ${CMAKE_C_ARCHIVE_FINISH})
endif()

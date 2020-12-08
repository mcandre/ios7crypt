cmake_minimum_required(VERSION 3.4)
set(CMAKE_MESSAGE_LOG_LEVEL "WARNING")
set(EXECUTABLE_OUTPUT_PATH "bin")
project(ios7crypt++)

if(MSVC)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${EXECUTABLE_OUTPUT_PATH}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${EXECUTABLE_OUTPUT_PATH}")

    set(WINDOWS_C_FLAGS "${CMAKE_C_FLAGS} /INCREMENTAL:NO /std:c17 /Ox /WX /W4 /wd4204")
    set(WINDOWS_CXX_FLAGS "${CMAKE_CXX_FLAGS} /INCREMENTAL:NO /std:c++17 /Ox /WX /W4 /wd4204")
    set(CMAKE_C_FLAGS "${WINDOWS_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "${WINDOWS_CXX_FLAGS}")
else()
    set(UNIX_C_FLAGS "${CMAKE_C_FLAGS} -O3 -Werror")
    set(UNIX_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -Werror")
    set(GNU_C_FLAGS "${UNIX_C_FLAGS} -std=gnu17 -Wextra -Wall -pedantic")
    set(GNU_CXX_FLAGS "${UNIX_CXX_FLAGS} -std=c++17 -Wextra -Wall -pedantic -Weffc++")
    set(LLVM_FLAGS "-Wmost")
    set(CLANG_C_FLAGS "${GNU_C_FLAGS} ${LLVM_FLAGS}")
    set(CLANG_CXX_FLAGS "${GNU_CXX_FLAGS} ${LLVM_FLAGS}")

    if(CMAKE_C_COMPILER_ID MATCHES "Clang")
        set(CMAKE_C_FLAGS "${CLANG_C_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CLANG_CXX_FLAGS}")
    else()
        set(CMAKE_C_FLAGS "${GNU_C_FLAGS}")
        set(CMAKE_CXX_FLAGS "${GNU_CXX_FLAGS}")
    endif()
endif()

include_directories(include)

add_executable(ios7crypt++ src/cmd/ios7crypt++/main.cpp src/ios7crypt++.cpp)

enable_testing()
add_test(NAME ios7crypt_encrypt_test COMMAND bin/ios7crypt++ -e monkey)
add_test(NAME ios7crypt_decrypt_test COMMAND bin/ios7crypt++ -d "0941410712000e")
add_test(NAME ios7crypt_usage_test COMMAND bin/ios7crypt++ -h)

add_custom_target(cppcheck COMMAND cppcheck -q --force --enable=all --inline-suppr --suppressions-list=suppressions.cfg --error-exitcode=1 -U__SANITIZE_ADDRESS__ -I include src)
add_custom_target(cpplint COMMAND sail include src | xargs -n 1 cpplint)
add_custom_target(vera++ COMMAND sail include src | xargs -n 1 vera++)

# Missing linter ports
if(MSVC)
    add_custom_target(lint DEPENDS cppcheck)
else()
    add_custom_target(lint DEPENDS cppcheck cpplint vera++)
endif()

add_custom_target(valgrind_encrypt_test COMMAND valgrind --error-exitcode=1 --leak-check=full bin/ios7crypt++ -e monkey)
add_custom_target(valgrind_decrypt_test COMMAND valgrind --error-exitcode=1 --leak-check=full bin/ios7crypt++ -d "00091c080f5e12")
add_custom_target(valgrind_usage_test COMMAND valgrind --error-exitcode=1 --leak-check=full bin/ios7crypt++ -h)
add_custom_target(valgrind DEPENDS valgrind_encrypt_test valgrind_decrypt_test valgrind_usage_test)

# Broken or missing valgrind
if(
    MSVC OR
    CMAKE_C_COMPILER MATCHES "aarch64" OR
    CMAKE_SYSTEM_NAME MATCHES "FreeBSD" OR
    CMAKE_SYSTEM_NAME MATCHES "Darwin"
)
    add_custom_target(leaks)
else()
    add_custom_target(leaks DEPENDS valgrind)
endif()

if(
    CMAKE_C_COMPILER_ID MATCHES "Clang" AND
    NOT CMAKE_SYSTEM_NAME MATCHES "Darwin"
)
    set(SANITIZE_TIMEOUT_SEC 10)
    set(FUZZER_RUNTIME_FLAGS "-max_total_time=${SANITIZE_TIMEOUT_SEC}")

    add_executable(fuzz-ios7crypt++ src/cmd/ios7crypt++/main.cpp src/ios7crypt++.cpp)

    set(SANITIZE_RULES "fuzzer,address,undefined")
    set(SANITIZE_FLAGS "-fsanitize=${SANITIZE_RULES} -fno-sanitize-recover=${SANITIZE_RULES}")

    set_target_properties(
        fuzz-ios7crypt++
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "debug"
        COMPILE_FLAGS "-g ${SANITIZE_FLAGS}"
        LINK_FLAGS "${SANITIZE_FLAGS}"
        COMPILE_DEFINITIONS "__SANITIZE_ADDRESS__"
    )

    add_custom_target(fuzz COMMAND debug/fuzz-ios7crypt++ "${FUZZER_RUNTIME_FLAGS}")
else()
    add_custom_target(fuzz)
endif()

add_custom_target(doc COMMAND doxygen Doxyfile)
add_custom_target(clean-cmake COMMAND sh clean-cmake.sh)

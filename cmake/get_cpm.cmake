set(CPM_DOWNLOAD_VERSION 1.0.0-development-version)

if(CPM_SOURCE_CACHE)
  set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
elseif(DEFINED ENV{CPM_SOURCE_CACHE})
  set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
else()
  set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
endif()

# Expand relative path. This is important if the provided path contains a tilde (~)
get_filename_component(CPM_DOWNLOAD_LOCATION ${CPM_DOWNLOAD_LOCATION} ABSOLUTE)
if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
  message(STATUS "Downloading CPM.cmake to ${CPM_DOWNLOAD_LOCATION}")
  file(DOWNLOAD
       https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake
       ${CPM_DOWNLOAD_LOCATION}
       STATUS status_error
  )
  # Check if download was successful
  list(GET status_error 0 status)
  if (NOT status EQUAL 0)
    # file(DOWNLOAD) creates an empty file upon error, remove it so it is not
    # mistaken for a proper CPM.cmake script by future runs of get_cpm.cmake
    file (REMOVE ${CPM_DOWNLOAD_LOCATION})
    list(GET status_error 1 error_message)
    message(FATAL_ERROR "Downloading CPM.cmake failed: ${error_message}")
  endif()
endif()

include(${CPM_DOWNLOAD_LOCATION})

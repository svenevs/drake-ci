set(DASHBOARD_PACKAGES "")

macro(add_package NAME ENABLED)
  set(DASHBOARD_WITH_${NAME} ${ENABLED})
  list(APPEND DASHBOARD_PACKAGES ${NAME})
endmacro()

macro(enable_package NAME)
  set(DASHBOARD_WITH_${NAME} ON)
endmacro()

macro(disable_package NAME)
  set(DASHBOARD_WITH_${NAME} OFF)
endmacro()

add_package(BOT_CORE_LCMTYPES         ON)
add_package(BULLET                    ON)
add_package(DIRECTOR                  ON)
add_package(DRAKE                     ON)
add_package(EIGEN                     ON)
add_package(FCL                       ON)
add_package(FMT                       ON)
add_package(GFLAGS                    ON)
add_package(GOOGLETEST                ON)
add_package(GOOGLE_STYLEGUIDE         ON)
add_package(GUROBI                    OFF)
add_package(IGNITION_MATH             ON)
add_package(IGNITION_RNDF             ON)
add_package(IPOPT                     ON)
add_package(LCM                       ON)
add_package(LIBBOT                    ON)
add_package(LIBCCD                    ON)
add_package(MOSEK                     OFF)
add_package(NLOPT                     ON)
add_package(OCTOMAP                   ON)
add_package(PROTOBUF                  ON)
add_package(PYBIND11                  ON)
add_package(ROBOTLOCOMOTION_LCMTYPES  ON)
add_package(SDFORMAT                  ON)
add_package(SNOPT                     OFF)
add_package(SPDLOG                    ON)
add_package(TEXTBOOK                  OFF)
add_package(TINYOBJLOADER             ON)
add_package(VTK                       ON)
add_package(YAML_CPP                  ON)

if(MINIMAL)
  disable_package(BOT_CORE_LCMTYPES)
  disable_package(BULLET)
  disable_package(DIRECTOR)
  disable_package(FCL)
  disable_package(GOOGLE_STYLEGUIDE)
  disable_package(IGNITION_MATH)
  disable_package(IGNITION_RNDF)
  disable_package(IPOPT)
  disable_package(LCM)
  disable_package(LIBBOT)
  disable_package(LIBCCD)
  disable_package(NLOPT)
  disable_package(OCTOMAP)
  disable_package(PYBIND11)
  disable_package(ROBOTLOCOMOTION_LCMTYPES)
  disable_package(SPDLOG)
  disable_package(VTK)
  disable_package(YAML_CPP)
else()
  if(COVERAGE)
    disable_package(GOOGLE_STYLEGUIDE)
  endif()

  if(MEMCHECK)
    disable_package(DIRECTOR)
    disable_package(GOOGLE_STYLEGUIDE)
  endif()

  if(MEMCHECK STREQUAL "msan" OR COMPILER STREQUAL "scan-build")
    disable_package(IPOPT)
  endif()

  if(NOT OPEN_SOURCE)
    if(APPLE)
      set(DASHBOARD_GUROBI_DISTRO "$ENV{HOME}/gurobi7.0.2_mac64.pkg")
    else()
      set(DASHBOARD_GUROBI_DISTRO "$ENV{HOME}/gurobi7.0.2_linux64.tar.gz")
    endif()

    if(EXISTS "${DASHBOARD_GUROBI_DISTRO}")
      enable_package(GUROBI)
      set(ENV{GUROBI_DISTRO} "${DASHBOARD_GUROBI_DISTRO}")
    else()
      message(WARNING "*** GUROBI_DISTRO was not found")
    endif()

    enable_package(MOSEK)
    enable_package(SNOPT)
  endif()

  if(MATLAB)
    if(APPLE)
      disable_package(IPOPT)
    endif()

    disable_package(DIRECTOR)
    disable_package(GOOGLE_STYLEGUIDE)
  endif()

  if(MEMCHECK MATCHES "^(asan|lsan|msan|tsan|ubsan)$")
    disable_package(LIBBOT)
  endif()
endif()

foreach(_package ${DASHBOARD_PACKAGES})
  cache_append(WITH_${_package} BOOL ${DASHBOARD_WITH_${_package}})
endforeach()

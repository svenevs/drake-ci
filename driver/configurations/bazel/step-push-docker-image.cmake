# -*- mode: cmake; -*-
# vi: set ft=cmake:

# BSD 3-Clause License
#
# Copyright (c) 2019, Massachusetts Institute of Technology.
# Copyright (c) 2019, Toyota Research Institute.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if(DASHBOARD_FAILURE OR DASHBOARD_UNSTABLE)
  notice("CTest Status: NOT PUSHING DOCKER IMAGE BECAUSE BAZEL BUILD WAS NOT SUCCESSFUL")
else()
  notice("CTest Status: PUSHING DOCKER IMAGE")

  if(NOT DASHBOARD_UNSTABLE)
    set(DOCKER_LOGIN_ARGS "login --username $ENV{DOCKER_USERNAME} --password-stdin")
    separate_arguments(DOCKER_LOGIN_ARGS_LIST UNIX_COMMAND "${DOCKER_LOGIN_ARGS}")
    execute_process(COMMAND "sudo" "${DASHBOARD_DOCKER_COMMAND}" ${DOCKER_LOGIN_ARGS_LIST}
      RESULT_VARIABLE DOCKER_LOGIN_RESULT_VARIABLE
      INPUT_FILE "$ENV{DOCKER_PASSWORD_FILE}"
      COMMAND_ECHO STDERR)
    if(NOT DOCKER_LOGIN_RESULT_VARIABLE EQUAL 0)
      append_step_status("BAZEL PUSHING DOCKER IMAGE (DOCKER LOGIN)" UNSTABLE)
    endif()
  endif()

  if(NOT DASHBOARD_UNSTABLE)
    set(DOCKER_PUSH_IMAGE_DISTRIBUTION_DATE_ARGS "push robotlocomotion/drake:${DASHBOARD_UNIX_DISTRIBUTION_CODE_NAME}-${DATE}")
    separate_arguments(DOCKER_PUSH_IMAGE_DISTRIBUTION_DATE_ARGS_LIST UNIX_COMMAND "${DOCKER_PUSH_IMAGE_DISTRIBUTION_DATE_ARGS}")
    foreach(RETRIES RANGE 3)
      execute_process(COMMAND "sudo" "${DASHBOARD_DOCKER_COMMAND}" ${DOCKER_PUSH_IMAGE_DISTRIBUTION_DATE_ARGS_LIST}
        RESULT_VARIABLE DOCKER_PUSH_IMAGE_DISTRIBUTION_DATE_RESULT_VARIABLE
        COMMAND_ECHO STDERR)
      if(DOCKER_PUSH_IMAGE_DISTRIBUTION_DATE_RESULT_VARIABLE EQUAL 0)
        break()
      endif()
      sleep(15)
    endforeach()
    if(NOT DOCKER_PUSH_IMAGE_DISTRIBUTION_DATE_RESULT_VARIABLE EQUAL 0)
      append_step_status("BAZEL PUSHING DOCKER IMAGE (ROBOTLOCOMOTION/DRAKE:${DASHBOARD_UNIX_DISTRIBUTION_CODE_NAME}-${DATE})" UNSTABLE)
    endif()
  endif()

  if(NOT DASHBOARD_UNSTABLE)
    set(DOCKER_PUSH_IMAGE_DISTRIBUTION_ARGS "push robotlocomotion/drake:${DASHBOARD_UNIX_DISTRIBUTION_CODE_NAME}")
    separate_arguments(DOCKER_PUSH_IMAGE_DISTRIBUTION_ARGS_LIST UNIX_COMMAND "${DOCKER_PUSH_IMAGE_DISTRIBUTION_ARGS}")
    foreach(RETRIES RANGE 3)
      execute_process(COMMAND "sudo" "${DASHBOARD_DOCKER_COMMAND}" ${DOCKER_PUSH_IMAGE_DISTRIBUTION_ARGS_LIST}
        RESULT_VARIABLE DOCKER_PUSH_IMAGE_DISTRIBUTION_RESULT_VARIABLE
        COMMAND_ECHO STDERR)
      if(DOCKER_PUSH_IMAGE_DISTRIBUTION_RESULT_VARIABLE EQUAL 0)
        break()
      endif()
      sleep(15)
    endforeach()
    if(NOT DOCKER_PUSH_IMAGE_DISTRIBUTION_RESULT_VARIABLE EQUAL 0)
      append_step_status("BAZEL PUSHING DOCKER IMAGE (ROBOTLOCOMOTION/DRAKE:${DASHBOARD_UNIX_DISTRIBUTION_CODE_NAME})" UNSTABLE)
    endif()
  endif()

  if(DASHBOARD_UNIX_DISTRIBUTION_CODE_NAME STREQUAL "bionic")
    if(NOT DASHBOARD_UNSTABLE)
      set(DOCKER_PUSH_IMAGE_DATE_ARGS "push robotlocomotion/drake:${DATE}")
      separate_arguments(DOCKER_PUSH_IMAGE_DATE_ARGS_LIST UNIX_COMMAND "${DOCKER_PUSH_IMAGE_DATE_ARGS}")
      foreach(RETRIES RANGE 3)
        execute_process(COMMAND "sudo" "${DASHBOARD_DOCKER_COMMAND}" ${DOCKER_PUSH_IMAGE_DATE_ARGS_LIST}
          RESULT_VARIABLE DOCKER_PUSH_IMAGE_DATE_RESULT_VARIABLE
          COMMAND_ECHO STDERR)
        if(DOCKER_PUSH_IMAGE_DATE_RESULT_VARIABLE EQUAL 0)
          break()
        endif()
        sleep(15)
      endforeach()
      if(NOT DOCKER_PUSH_IMAGE_DATE_RESULT_VARIABLE EQUAL 0)
        append_step_status("BAZEL PUSHING DOCKER IMAGE (ROBOTLOCOMOTION/DRAKE:${DATE})" UNSTABLE)
      endif()
    endif()

    if(NOT DASHBOARD_UNSTABLE)
      set(DOCKER_PUSH_IMAGE_LATEST_ARGS "push robotlocomotion/drake:latest")
      separate_arguments(DOCKER_PUSH_IMAGE_LATEST_ARGS_LIST UNIX_COMMAND "${DOCKER_PUSH_IMAGE_LATEST_ARGS}")
      foreach(RETRIES RANGE 3)
        execute_process(COMMAND "sudo" "${DASHBOARD_DOCKER_COMMAND}" ${DOCKER_PUSH_IMAGE_LATEST_ARGS_LIST}
          RESULT_VARIABLE DOCKER_PUSH_IMAGE_LATEST_RESULT_VARIABLE
          COMMAND_ECHO STDERR)
        if(DOCKER_PUSH_IMAGE_LATEST_RESULT_VARIABLE EQUAL 0)
          break()
        endif()
        sleep(15)
      endforeach()
      if(NOT DOCKER_PUSH_IMAGE_LATEST_RESULT_VARIABLE EQUAL 0)
        append_step_status("BAZEL PUSHING DOCKER IMAGE (ROBOTLOCOMOTION/DRAKE:LATEST)" UNSTABLE)
      endif()
    endif()
  endif()
endif()

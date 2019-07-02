if(DASHBOARD_FAILURE OR DASHBOARD_UNSTABLE)
  notice("CTest Status: NOT MIRRORING TO S3 BECAUSE BAZEL BUILD WAS NOT SUCCESSFUL")
else()
  notice("CTest Status: MIRRORING TO S3")
  execute_process(COMMAND "bazel-bin/tools/workspace/mirror_to_s3"
    WORKING_DIRECTORY "${CTEST_SOURCE_DIRECTORY}"
    RESULT_VARIABLE MIRROR_TO_S3_RESULT_VARIABLE)
  if(NOT MIRROR_TO_S3_RESULT_VARIABLE EQUAL 0)
    append_step_status("BAZEL MIRRORING TO S3" UNSTABLE)
  endif()
endif()
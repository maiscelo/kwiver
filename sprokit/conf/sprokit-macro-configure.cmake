# Configure functions for the sprokit project
# The following functions are defined:
#
#   sprokit_configure_file
#   sprokit_configure_directory
#
# The following variables may be used to control the behavior of the functions:
#
#   sprokit_configure_extra_dests
#     A list of other paths to configure the file into.
#
#   sprokit_configure_cmake_args
#     Extra arguments to pass to CMake when running the generated script.
#
# Their syntax is:
#
#   sprokit_configure_file(name source dest [variable ...])
#     The first argument is the name of the file being configured. The
#     next two parameters are the source and destination paths of the file to
#     be configured. Any variables that need to be replaced in the file
#     should be passed as extra arguments. The file will be added to the
#     list of files to be cleaned.
#
#   sprokit_configure_directory(name sourcedir destdir)
#     Configures an entire directory from ${sourcedir} into ${destdir}. Add
#     a dependency on the configure-${name} to ensure that it is complete
#     before another target.

if ( NOT TARGET configure)
  add_custom_target(configure ALL)
endif()

function (int_sprokit_configure_file name source dest)
  file(WRITE "${configure_script}"
    "# Configure script for \"${source}\" -> \"${dest}\"\n")

  foreach (arg IN LISTS ARGN)
    file(APPEND "${configure_script}"
      "set(${arg} \"${${arg}}\")\n")
  endforeach ()

  file(APPEND "${configure_script}" "${configure_code}")

  file(APPEND "${configure_script}" "
configure_file(
  \"${source}\"
  \"${configured_path}\"
  @ONLY)\n")

  file(APPEND "${configure_script}" "
configure_file(
  \"${configured_path}\"
  \"${dest}\"
  COPYONLY)\n")

  foreach (extra_dest IN LISTS sprokit_configure_extra_dests)
    file(APPEND "${configure_script}" "
configure_file(
  \"${configured_path}\"
  \"${extra_dest}\"
  COPYONLY)\n")
  endforeach ()

  set(clean_files
    "${dest}"
    ${sprokit_configure_extra_dests}
    "${configured_path}"
    "${configure_script}")

  set_directory_properties(
    PROPERTIES
      ADDITIONAL_MAKE_CLEAN_FILES "${clean_files}")
endfunction ()

function (sprokit_configure_file name source dest)
  set(configure_script   "${CMAKE_CURRENT_BINARY_DIR}/configure.${name}.cmake")
  set(configured_path    "${configure_script}.output")

  int_sprokit_configure_file(${name} "${source}" "${dest}" ${ARGN})

  add_custom_command(
    OUTPUT  "${dest}"
            ${extra_output}
    COMMAND "${CMAKE_COMMAND}"
            ${sprokit_configure_cmake_args}
            -P "${configure_script}"
    MAIN_DEPENDENCY
            "${source}"
    DEPENDS "${source}"
            "${configure_script}"
    WORKING_DIRECTORY
            "${CMAKE_CURRENT_BINARY_DIR}"
    COMMENT "Configuring ${name} file \"${source}\" -> \"${dest}\"")

  if (NOT no_configure_target)
    add_custom_target(configure-${name} ${all}
      DEPENDS "${dest}"
      SOURCES "${source}")
    source_group("Configured Files"
      FILES "${source}")
    add_dependencies(configure
      configure-${name})
  endif ()
endfunction ()

function (sprokit_configure_file_always name source dest)
  set(extra_output
    "${dest}.noexist")

  sprokit_configure_file(${name} "${source}" "${dest}" ${ARGN})
endfunction ()

function (sprokit_configure_directory name sourcedir destdir)
  set(no_configure_target TRUE)

  file(GLOB_RECURSE sources
    RELATIVE "${sourcedir}"
    "${sourcedir}/*")

  set(count 0)
  set(source_paths)
  set(dest_paths)

  foreach (source IN LISTS sources)
    set(source_path
      "${sourcedir}/${source}")
    set(dest_path
      "${destdir}/${source}")

    sprokit_configure_file(${name}-${count}
      "${source_path}"
      "${dest_path}")

    list(APPEND source_paths
      "${source_path}")
    list(APPEND dest_paths
      "${dest_path}")

    math(EXPR count "${count} + 1")
  endforeach ()

  add_custom_target(configure-${name} ${all}
    DEPENDS ${dest_paths}
    SOURCES ${source_paths})
  add_dependencies(configure
    configure-${name})
endfunction ()

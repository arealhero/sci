if (NOT COMMAND sci_latex)
  function(sci_latex target_name)
    list(APPEND SCI_LATEX_COMMAND ${SOURCES})

    if (DEFINED BIBLATEX_FILES)
      list(APPEND SCI_LATEX_COMMAND BIBFILES ${BIBLATEX_FILES} USE_BIBLATEX)
    else()
      file(REAL_PATH "~/data/references.bib" DEFAULT_BIBFILE EXPAND_TILDE)
      list(APPEND SCI_LATEX_COMMAND BIBFILES ${DEFAULT_BIBFILE} USE_BIBLATEX BIBFILE_ABSOLUTE)
    endif()

    if (DEFINED IMAGE_DIRS)
      list(APPEND SCI_LATEX_COMMAND IMAGE_DIRS ${IMAGE_DIRS})
    endif()

    add_latex_document(${SCI_LATEX_COMMAND})
  endfunction()
endif()

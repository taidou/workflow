(TeX-add-style-hook
 "machinelearning"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("ctexart" "11pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("ulem" "normalem") ("hyperref" "colorlinks" "linkcolor=black" "anchorcolor=black" "citecolor=black") ("youngtab" "vcentermath")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "ctexart"
    "ctexart11"
    "inputenc"
    "fontenc"
    "fixltx2e"
    "graphicx"
    "longtable"
    "float"
    "wrapfig"
    "rotating"
    "ulem"
    "amsmath"
    "textcomp"
    "marvosym"
    "wasysym"
    "amssymb"
    "booktabs"
    "hyperref"
    "listings"
    "xcolor"
    "youngtab"
    "braket"
    "mathrsfs"
    "txfonts")
   (TeX-add-symbols
    '("relphantom" 1)
    '("bm" 1)
    "ve"
    "tve"
    "vf"
    "yvf"
    "bfE")
   (LaTeX-add-labels
    "sec:orgheadline1"
    "sec:orgheadline11"
    "sec:orgheadline2"
    "sec:orgheadline10"
    "sec:orgheadline5"
    "sec:orgheadline3"
    "sec:orgheadline4"
    "sec:orgheadline9"
    "sec:orgheadline6"
    "sec:orgheadline7"
    "sec:orgheadline8"
    "sec:orgheadline32"
    "sec:orgheadline15"
    "sec:orgheadline12"
    "sec:orgheadline13"
    "sec:orgheadline14"
    "sec:orgheadline19"
    "sec:orgheadline18"
    "sec:orgheadline16"
    "sec:orgheadline17"
    "sec:orgheadline31"
    "sec:orgheadline27"
    "sec:orgheadline20"
    "sec:orgheadline21"
    "sec:orgheadline22"
    "sec:orgheadline23"
    "sec:orgheadline26"
    "sec:orgheadline24"
    "sec:orgheadline25"
    "sec:orgheadline28"
    "sec:orgheadline29"
    "sec:orgheadline30"
    "sec:orgheadline46"
    "sec:orgheadline38"
    "sec:orgheadline33"
    "sec:orgheadline34"
    "sec:orgheadline37"
    "sec:orgheadline35"
    "sec:orgheadline36"
    "sec:orgheadline45"
    "sec:orgheadline41"
    "sec:orgheadline39"
    "sec:orgheadline40"
    "sec:orgheadline44"
    "sec:orgheadline42"
    "sec:orgheadline43"
    "sec:orgheadline66"
    "sec:orgheadline56"
    "sec:orgheadline47"
    "sec:orgheadline55"
    "sec:orgheadline48"
    "sec:orgheadline49"
    "sec:orgheadline50"
    "sec:orgheadline51"
    "sec:orgheadline52"
    "sec:orgheadline53"
    "sec:orgheadline54"
    "sec:orgheadline65"
    "sec:orgheadline59"
    "sec:orgheadline57"
    "sec:orgheadline58"
    "sec:orgheadline64"
    "sec:orgheadline62"
    "sec:orgheadline60"
    "sec:orgheadline61"
    "sec:orgheadline63"
    "sec:orgheadline80"
    "sec:orgheadline79"
    "sec:orgheadline67"
    "sec:orgheadline78"
    "sec:orgheadline68"
    "sec:orgheadline69"
    "sec:orgheadline71"
    "sec:orgheadline70"
    "sec:orgheadline72"
    "sec:orgheadline76"
    "sec:orgheadline73"
    "sec:orgheadline74"
    "sec:orgheadline75"
    "sec:orgheadline77")
   (LaTeX-add-environments
    "sequation"
    "tequation"))
 :latex)


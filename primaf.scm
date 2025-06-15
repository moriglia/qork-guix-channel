(define-module (primaf)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (gnu packages gcc))

(define-public libprimaf
  (package
   (name "libprimaf")
   (version "0.7.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/libprima/prima.git")
           (commit (string-append "v" version))))
     (sha256
      (base32
       "1mcw5g2sj84j52300c2v8dlrzi6gmdyzddhi7g7k7kxg2ihwp5r5"))))
   (build-system cmake-build-system)
   (arguments
    `(#:tests? #f
      #:configure-flags
      '("-DCMAKE_INSTALL_LIBDIR=lib"
	"-DCMAKE_INSTALL_INCLUDEDIR=include")))
   (inputs
    `(("gfortran-toolchain" ,gfortran)))
   (synopsis "PRIMA: Reference Implementation for Powell's Methods with Modernization and Amelioration")
   (description
    "PRIMA is a package for solving general nonlinear optimization problems without using derivatives. It provides the reference implementation for Powell's renowned derivative-free optimization methods, i.e., COBYLA, UOBYQA, NEWUOA, BOBYQA, and LINCOA. The \"P\" in the name stands for Powell, and \"RIMA\" is an acronym for \"Reference Implementation with Modernization and Amelioration\".")
   (home-page "https://www.libprima.net")
   (license bsd-3)))

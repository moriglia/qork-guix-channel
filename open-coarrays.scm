(define-module (open-coarrays)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages mpi))

(define-public open-coarrays
  (package
   (name "open-coarrays")
   (version "2.10.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/sourceryinstitute/OpenCoarrays.git")
           (commit version)))
     (sha256
      (base32
       "1qcbqmj1kpd8lhjva6sb7250rhjw4s6ly553gssic2zc6w1zzmg7"))))
   (build-system cmake-build-system)
   (arguments
    `(#:tests? #f))
   (inputs
    `(("gfortran-toolchain" ,gfortran)
      ("mpi" ,openmpi)))
   (synopsis "Open Coarrays library")
   (description
    "OpenCoarrays is an open-source software project that produces an application
binary interface (ABI) used by the GNU Compiler Collection (GCC) Fortran
front-end to build executable programs that leverage the parallel programming
features of Fortran 2018.")
   (home-page "https://www.opencoarrays.org")
   (license bsd-3)))

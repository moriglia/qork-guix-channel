(define-module (fortran-utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix licenses)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix profiles)
  #:use-module (guix-hpc packages toolchains))


(define-public fortran-fpm
  (package
   (name "fortran-fpm")
   (version "0.12.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/fortran-lang/fpm.git")
           (commit (string-append "v" version))))
     (sha256
      (base32
       "1lvmf8w3wfqyvv1r4jsslq58j2b35gfffyz605vfsapkcr8jzwc0"))))
   (build-system copy-build-system)
   (arguments
    (list
     #:phases
     #~(modify-phases
	%standard-phases
	(add-after 'patch-generated-file-shebangs 'build
		   (lambda* (#:key #:allow-other-keys)
			    (let* ((source (assoc-ref %build-inputs "source"))
				   (build-dir (string-append source "/../build"))
				   (bootstrap-dir
				    (string-append build-dir "/bootstrap"))
				   (fpm-bootstrap-file
				    #$(this-package-input "bootstrap"))
				   (out (assoc-ref %outputs "out")))
			      (mkdir-p bootstrap-dir)
			      (invoke "gfortran"
				      "-J" bootstrap-dir
				      "-o" (string-append bootstrap-dir "/fpm")
				      fpm-bootstrap-file)
			      (invoke (string-append bootstrap-dir "/fpm")
				      "install"
				      "--prefix" out))))
	(add-before
	 'build 'patch-fpm-toml
	 (lambda* (#:key inputs #:allow-other-keys)
		  (use-modules (ice-9 textual-ports) (srfi srfi-1))
		  (let* ((deps-dir "local-deps")
			 (deps `(("toml-f" . "toml-f")
				 ("M_CLI2" . "M_CLI2")
				 ("fortran-regex" . "fortran-regex")
				 ("jonquil" . "jonquil")
				 ("fortran-shlex" . "fortran-shlex"))))
		    (mkdir-p deps-dir)
		    ;; Symlink each dependency into local-deps/
		    (for-each
		     (lambda (dep)
		       (let* ((name (car dep))
			      (dir (assoc-ref inputs name)))
			 (symlink dir (string-append deps-dir "/" (cdr dep)))))
		     deps)
		    (substitute*
		     "fpm.toml"
		     (("toml-f\\.git.*")
		      (string-append "toml-f.path = \"" deps-dir "/toml-f\"\n"))
		     (("M_CLI2\\.git.*")
		      (string-append "M_CLI2.path = \"" deps-dir "/M_CLI2\"\n"))
		     (("fortran-regex\\.git.*")
		      (string-append "fortran-regex.path = \"" deps-dir "/fortran-regex\"\n"))
		     (("jonquil\\.git.*")
		      (string-append "jonquil.path = \"" deps-dir "/jonquil\"\n"))
		     (("fortran-shlex\\.git.*")
		      (string-append "fortran-shlex.path = \"" deps-dir "/fortran-shlex\"\n"))
		     (("^.*\\.rev.*") "")
		     (("^.*\\.tag.*") "")
		     )))
	 )
	(delete 'install)
	)
     )
    )
   (inputs
    `(("gfortran-toolchain" ,gfortran-toolchain-14)
      ("bootstrap"
       ,(origin
	 (method url-fetch)
	 (uri "https://github.com/fortran-lang/fpm/releases/download/v0.12.0/fpm-0.12.0.F90")
	 (sha256
	  (base32
	   "1ba627954qzw8kbkafqrdvripf9l1mq17nqzr67qzsnq2347lmk1"))
	 (file-name "fpm.F90")))
      ;; ("git" ,git)
      ("toml-f"
       ,(origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/toml-f/toml-f")
	       (commit "d7b892b1d074b7cfc5d75c3e0eb36ebc1f7958c1")))
	 (sha256
	  (base32
	   "07r78dk0q7xxrh3fjfrsx5jmf6ap21b4d5qld6ga3awki0cm75z8"))))
      ("M_CLI2"
       ,(origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/urbanjost/M_CLI2.git")
	       (commit "7264878cdb1baff7323cc48596d829ccfe7751b8")))
	 (sha256
	  (base32
	   "06y7zndb0qcnyq7rxwhq0vv0j4dzkdw9hqphkp13k1zqf3vz8z28"))))
      ("fortran-regex"
       ,(origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/perazz/fortran-regex")
	       (commit "1.1.2")))
	 (sha256
	  (base32
	   "183vxa1082kkg48rl75nxkm8j67vxpak3347dfzfbbxi0wyfklba"))))
      ("jonquil"
       ,(origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/toml-f/jonquil")
	       (commit "4fbd4cf34d577c0fd25e32667ee9e41bf231ece8")))
	 (sha256
	  (base32
	   "1zk3rpl5npk4qaslcbp9nay6p9dsl3sqv2m0zc6337mxqa4dmjm0"))))
      ("fortran-shlex"
       ,(origin
	 (method git-fetch)
	 (uri (git-reference
	       (url "https://github.com/perazz/fortran-shlex")
	       (commit "2.0.0")))
	 (sha256
	  (base32
	   "0sygyjqwxyh974bmp8n5bxjs9nsdfavy5k3vhmx2v9bbl31jqk8a"))))
      ))
   (synopsis "Fortran Package Manager")
   (description
    "Fortran Package Manager (fpm) is a package manager and build system for Fortran.
Its key goal is to improve the user experience of Fortran programmers.
It does so by making it easier to build your Fortran program or library,
run the executables, tests, and examples, and distribute it as a dependency to other Fortran projects.
Fpm's user interface is modeled after Rust's Cargo, so if you're familiar with that tool,
you will feel at home with fpm.
Fpm's long term vision is to nurture and grow the ecosystem of modern Fortran applications and libraries.")
   (home-page "https://fpm.fortran-lang.org")
   (license expat)))

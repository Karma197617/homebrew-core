class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.19.0.tar.bz2"
  sha256 "cb58494dc415fba9eeb12b826550ad3190dc92e265c5bb2ae1a21c92841cfd38"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09eb6844769020807f538ccd6ff6fd916a2428e7cbe495eab1d20c751849304e"
    sha256 cellar: :any,                 arm64_monterey: "f2f1b75a4d35488bca401ca201d5c4f5a89a5acaa2bebe19a44fc802b5bc0bfc"
    sha256 cellar: :any,                 arm64_big_sur:  "bad5ec42359aa1170e1e533a9c498bc07520ecaf0572549c7b36e91dca1c9252"
    sha256 cellar: :any,                 ventura:        "d59f5b10eef0d6f07726d815abb2e3ff424616897c89feef05aa3266298a0155"
    sha256 cellar: :any,                 monterey:       "c58808e22d846af48572e08e85ea92d96a661dc44efb0ac065fe05f43f28cea0"
    sha256 cellar: :any,                 big_sur:        "80181351cad6da30c7068b48b446727185bf2ee8483418863a30e4ec379a1ce4"
    sha256 cellar: :any,                 catalina:       "b359235849a1eaa43513f81458eec55a2e166daa5e91d56d0f82ce789214d0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc50e268a85ec9b611c979a1e08108d985be0a51d02474011864afa1ab2ff79"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def python3
    "python3.11"
  end

  def install
    ENV["PYTHON"] = python3
    # HACK: Stop build from ignoring our PYTHON input. As python versions are
    # hardcoded, the Arch Linux patch that changed 3.9 to 3.10 can't detect 3.11
    inreplace "configure", /# Reset everything.*\n\s*unset PYTHON$/, ""

    # Uses generic lambdas.
    # error: 'auto' not allowed in lambda parameter
    ENV.append "CXXFLAGS", "-std=c++14"

    site_packages = prefix/Language::Python.site_packages(python3)
    ENV.append_path "PYTHONPATH", site_packages
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "lang/python/Makefile.in",
              /^\s*install\s*\\\n\s*--prefix "\$\(DESTDIR\)\$\(prefix\)"/,
              "\\0 --install-lib=#{site_packages}"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-static"
    system "make"
    system "make", "install"

    # Rename the `easy-install.pth` file to avoid `brew link` conflicts.
    site_packages.install site_packages/"easy-install.pth" => "homebrew-gpgme-#{version}.pth"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end

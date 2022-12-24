class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.54.9/faust-2.54.9.tar.gz"
  sha256 "29cfb88f87fd93a55620c18f58ec585a31b6f8106a9fd3528db8340048adef28"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "25aa7352bc2320116f1ebded5c7e14d7ebc9e38a222c1fe68615d493a8857d49"
    sha256 cellar: :any,                 arm64_monterey: "bbe2449e22fc66eaf4dbf90b7ccd220a9d65954c64ad51e8b178e0a7f3d3b471"
    sha256 cellar: :any,                 arm64_big_sur:  "79f18d935e081f08cfb64d708a4d72222c240e050c83d022ca8fcbcdf783f803"
    sha256 cellar: :any,                 ventura:        "007a5ff2fac21b759b938ad78733f1bb453b3fb5b524c64feee058fec18ea50d"
    sha256 cellar: :any,                 monterey:       "0524e9894187380c7e47599fe47fd7e8e7d43372953f50c7dd022adf20e654c1"
    sha256 cellar: :any,                 big_sur:        "3daa5ef4021cd4af1fcfb4678ca906abe0e2d8412ea8dda1478ef6b63829cfd3"
    sha256 cellar: :any,                 catalina:       "8ee8b5cbbd4c775ab37940545b67db3d8665753330b29eb26d60b8e9ec928ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5dc2b1de59bb4ed621bc2af343e3a7ad782781dbb5003fa7c60b10041ad7674"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@14" # Needs LLVM 14 for `csound`.

  fails_with gcc: "5"

  # upstream patch, https://github.com/grame-cncm/faust/pull/844
  patch do
    url "https://github.com/chenrui333/faust/commit/7a5e1c65c2d780ca371bf52af58ea0620c363343.patch?full_index=1"
    sha256 "ff54ab4ed23bc1886a3ceb5403782767ee83b51fc8bd37331493554224a95320"
  end

  def install
    ENV.delete "TMP" # don't override Makefile variable
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end

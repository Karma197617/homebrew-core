class Libprotoident < Formula
  desc "Network traffic classification library that requires minimal application payload"
  homepage "https://github.com/LibtraceTeam/libprotoident"
  url "https://github.com/LibtraceTeam/libprotoident/archive/refs/tags/2.0.15-1.tar.gz"
  sha256 "cfa7c2d8db8e701db9f991e4f58fd9a284db65e866194ad54e413202163b7289"
  license all_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d93974ec737d62f1b54f6aafeec74cccf2632954e81daa60043632e5446292f2"
    sha256 cellar: :any,                 arm64_big_sur:  "d0686f33c93e2853ca605f256486c9d8569b56b1538d0881b32fa4f0d7a49dfa"
    sha256 cellar: :any,                 monterey:       "94f6535531ea76727db897dd49009a111652cb1c47fa3a592515c71a97b1aebf"
    sha256 cellar: :any,                 big_sur:        "1928a4cc164177352292b8872fa6ed498247af16b1c25ffbf6cc80983e6ac43a"
    sha256 cellar: :any,                 catalina:       "7ea19cf1a0ae1423dcadebe59d08cd2c65433e4210a9e434e9d1e8dfce65abb0"
    sha256 cellar: :any,                 mojave:         "06f18aa299bc9b53991ac448d20d318625a3f1d55fe6bb093c45045b4accbb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24938f68759726bc0549a5388e71184d56795bfbaff25f9d341b5cd0f79bc9a0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libflowmanager"
  depends_on "libtrace"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end

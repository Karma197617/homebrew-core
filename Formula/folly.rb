class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.02.13.00.tar.gz"
  sha256 "4e22f4fd57728abb563cf6bbe260388819e0385dbecc02762c08b301f711bcee"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "abfdadf99c11bc0f414e7190a75f1f59c03d95ef876a5e5f0fb1f75987922907"
    sha256 cellar: :any,                 arm64_monterey: "677630687ff5a30002038f3a5a32542bfc25b6a0bd673f35097f66ad5ec26bb9"
    sha256 cellar: :any,                 arm64_big_sur:  "d6588e2ebc2a9cc5aa87647ab6f808bf38d304b977fddf9b767d6ead06d4f5c4"
    sha256 cellar: :any,                 ventura:        "0ef201ecc81fd59525e9c20b21c605e47d8062b403ca9c24ebf38ee3263f9a26"
    sha256 cellar: :any,                 monterey:       "6d2634a8fa8afecd7421e5588c70454e082a05411902db9700f7a37f045fcd66"
    sha256 cellar: :any,                 big_sur:        "c9f50908b3985938a6731066894fd1e284dcbcab6fa91461a3eca9cbcbbed670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4beaa6a3d21b692419652b85024bf8e3aa00f15a273542fbffe3ae9b83f9a8e2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = std_cmake_args + %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end

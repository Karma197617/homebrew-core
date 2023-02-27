class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.02.27.00.tar.gz"
  sha256 "7f9be37a69341c2ade447c4ee9e260808549cdfe1491c7fa77bcebf30158bd39"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4f1546a2ec4dece01f18176e4a87503ac0a7a6aacbab9f750b8bf23c24d07ac3"
    sha256 cellar: :any,                 arm64_monterey: "14ae35365f3752eb3580050f4a7eabb7992dc5cf3e167e6274aa6f2e9a1380d2"
    sha256 cellar: :any,                 arm64_big_sur:  "b00a6d81d4d019e4749bb79bb1cc933611fd7161276797d44be0945a7d65ad1b"
    sha256 cellar: :any,                 ventura:        "2bebe22155647790caf7cb81766250554f5e6bf46cbe1b7fdb5803626f6ee05b"
    sha256 cellar: :any,                 monterey:       "a26ce672150e41de3a0fc93a0d55171f0293a7e1174cb03e6638cb38f2ff8ee9"
    sha256 cellar: :any,                 big_sur:        "64e168e9a782ba09fbfa031e86701002ef98e0c99c699f29d31efcc910b49daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abac4dbc053ab9f315f2011813ed6b2d86da0dbf0db551a1b223240798186f46"
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

class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.02.27.00/fizz-v2023.02.27.00.tar.gz"
  sha256 "54d91581da093d70cc0baf2a391c0bd64b6015dc70c90c1111c2a4d40240f5f7"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8e6979cd4987572cf11af5a9224f03e13cbe9f6bcc4d9011318b917a41f8453"
    sha256 cellar: :any,                 arm64_monterey: "0dfd8f86bb1a9a36c426a38351c5ce84f7df27f0d183fe0a3f585390c58ea689"
    sha256 cellar: :any,                 arm64_big_sur:  "be29e4ae911339c9a51b0c65ab44969f40b146e68806eff1e98b0f9b7c172de3"
    sha256 cellar: :any,                 ventura:        "aa5ba996df3b4e49de2ce9fd5b85def2e77198ae45780d4fbd6ec36dfbc0c82a"
    sha256 cellar: :any,                 monterey:       "dc8a540e8102cf9f005fd943d411453c81a1b2318b5cd06899e3cb57ac13a2af"
    sha256 cellar: :any,                 big_sur:        "858e3d15901bb946317e3600d1fa70f175382bed6ef66ace0b8234278fb2f92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9680d931d21cfa3040d8098bc5a6d57ce5c7ab0320a818518f0719355458ea98"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end

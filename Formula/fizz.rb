class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2023.02.13.00/fizz-v2023.02.13.00.tar.gz"
  sha256 "34008f3d652aab98972c841d9173e4ab6a0fd5d4eb409ba229f1edcb28a92b0b"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d6dbc488c84798bfb63b27b9121d76ec52ac9ceb8f7a906565e93bb5413106c2"
    sha256 cellar: :any,                 arm64_monterey: "228e438ebe0467dc81c52510fb911885263304c7144868d0a3a69bb9793a467b"
    sha256 cellar: :any,                 arm64_big_sur:  "14ede08a704b3a37d1be3f2b6023c268e784d873adcb39e29715dfbd9bdac318"
    sha256 cellar: :any,                 ventura:        "47581725bed4da861051f881155b6597e5195de056bfff76b06cc374f98303f0"
    sha256 cellar: :any,                 monterey:       "99435a96ac38d4a356905dd9f61c974d1c47f73295973adcf9c043b823aa2bf2"
    sha256 cellar: :any,                 big_sur:        "04ae28df5fde6c25df4358cdb2555f9a8e5b01dfcd49872679ce6256cbed2678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b2f980f732110b78614bcddcae8d6110dc97705a5e0d6cffe3be7c4a1b9517e"
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

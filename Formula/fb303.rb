class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.02.13.00.tar.gz"
  sha256 "0d863cd056047044a0309651ec685a7d5f4ea14d9271a9f5401b3cce6568ca7b"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b5fdca11ce6fba3eda0681195df2385215c332a96e840ce889e6a92d75177d5"
    sha256 cellar: :any,                 arm64_monterey: "1403d30ac1fd611ead897a233a78fe807ada26ca7992165c1bc7cf2c75c1e238"
    sha256 cellar: :any,                 arm64_big_sur:  "6dbd1292fd6ad148fa5634161e7b3107cfcb3d763cad1f027127a80459cf9ced"
    sha256 cellar: :any,                 ventura:        "7b182d511f0c29c71587549707a570eecc76b5bc8b351e9c65d002d9d9e7bad3"
    sha256 cellar: :any,                 monterey:       "2e831ddd9dac5372dd43443fe5051fe65f309e070b4b47cdd0aa916db20b9844"
    sha256 cellar: :any,                 big_sur:        "459d6bc9c9ac1657047843c239e4770b894af78d44017d1cbe4505ee7b9b3ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "863cefc020692403456ea7881a0776e6c2bb14650de74d7c0336448698478fe5"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end

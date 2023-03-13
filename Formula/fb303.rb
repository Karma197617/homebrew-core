class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.03.13.00.tar.gz"
  sha256 "3620828e3623ba16ec5dad93d7367719927d978268ba8fd979a865f29351c732"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "304a11d93dcf8c90927b77392bb42dee63c3b1758dc6870bf649f6943351cf77"
    sha256 cellar: :any,                 arm64_monterey: "eabde5bbcb8f80ce6aa042660934ad3b518130806c1ce97e1ad3d14b0dd01cdb"
    sha256 cellar: :any,                 arm64_big_sur:  "bba346ef9bbaab125b6a7957bee3568c749fa89856ec02e74264762c70b78757"
    sha256 cellar: :any,                 ventura:        "937bac864d5896f0e89dd63d712a24ff08710694f118f29e4dd18dc086983324"
    sha256 cellar: :any,                 monterey:       "ddc65c323d02496d5f0b59b9e53acd8b53e12c2516e3abec078ae088b14c87b5"
    sha256 cellar: :any,                 big_sur:        "ead80bfa5fd0d09ea8d97f613e16eb36df2d723b6169a41cfba8778f7ddeea8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0bf03e0f3d9dce41076fdceddd9fe2652067f1672f67bcb6827d4c1a945998f"
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

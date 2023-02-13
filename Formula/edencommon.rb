class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.02.13.00.tar.gz"
  sha256 "337983c496036f910b4cbe54f32887889871398cc0b9ec7a04678b80bed2f302"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b5c46c7f7c4f1ecf4111ebf4eca2dcac66af8ed76370128c324c60239bf5955"
    sha256 cellar: :any,                 arm64_monterey: "c73a322275b4da7cadd25e0476687a02f932e4c2da46fbc78b84b4b29170d6c5"
    sha256 cellar: :any,                 arm64_big_sur:  "ea39e3d0939273af6d1ddc1b3932d666e77f65697a121e5de8ad879a36f45c30"
    sha256 cellar: :any,                 ventura:        "efdc4cb288effb3eaaaa2f664e15218174567bb94d62058d0b9dd7c85d993acc"
    sha256 cellar: :any,                 monterey:       "828bacb67fadedc393cce1ac2534893642872e5f8c5970786a43d6f7a13407c6"
    sha256 cellar: :any,                 big_sur:        "c6a72b33be8b392833a9e0b952ca72c19e190200860497252d9b800929a1342e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae6869f0b87cfc1c5349646bb80fc0146230b50ccd0fa6d41d10750b4af18ed9"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessNameCache.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      ProcessNameCache& getProcessNameCache() {
        static auto* pnc = new ProcessNameCache;
        return *pnc;
      }

      ProcessNameHandle lookupProcessName(pid_t pid) {
        return getProcessNameCache().lookup(pid);
      }

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << lookupProcessName(pid).get() << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end

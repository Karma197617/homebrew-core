class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.02.27.00.tar.gz"
  sha256 "4737eb2266ffc7ebfeb9561ee0753baff14c91c5f459056761764a89c8f1ab8f"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d69b8a78d228b041c9021ab71704b7c54632d87e3ea97ac925df069b47ab2d0"
    sha256 cellar: :any,                 arm64_monterey: "8991f06b43bef0f79dfdab5f9adb9593af6761d4abd6d6a68c7ae481a5f628fe"
    sha256 cellar: :any,                 arm64_big_sur:  "992b4cd5d1580c83ab79c11589734f9093aec248291c4d82bc381e7bff20a190"
    sha256 cellar: :any,                 ventura:        "6d3306c7a1bf8d3471c425567e9567306363d4d004a745f2ab28d01e3a41e583"
    sha256 cellar: :any,                 monterey:       "b327c61b44c04bda2597df3f91c18d2a3fd9b79cab7fb65b3b99eb482a37ea7f"
    sha256 cellar: :any,                 big_sur:        "ad168038606f09ce803b98404b76b7f39d4a410b96ac7b60d80fa188a06aae47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421538ad98bf8abbaa38009d4bb19f049e23051d95cc488884a54ddb3364d630"
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

class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2023.02.13.00.tar.gz"
  sha256 "767e513520afd4aa02fbb57696f50909a25bcdfa09f09bed098f7216dee7cf5e"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f815cbfad627052e3d1b4db27d33ae0350e8ea5e82fd0b441ab55b77d7f06491"
    sha256 cellar: :any,                 arm64_monterey: "054942f79270c676ea907ef6266cb1f9377e8f6f0bf5dfcbb8c60f03db5bec83"
    sha256 cellar: :any,                 arm64_big_sur:  "dea0d86d9b24cd9f49263ade47039db8b08758b87955a4e51ad8fea10def97cf"
    sha256 cellar: :any,                 ventura:        "be06b393782452ce629731a57f38f07d523227a10e857900776b5337924ced07"
    sha256 cellar: :any,                 monterey:       "5ffd15a4b0e7670fd81cfd278edf78f010c17b932001bdaf411c0269b233b84f"
    sha256 cellar: :any,                 big_sur:        "2fa49ad97e661d413b1ec8af77674d0f422f2ede0f1489db454d1410e664130f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7767c00be71334e450438219da5219081bf666bbb7b36473b3d7f07b103299a"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end

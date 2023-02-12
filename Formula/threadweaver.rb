class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.103/threadweaver-5.103.0.tar.xz"
  sha256 "29bc53a18974758b6af9ab055a148c170b4f8f2e0d7f5be0fa31fb513a47ec82"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19927092be9d896bdf8b8d99043dea8ae80b7e4a32a6411b91d1777fd0d21edf"
    sha256 cellar: :any,                 arm64_monterey: "ee2e34899e0a132c3f85126cccd9cd6699354a0375643f593aa69fb42f70c362"
    sha256 cellar: :any,                 arm64_big_sur:  "887638aaa1953e8ca05fa1dc352a860d7aed9c657e8f5552cb4172af1e4f561f"
    sha256 cellar: :any,                 ventura:        "26c8fa268660abfe7824e38bb0a7e4972d701f1263332d76eecdbe99f7371579"
    sha256 cellar: :any,                 monterey:       "5fdc81baa6268207c01ea5a5be9daa639dbbc31fa26fd9afb36140e4ec21a40c"
    sha256 cellar: :any,                 big_sur:        "eed8eb6445feac22f3359d962699e3b05fd3e5b2bbc7e6ee8b12fc53c1261f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6b6c82d2c9d33d451b4aec0ff042b586e8dbee41f07af0d74cf7101921619f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    qt5_args = ["-DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core"]
    qt5_args << "-DCMAKE_BUILD_RPATH=#{Formula["qt@5"].opt_lib};#{lib}" if OS.linux?
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, *qt5_args
    system "cmake", "--build", "."

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end

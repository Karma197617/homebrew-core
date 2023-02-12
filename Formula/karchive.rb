class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.103/karchive-5.103.0.tar.xz"
  sha256 "372bdf691ddc43e663b5c6ca88b2c73fa0fac9ee8e3600b469f9b026c8dd1353"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a58cda68a107dbc7718422b2f8b9748f1666b11671a0e6b3a324102cd80ba144"
    sha256 cellar: :any,                 arm64_monterey: "308bc7eba9baaacc65e8caae43ef48dd7e074f2ca9b14b5553e4ea9fd986b401"
    sha256 cellar: :any,                 arm64_big_sur:  "08b47c886cbf3bf4ce360d89c43bc4c615af8b65394eee6168053686b4a34de9"
    sha256 cellar: :any,                 ventura:        "bec44f40821d366d8a677f28f7897e0886e067ab2d5b57fdbf1ebb63236ae324"
    sha256 cellar: :any,                 monterey:       "c2ce6bae672b782478ebf112d92077ba5ab2fc775678b935160b492a6a2faf09"
    sha256 cellar: :any,                 big_sur:        "698bead904b2ab0d1928cb7bebfb280938102238a703d4a9d23097621e64f6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c82ff3359e86ed21eba6b952ffa0b89bcec7a2f02ab6654cf1e7c7dca34f6cb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "cmake", "--build", "."
      end
    end

    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end

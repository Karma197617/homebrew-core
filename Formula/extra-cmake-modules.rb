class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.103/extra-cmake-modules-5.103.0.tar.xz"
  sha256 "92ca2e55cb38956fbdeaf254231f074647173ccfd12dc9664989c6fa9e9c4346"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bab15598b622fd6cf76176a2969e8d1da7d37bbfe22bc28d303f0b760a96083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bab15598b622fd6cf76176a2969e8d1da7d37bbfe22bc28d303f0b760a96083"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68e8191278862a0ec928df1934da8552523ffa9b3f31b4ab8981ae4e8d5e82dc"
    sha256 cellar: :any_skip_relocation, ventura:        "352808117c68233ff8d08d9cd3aee8a5306ef189c2094a087a2068ae7de6c85e"
    sha256 cellar: :any_skip_relocation, monterey:       "352808117c68233ff8d08d9cd3aee8a5306ef189c2094a087a2068ae7de6c85e"
    sha256 cellar: :any_skip_relocation, big_sur:        "352808117c68233ff8d08d9cd3aee8a5306ef189c2094a087a2068ae7de6c85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e990ddb9cabb49b8cfabfdbc8fdd701df01c2a08dbf7b6b3acd525bba8627b9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"

    expected="ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, File.read(testpath/"CMakeCache.txt")
  end
end

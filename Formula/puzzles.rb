class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230215.7364ce8.tar.gz"
  version "20230215"
  sha256 "2136872262af9ded76117c63b656ebd8a96decafbfa0601fa5332b8c560894e1"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12c92c94cac92f20213a8cfc4e1f2b7f2de0bad0b547923ad22301e9e0dea4c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d5fe01ee240eaf2b2ece1a4fdba9c627e134c41c5c7f46e16f9cd8b34dd6aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2853f19142c413643d13b5595dc0bf7a3ec9d6772be3b8d166c6e7a2f566cad"
    sha256 cellar: :any_skip_relocation, ventura:        "cc3f41c41aaffcf197f7b87ec91c20d65e119dd622d5deb13ea984d9ca69bedc"
    sha256 cellar: :any_skip_relocation, monterey:       "cfcc101f8cb0f43f8c29b06bf7647339577dc633e1ba22da36ca6376c50c5543"
    sha256 cellar: :any_skip_relocation, big_sur:        "54e85d3cb4a25756aaa73b19abbdb0a4ad18bda80c8ae1d35127e25e3fccfa7b"
    sha256                               x86_64_linux:   "2b3f7b9c75901db74f71a72d4071a6b6c0f1938ec3ba78bfba381e8f83d6737d"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end

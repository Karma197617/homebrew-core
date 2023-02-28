class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230227.5a491c5.tar.gz"
  version "20230227"
  sha256 "2bee57a5bf13b13fb4f2d8a29ea231a4bb91186181020af5e429bffecc37f810"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "363baf242eaf8cdeb7c405e7689d02b78397fe1ce2b76774615d4f22fe18659b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f70c9fdcb9c34ce13ed8bdcb729271d11a6ca5eebb6a5f5d3bcb4d53d415bb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6778de9b33cf55c8c2aa63f138f0f7f0f3e12d3b707a274d647c0fccd77810fe"
    sha256 cellar: :any_skip_relocation, ventura:        "4a415b007bb2de3c4f169c92dba596b4286466fd45f7cd6468cc8c0dd40945b0"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ffcb43c5072c1e1ccc61438fa7268e802954ab435664e51f4365df59f43d99"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff5152bfbc0e89e7e0beae78452269f7715bb568a0eb834929365a0993d221ca"
    sha256                               x86_64_linux:   "34f54c8bf6707aa6e52ca2c24bb707031651c886ab6676467ae58fe4a8e32a66"
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

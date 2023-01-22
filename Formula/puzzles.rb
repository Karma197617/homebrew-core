class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230122.806ae71.tar.gz"
  version "20230122"
  sha256 "0f080bb0001f8ba84f846f4b650693246dd89a4aed2e0ad39e3d2a74abc77769"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44571cbf136249d636f64802f4f2ac8881f1cb712bf2131341fa081d418eef0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f3cf5550c2c0e54e6e124cc0aef1435bca2632ad208d454d18cb2df2d681276"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e4725e841261b734c7ab8562c2ec38db705cd925f4ac8e969a1ae3f6c9ff20f"
    sha256 cellar: :any_skip_relocation, ventura:        "e1fb8cdb978246d89bbfa74d6036e509a83c337fb0143a472efb419f2cf8c695"
    sha256 cellar: :any_skip_relocation, monterey:       "d80e0bd79cc726b3127a027da5e1929fcfff7b12ea8e4ada6a77b3a0c4c2b6f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aa48c952e18075cbc614d834dcb2e9d08c19d600c937f3b691a0d1511c5adc8"
    sha256                               x86_64_linux:   "8bd0fcc656b3184bfd2ce8e5112709d8e956e2cacf347866c7e87995612d8ff6"
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

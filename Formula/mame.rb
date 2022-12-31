class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0251.tar.gz"
  version "0.251"
  sha256 "6d97db4ebfb269b1eb0e530444495a50d3961d0a60bce13e11dc88bbebb2fbc1"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest
    regex(/>\s*MAME v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e0158e9dbb4406895a5913b96b27ed0b4c2fa97450c84183255daaf3815c96e1"
    sha256 cellar: :any,                 arm64_monterey: "caa22b2f49b0faa96d337d88042a03b8b5f8dae9ae23e6faf482f762ea5eed43"
    sha256 cellar: :any,                 arm64_big_sur:  "66af1af4bcd6b4eb76d630228962f160dd19d6dc42a9f714395883373663d15b"
    sha256 cellar: :any,                 ventura:        "0ead98e68ad995835b279cc782d0dc855e5698dac3ab5f3ef3a55cc2e564a2c1"
    sha256 cellar: :any,                 monterey:       "515593614b11f2a4a692f679ec59e88e30d791c958969675357713fa7faec75b"
    sha256 cellar: :any,                 big_sur:        "c62eb409ef68ec62daa056850d29dc6fdb087bee0e4c3639c2d064d6ae89a8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a574c8100e5c293a93d0f55a8f57a4a9672d6a6415ae7537bbeab9958f55c5ef"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "pugixml"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
    depends_on "qt@5"
    depends_on "sdl2_ttf"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio and lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5721
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_bin}/python3.11",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=",
                   "USE_SYSTEM_LIB_LUA=",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame"
    cd "docs" do
      # We don't convert SVG files into PDF files, don't load the related extensions.
      inreplace "source/conf.py", "'sphinxcontrib.rsvgconverter',", ""
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps language plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end

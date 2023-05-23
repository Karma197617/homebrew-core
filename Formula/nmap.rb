class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.94.tar.bz2"
  sha256 "d71be189eec43d7e099bac8571509d316c4577ca79491832ac3e1217bc8f92cc"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "fa9ecaf07f3f0bf52b15823ebdda6d6a06eb87ed9fca10be319e924507fd46b5"
    sha256 arm64_monterey: "fcda26d55da7618f8085ef42ac88e268704d85abdebdd6335885d66d53e481b3"
    sha256 arm64_big_sur:  "7bb55a3cf90dec4eb58b7cc64ac271423c2399b0326fcf65825eaee980f6fb1b"
    sha256 ventura:        "ffa5863f860997861ee935efb30c26f57076f75ac8b0219f8370535decee795d"
    sha256 monterey:       "48442b1126bd29ff0d1912452ffff383f9569f69fc3dd06d8cebb728ee6c80eb"
    sha256 big_sur:        "06725befa856ced25c575cf50b3cb87872a0d5bd3b54f2332c239c24fecae634"
    sha256 catalina:       "6b8c3d04da2a2fc81ac7f228c8791a5f39bf41f2b43845b858a73e14d620ef81"
    sha256 x86_64_linux:   "6dd2b2fbddd08529dce573560637af486b51796c2e85eb110fcf344c5830f3a8"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    # Workaround for "./nse_main.h:25:26: error: unknown type name 'lua_State'"
    # TODO: Report this upstream.
    ENV.append_to_cflags "-DHAVE_LUA5_4_LUA_H"
    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end

class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.3/irssi-1.4.3.tar.xz"
  sha256 "b93f715223a322e67f42b61a08a512ae29e34bd4a53d7f223766660aaa5a0434"
  license "GPL-2.0-or-later"
  head "https://github.com/irssi/irssi.git", branch: "master"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "143107760ded6982897869477d2c79aaa13775d05e25356f2fd5002865a9fccb"
    sha256 arm64_monterey: "69731184fcfe2677b6d24cf3b3c3901e2aace975ed99242b7b706182aef01cd3"
    sha256 arm64_big_sur:  "743b316af037b0756de7b405a6f29cd70c99f213ad03cd02aed56ede6a8c8654"
    sha256 ventura:        "eb5da9b3fb7c1e827ff88483ae81676ddf8687be82c109c5db3fc727071eccb0"
    sha256 monterey:       "b7df6b4e9dd65d526127e8c0b243a32c80d33ac3c04456c63f3a24953f149c75"
    sha256 big_sur:        "ebc2daf02eae062170378d2995a42a643bb3d64f5f10ebeccdecf0446c7e0401"
    sha256 catalina:       "5c9239da0b6620df1e8bba3f315d35a6e41884bd107aab393c46434bd17fa920"
    sha256 x86_64_linux:   "3b1dc215132892ba386ff95486231a50e367b1866bcb6dc330811d4f5cf765f3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "glib"
  depends_on "openssl@1.1"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  def install
    args = %W[
      -Dwith-proxy=yes
      -Dwith-bot=yes
      -Dwith-otr=yes
      -Ddocdir=#{doc}
    ]

    system "meson", *args, *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    IO.popen("#{bin}/irssi --connect=irc.freenode.net", "w") do |pipe|
      pipe.puts "/quit\n"
      pipe.close_write
    end

    # This is not how you'd use Perl with Irssi but it is enough to be
    # sure the Perl element didn't fail to compile, which is needed
    # because upstream treats Perl build failures as non-fatal.
    # To debug a Perl problem copy the following test at the end of the install
    # block to surface the relevant information from the build warnings.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end

class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/libproxy-0.5.0.tar.gz"
  sha256 "a57ae66d16c9dceb4a2869ee69a541005b7c896651e66da91aa646dacfbbd25c"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "6246d732f961d77005bd78e3e26dcb17ca6e30db717ff15153e318567e2d50d2"
    sha256 arm64_monterey: "443454cdeda3546c1d04c36f51d1c71312806abd99ac968dfa22ee6dd3ac6119"
    sha256 arm64_big_sur:  "00438a3c641cdb2326ad06e45f446ec78bd247740415d5f969cd14875c6f6902"
    sha256 ventura:        "1dfa2bf3dec13e70f0a4af42f131cddea3016de6e0a3c12bcf9e595f2e13c911"
    sha256 monterey:       "b1de5bf78ffc1fc870d383cd713c438e181d037506d11c95c9dafffe302e05e1"
    sha256 big_sur:        "b22d402e7747a6a4f725c0cef38256d29292544b6117be5f761627182be3b585"
    sha256 x86_64_linux:   "9e610ba5049b018c45b4c2a8eeae8f01391227dc30189d54ecd476496d6fdbba"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build # for vapigen

  depends_on "duktape"
  depends_on "glib"
  depends_on "libsoup"

  uses_from_macos "curl"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end

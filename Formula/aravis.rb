class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/releases/download/0.8.25/aravis-0.8.25.tar.xz"
  sha256 "3ba18f941ae4e2c898fed1f63c4ce67ea41a800a902ee5684eef4ffdb87f1c09"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "1dfd4b5d672fa2c9bd417a9a29b02d61b2aabfb0718a0228c10d41fd577f1fa2"
    sha256 arm64_monterey: "e45b6ee9545e0608a63beeaaf1fa2e674ac0899bffc82f984150ea95bfb97d8a"
    sha256 arm64_big_sur:  "68e3ce236c9ae80d1c093586cdfc701223e23536dcf0288c209f9ca00401d2c8"
    sha256 ventura:        "e09cdc227e57cf9f0fda81180d75839a86cefcce97ec68360e916919175b23e9"
    sha256 monterey:       "ba9dc3fe2ae79dfdfa21bcf6be25eb92cdd9845b53c65f6732aa0abf6f7273fb"
    sha256 big_sur:        "820eebda3ce54a4ed1c960cefabeebe65470df5b8092c2c9558fcf95842eb64d"
    sha256 x86_64_linux:   "8305a708295637f5c26e656ab7ddc45845db79041453af86b1e5ff5d44ef0260"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end

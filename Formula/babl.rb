class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "https://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.102.tar.xz"
  sha256 "a88bb28506575f95158c8c89df6e23686e50c8b9fea412bf49fe8b80002d84f0"
  license "LGPL-3.0-or-later"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/babl/0.1/"
    regex(/href=.*?babl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "b903be06a5e5d5f9c342c2debd9dfc6e5fd32b35a5055fc9df6813efae8ac5be"
    sha256                               arm64_monterey: "907dd8df4c6e8ed1bd886757db8ed4aa1bbac12c0940caadcdecdcab747e123f"
    sha256                               arm64_big_sur:  "9a83dd6ef019889dc0409b2ab21adf33443388c5b00834d6ece2bb562a99f35a"
    sha256                               ventura:        "4085fa0240a176e34cc9b70b35a6bdf5539f58e337d71c65cbabf9b96062269e"
    sha256                               monterey:       "80f73cd070ffe55d65bd1c4cee18bba1730dd3b9ec02a78090af92ad816bd674"
    sha256                               big_sur:        "90e156b78cfc33c302d085f4231d7aa25fb5943e319e7e7514f85c2144771df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e50cfa5fd796b45717cd4aabf9e927d3627d1c8dd651d62cc09b6a1c962c4558"
  end

  depends_on "glib" => :build # to add to PKG_CONFIG_PATH for gobject-introspection
  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre2" => :build # to add to PKG_CONFIG_PATH for glib
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "little-cms2"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dwith-docs=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/babl-0.1", testpath/"test.c", "-L#{lib}", "-lbabl-0.1", "-o", "test"
    system testpath/"test"

    system Formula["gobject-introspection"].opt_bin/"g-ir-inspect", "--print-typelibs", "--print-shlibs", "Babl"
  end
end

class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/44/gsettings-desktop-schemas-44.0.tar.xz"
  sha256 "eb2de45cad905994849e642a623adeb75d41b21b0626d40d2a07b8ea281fec0e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, ventura:        "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, monterey:       "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, catalina:       "af182c58a3eb7b6cdebdcbd1fb34b52450ae758101656d4b555c3f5bc7bffb8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a118bc1e52f9b8b21db50f93783c08cbc99fc51cb4d14a9a3bfd9e87c3697b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "glib"

  uses_from_macos "expat"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end
end

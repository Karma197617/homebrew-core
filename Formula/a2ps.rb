class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.tar.gz"
  sha256 "a5adc5a9222f98448a57c6b5eb6948b72743eaf9a30c67a134df082e99c76652"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 4
    sha256 arm64_ventura:  "adf71e909a31762f566a32be68297e0ed7b43faa0e386e5b90b199896dcd5884"
    sha256 arm64_monterey: "b92375f7cc49a7440b431d2248cad0d97c96fcca127dace6efdeb0b2f3faa08c"
    sha256 arm64_big_sur:  "8ac02041dbec3966b6a695dfc4215b90b9e331ae6eb8c6698cbbfa0175154c9f"
    sha256 ventura:        "9d729c98415a5953f0c8ef4f6dbb9ce9a7864bcf7aeda3b3dc8473130fddbc42"
    sha256 monterey:       "c0347849efe7486dfa2c5cfd35fae4c87e194fdcd9a10c6ce8758c99e8cf144c"
    sha256 big_sur:        "e87da2b47386fc7e3c6f20b3ff90c4bbe37b9e0aaa884440ffa216492dbc150b"
    sha256 catalina:       "82e64b2008971430d160a3f564e32593e98fb55c43d7748c7deb9d6f546e1102"
    sha256 mojave:         "8ca49b4797277f79e87e48ab4c6794601b64d1dde35b9eac556d4153b8237a51"
    sha256 x86_64_linux:   "063b4b31a62c4d5bd905bc4faab09ac2a50c77291de52ab216fc6a7a56f8e406"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "libpaper"
  uses_from_macos "gperf"

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}",
                          "--with-packager=#{tap.user}",
                          "--with-packager-version=#{pkg_version}",
                          "--with-packager-bug-reports=#{tap.issues_url}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end

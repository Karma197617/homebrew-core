class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.13.0.tar.gz"
  sha256 "ec4a54a31c95465ebbb22821f141220fb42302597312db368cbb0e09e66c3f85"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "929cea6bf419b2fd8a1153c90424d274455d4a180a646fc40fbd9723608833ef"
    sha256 arm64_monterey: "372d9675e1596b8e8fc150c0f90c572a82ecba8ab58049ecf370d00cf6944ed7"
    sha256 arm64_big_sur:  "49acc28704aef26368d86950681bf73ec00b4ec27740ba3683e310f3fbfc4ba5"
    sha256 monterey:       "b744c577af3141b335f0c77acc24ecc573ef68f674ccacacbad0639a10c61ed0"
    sha256 big_sur:        "c91473f3686a05f380d6b696746accfa55ca7670ec23a426eb45b0e2c964e30d"
    sha256 catalina:       "4e8b24cb3831eb3c629df90eea3d1f3268031f34c522d691be6935fa4375d159"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end

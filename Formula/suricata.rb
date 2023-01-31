class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-6.0.10.tar.gz"
  sha256 "59bfd1bf5d9c1596226fa4815bf76643ce59698866c107a26269c481f125c4d7"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "228f546b55eab4043896a3e23a85528ab76c2c82b90b0f2eabc55550ced6e718"
    sha256 arm64_monterey: "fa8cb9d6e418d939dd686eb65959a9c5a542c667f1a033e9cfc13a17d37fb65a"
    sha256 arm64_big_sur:  "bd73603e4dd7cc2460039b00704790a68f9bad3f1b64be837e5507f2ddfddfd3"
    sha256 ventura:        "bde7b061c546b7949c1d4f7abeaa2a0fef49ccd1218a2341df3b8869e4fa8633"
    sha256 monterey:       "4fa17a2c85ca9a8a199f0c307b9bec763ecc36cd30c08c9b00b2f4474bda2084"
    sha256 big_sur:        "a00a3496f483c992997e2a4a395cbab5793c73e17f639ba03d98bd251557dd0e"
    sha256 x86_64_linux:   "0fdf313c3a614350eaf5756bf7312543a78949666ebbd358b0703df3ec2aaffb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "nspr"
  depends_on "nss"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libpcap"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "libhtp"
  end

  def install
    jansson = Formula["jansson"]
    libmagic = Formula["libmagic"]
    libnet = Formula["libnet"]

    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libjansson-includes=#{jansson.opt_include}
      --with-libjansson-libraries=#{jansson.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libraries=#{libnet.opt_lib}
    ]

    if OS.mac?
      args << "--enable-ipfw"
      # Workaround for dyld[98347]: symbol not found in flat namespace '_iconv'
      ENV.append "LIBS", "-liconv" if MacOS.version >= :monterey
    else
      args << "--with-libpcap-includes=#{Formula["libpcap"].opt_include}"
      args << "--with-libpcap-libraries=#{Formula["libpcap"].opt_lib}"
    end

    inreplace "configure", "for ac_prog in python3 ", "for ac_prog in python3.11 "
    system "./configure", *std_configure_args, *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: lib/"suricata/python")

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/suricata --build-info")
    assert_match "Found Suricata", shell_output("#{bin}/suricata-update list-sources")
  end
end

class Apachetop < Formula
  desc "Top-like display of Apache log"
  homepage "https://github.com/tessus/apachetop"
  url "https://github.com/tessus/apachetop/releases/download/0.23.2/apachetop-0.23.2.tar.gz"
  sha256 "f94a34180808c3edb24c1779f72363246dd4143a89f579ef2ac168a45b04443f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89f9013994449c4578521ac95055fa3961d181a42592f795bde318daf4b26fd9"
    sha256 cellar: :any,                 arm64_monterey: "0bd9b86d7e7a88136da835fd1e4bc715c2d98c097ab1956f8c3492eb557bc9b1"
    sha256 cellar: :any,                 arm64_big_sur:  "b3795c0b43fb378f2293b0f267468fc57e15dd34410786b35dc37bf9fbd075c5"
    sha256 cellar: :any,                 ventura:        "7eca735b1d2d15954d9d1898070fb50437c619dfdd542e1b3753e8d327d63b78"
    sha256 cellar: :any,                 monterey:       "20984a6baad28aa3cfc47287b0682432f567de700c40ba6784835f9826b09761"
    sha256 cellar: :any,                 big_sur:        "23a71292dbcbdee0619bab39a416257fc0226c4ca5c942e23d373c13c0c237c1"
    sha256 cellar: :any,                 catalina:       "da48ab193d519f9a3ce1f90d1f6b4f4b9adee43a6a57435329d7a04e2a27e154"
    sha256 cellar: :any,                 mojave:         "a71dffc1d92dad7331f5e935395a20bb3ba953889f5083e92bcd7e4388a71ab5"
    sha256 cellar: :any,                 high_sierra:    "1bab24050249ddcf4f69b48b6568cf8e0464722d1a91cf3c1b6a21da0fdf4462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180b03f3d6507d52737f6a4490e9cbd870b10526bd1924191263c3785bbbb9ca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "adns"
  depends_on "ncurses"
  depends_on "pcre2"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.append "CXX", "-std=gnu++17"

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-logfile=#{var}/log/apache2/access_log",
                          "--with-adns=#{Formula["adns"].opt_prefix}",
                          "--with-pcre2=#{Formula["pcre2"].opt_prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/apachetop -h 2>&1", 1)
    assert_match "ApacheTop v#{version}", output
  end
end

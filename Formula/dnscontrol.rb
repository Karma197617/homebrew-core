class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.26.0.tar.gz"
  sha256 "1309d68455db348e78d3616136e283ee56060c521eea8f5bd12260fda223d12f"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21018e7a2d672eb86b88fe514ca349f9a164c604e2ae124945f9f6d2ead2f6ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99f87098eb397c31167fb6308d27d1b2228d18e6b1e6f5088d1420f931d582f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "724d18d2c24f92a6cf41b76a3232d5598b0c08e051d75e20d09d9bc41a84cbcb"
    sha256 cellar: :any_skip_relocation, ventura:        "4e29e399e8350d1ddeae3a0e9884b30f0a0b15daf9cad22460127bdad740e163"
    sha256 cellar: :any_skip_relocation, monterey:       "77d5024a858a79dfe361e4e9ca0e1b6bbf4e60b3beffd14f39936ee5eef46f25"
    sha256 cellar: :any_skip_relocation, big_sur:        "020015390709c1b0136eb087adc1f78fca381fe0c3b05939aba126cd9ed27ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a2a8598fad60832181656964465132840ba7df37eba1e25ed4741e88ca289f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end

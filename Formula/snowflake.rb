class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.5.0.tar.gz"
  sha256 "4d9317a8935dac6f55710673e820624418fcd0025b672e58d8deeb43636f2627"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba61457a9541b191082be7deaf8cd6e793f2e40dfb2786ef0a71616231fe6a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e29478898bd2e269b81ade530e011267c5c6d14c30b6659d8e60f7265ef14e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "995c4e26312b0850fae3c653cc24762106a1239e7252c6a4edb06d2b8a11a37f"
    sha256 cellar: :any_skip_relocation, ventura:        "11c35fffefa2d767450b37d20f3701854a2ab5f3b4de713d7776a931aabe74e3"
    sha256 cellar: :any_skip_relocation, monterey:       "96241414b5160b6c673c19095baf8207bf26e04069acf8802b13ef073a0a6f08"
    sha256 cellar: :any_skip_relocation, big_sur:        "5be927160024fcc5d348dd5f2cee3f41ad9d5aab8d6f619ecbf1708618213a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee708391bca9b3e94a99e6ca3b7ac2983913fbc76e4307d2d424f0ec38ebc4d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"snowflake-broker"), "./broker"
    system "go", "build", *std_go_args(output: bin/"snowflake-client"), "./client"
    system "go", "build", *std_go_args(output: bin/"snowflake-proxy"), "./proxy"
    system "go", "build", *std_go_args(output: bin/"snowflake-server"), "./server"
    man1.install "doc/snowflake-client.1"
    man1.install "doc/snowflake-proxy.1"
  end

  test do
    assert_match "open /usr/share/tor/geoip: no such file", shell_output("#{bin}/snowflake-broker 2>&1", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/snowflake-client 2>&1", 1)
    assert_match "the --acme-hostnames option is required", shell_output("#{bin}/snowflake-server 2>&1", 1)
  end
end

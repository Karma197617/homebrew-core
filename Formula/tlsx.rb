class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.5.tar.gz"
  sha256 "c8e43d6205f235b6584b80a683b9127aa836069baaec0fadb6fce0f90d1d0a04"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce82a5e68f77f97fa43496d642f57bc33b0852650d1869df31c63d03a94b6900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69c61858dcc94a73ef47778ee35c4d14fb3432d852d9059b290c97898ad2751c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2ec394bffce60cce3088e2ad3596b212db777b686228abd0c866c18f7a43c8b"
    sha256 cellar: :any_skip_relocation, ventura:        "1ef6fa8749f6424efb28e368d9f7d8e54e1c3275a43a0e2e57911640b09fc216"
    sha256 cellar: :any_skip_relocation, monterey:       "480a29689630c2c97e773eeb118878b8b2619f53348de42ed3cf378bb1882991"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf0331e882bfcba2cec02af61a7d3c551c2eddf08123258053da87a4f6de3471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d7113a8c601f83f3c6b70901c64562f959089bf82c95309a0e3b8b45143794a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end

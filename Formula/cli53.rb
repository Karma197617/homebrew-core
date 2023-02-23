class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.21.tar.gz"
  sha256 "7792e8d3ed5b4db7a0505cfd2ef7140f5775f1b7588b5de71f3e878d90ff88bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8f16cd993b99c9fb9aa4a68e5598ef2d0e98cae116926877deb37b06bf7e3ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f5849c18c169f394c6927c73ce11e24138adf502e74ca4b74120c2098f92498"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ad73cd56c4d7364e1139d2510e29cecf63a642cf38066243b329c11cbf7ad29"
    sha256 cellar: :any_skip_relocation, ventura:        "0dd22368c20df5410556bfaf3092291cf3c9fda8f6b4ed2ef54cd940a8d1539b"
    sha256 cellar: :any_skip_relocation, monterey:       "a9bc2052505280534e55bcd7322b4ba189f74af6217a2c7b634eeac859ff9ee3"
    sha256 cellar: :any_skip_relocation, big_sur:        "41bb4f7c005387ef1d24468438b9b044e940832fb96f9c1a1e1b0dc0ef02b8ea"
    sha256 cellar: :any_skip_relocation, catalina:       "a0e1334b7c9d281766c11087bb93b53583ece127bb07541e7e14e92514a26cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277053f98b9c41c06694bc74d8455d8a2641d928e6e24d0621b574ab725a34c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end

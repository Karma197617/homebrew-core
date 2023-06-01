class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "39a964ffaec8004cb6b8b6cd5abdf46bbbfb2c03bf608bf0988cb8b5e17bf5ce"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79bd4e89e4392040ecfdc3974b12d1a4c9efd57e7332aeb60a8b9d1368b7902a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79bd4e89e4392040ecfdc3974b12d1a4c9efd57e7332aeb60a8b9d1368b7902a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79bd4e89e4392040ecfdc3974b12d1a4c9efd57e7332aeb60a8b9d1368b7902a"
    sha256 cellar: :any_skip_relocation, ventura:        "dd16b11803bb12f12d6344ae6dbedb2a16d6ce329cee72ea29f5562b03a2bb04"
    sha256 cellar: :any_skip_relocation, monterey:       "dd16b11803bb12f12d6344ae6dbedb2a16d6ce329cee72ea29f5562b03a2bb04"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd16b11803bb12f12d6344ae6dbedb2a16d6ce329cee72ea29f5562b03a2bb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b9609a0d4ee1b7095c967be0fe2204009d668ffff9f3e75c5fcaf5125bcc5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output(bin/"sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output(bin/"sqlcmd --version")
  end
end

class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "3bb06d2f5c4a66a4ec7972f94aa6a868b82b53c4542e5db69a634b94551bba96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dd2e407c08805a66d8c05eebca6d5566ac250b31e229b4afaa9d43859afe509"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7aedd6075ec4702ca72807911e5bc02e221b77993d48a03520ce06042fa5a5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c5028f82cdd09e2348065284f5e090263faa368c8003d218b718cc7d8474e80"
    sha256 cellar: :any_skip_relocation, ventura:        "e8fca8ab752c458ebed94947750b9428ddf56772a740d9df4bfe17087a942f33"
    sha256 cellar: :any_skip_relocation, monterey:       "90b8f776dafa750bf4e616d24d66198bf3cbf71fe493b23ff99e0bdf8c053944"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ab9991d89f67ec5d2651d26ba6266e74ad4d0a0cc08ceb6a8941ebdfb2ed20e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d188d3f360b748ebb47e0d88f4e0400fb31eb118c54b873523afcfcc9699d953"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_equal "sqlcmd: #{version}", shell_output("#{bin}/sqlcmd --version").chomp
  end
end

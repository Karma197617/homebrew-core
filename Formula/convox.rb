class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.5.tar.gz"
  sha256 "2a84b5c645adf97ef3272acb89d6e4d3a900330782ef815d39f9f8e15259356a"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcaf9ec3ce2be29cc52cc761697b2c0ba24a36b76eac50693734bdb75b7015e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcc0014a6f60ee8ece9d811834963198c87a3be0db00958512c106c8e6e5447e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "460abeec0484676d54ba26e8cf37586bead86205b1e955a9b0cb99c669902026"
    sha256 cellar: :any_skip_relocation, ventura:        "3d8423581f4f9d6058de0c6517689d416916b0ee8d78fb92cb5f955183121431"
    sha256 cellar: :any_skip_relocation, monterey:       "d10202f0c92729e8cb366fbeaf2940eb5b08cfc7ece2aca8268d2b91d63dc582"
    sha256 cellar: :any_skip_relocation, big_sur:        "85a89b1ac615924894f6204f414e5b3d48a40e568d2e864f36c5649c0f17cfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e37abf5c867e014f6bc67c2bbc2dfaf6be291fd81d54b94ca562f758d86c88e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end

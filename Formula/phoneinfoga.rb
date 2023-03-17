class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/v2.10.3.tar.gz"
  sha256 "3dd978998cb3524c482124337248b44a9095b414b804399ad25f5cc7bc39c56b"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d632a5fc54c98ff3d5a05aeb5c8b4aa9810822893aea324c1472305d9797b0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6343616ab3d382df83c1031bae5e6bfa7b075daf98724d7cd47d71dd401cf2e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e9226c3080da93109ff039995402ae7c5a18a80886b496032155da5f911e169"
    sha256 cellar: :any_skip_relocation, ventura:        "c23ba34ffe0454c5f301c162621d6822615c35b76a98cf30d0d7d0cd87971d8e"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ff277d3854cf2b76e26c157c496e1d7fbbe64d243140427a0feabc6cd83956"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe6a75c74aab3d4cf276b46d401d41a09db55cb21fb7a20d450a6767b09dd1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3047a526b0bdd2e4d84f2f88953193f0d0afd93eb59d83c559c0182512c70dc"
  end

  depends_on "go" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    cd "web/client" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/sundowndev/phoneinfoga/v2/build.Version=v#{version}
      -X github.com/sundowndev/phoneinfoga/v2/build.Commit=brew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "PhoneInfoga v#{version}-brew", shell_output("#{bin}/phoneinfoga version")
    system "#{bin}/phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end

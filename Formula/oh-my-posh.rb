class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.34.2.tar.gz"
  sha256 "ee96950a50d17ff815a1e64afbbc6a2f2ebb0be3d29f1247e836e765c8a34635"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08398ddfcfc1b612cbe2f9023aed03999887e3f1a64eb8383d8f032423603310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e93372651a2a37d157185c5ea19f076a952378a3b368cd20edb68492fa3e7a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ac6e923098c0cc568e177aa9813437ff162692b172375831c0ac0edbd313e4e"
    sha256 cellar: :any_skip_relocation, ventura:        "5c803df3772aee520848b25253e4cedbffba836d133812a91fcaa67ede6c6e6e"
    sha256 cellar: :any_skip_relocation, monterey:       "416555e7e3e5e1a376a84c2c882bcaf254f608c9a9485ed0f647871f0fb2f0d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1636f925497e9173042316d27622d4048bdf142929eca40bec6b58733e3f498f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bb2fb38dc26a9e5055265697ea4937905fcd3f2bb6498ee087eb8c68799d86"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end

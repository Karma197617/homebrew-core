class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.7.0.tar.gz"
  sha256 "1297cb856e922a3b94c926a952634ee1529bdb16c4c8de11c38c07a5ef4739d4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28031d9800e13f719c4abc9cbc9de678964b445df7f67a8e9ee066cb12d369a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9823ade4e8410ba299c8012996bdc28c901f438e9e7c6d49767817ff185025b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd7c0178a22c609d374128a68160d9dfb2ea41a8297ce15b21d56c7844eff33e"
    sha256 cellar: :any_skip_relocation, ventura:        "b93605685db00836457d99ed4807cd6b3f54d1c62c837c33dfb5bcc11c44d78b"
    sha256 cellar: :any_skip_relocation, monterey:       "30782f5b8639600afabdd89f806a525bf566c5588337be4105c30e3e5f59267f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7939c86afb32a293489de496c5e710e0bd436ec02ee21d11a29a2bfcaea00ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212239d1ddb8e2b9232294d4b3187171b30a36e5179ebdea23591147822a9a9f"
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

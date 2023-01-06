class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.35.2.tar.gz"
  sha256 "f57e81c3b92ea2223638dffe6d17c945518b602ca3778f67ce3425c02ca8e1cd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9407b46bc53b498788d4043e26aaf960aca241df296eece26f6f3f7f92a2cd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00eeab67e6e2fccb081e6300c14930979f3905cd55b99cf53a97bb79fcd1abd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5f80d18d114c9192d34a3be097dd2c7ef5aaffbc1e195c2c41b7e17980f8d06"
    sha256 cellar: :any_skip_relocation, ventura:        "0864aea1bb96be106974f2827d7cfc61e14f91545db545a3bab04f98c112f36f"
    sha256 cellar: :any_skip_relocation, monterey:       "9da4f1a8aa792f0841a6db0d64db5c41b1acb53b192e2f7954272f7e3d701c9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "85f8714a22440913fce04d44f0cb481e7dcc7ed659d90ff6e2e8bdd378cd8ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87481cb0669e430a6b1164ad1a867c1f8bbdacaacfddacaeee203d7a3829514e"
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

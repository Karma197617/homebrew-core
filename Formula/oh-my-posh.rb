class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.6.0.tar.gz"
  sha256 "37504963740721505b06c29f9f104eef83a0b49953416bc94661e6e70bd1be94"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3a07d9bf174fa64e4da63738cca0cc434bb3525c71a3ce53dac89330074bd70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d36bd1c6f9a1c74af392d5b180639cb565f3356c869f761a138f2675446cbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d0897977eea252195c6b12232f2a10e583ee4997da54236bdc0cd2dbccd9c77"
    sha256 cellar: :any_skip_relocation, ventura:        "c241551d237cfef3c0dbffb85874d0943287aef072da24f311fe268ab6a5fe39"
    sha256 cellar: :any_skip_relocation, monterey:       "9050360d8cc90353366f0068286ab93eb7ce2f995422755cf9b217d82474f56c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4605e431bd5be34a1c0a0e8ff48394ad835af1f82c133a11766c4f69c2ba131b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c20dbadb1030c150173687e699fe1ff2ecf3f6b33e45d5c3eb2abef0b5f724a"
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

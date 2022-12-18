class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.28.0.tar.gz"
  sha256 "a779fe4bf250ec352b8ee59509480ed4a3638da4deb14992e5b2d65ced9848a7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f697cbb9d920b026f4b61941b4018a596c8021d128dd6ea970bd132f03fed71c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1791e508613ed85dde594b31f1a4cd1ce58b999c2b02eae037f2d9ddf1ff1c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b006413d617054dec3f6eabadcfb2765b8ff687966de7f7975e4e46c415c7c6"
    sha256 cellar: :any_skip_relocation, ventura:        "1d081b0a6d610993ce4b2536d8337cbc564aa42be6b47ee92bcd31f6264b0c88"
    sha256 cellar: :any_skip_relocation, monterey:       "bc3e2246ba01d7250e36ba932a9ca3645af0823f7c0ee8be135b3e8c26d9bb10"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f37a0f0ebfa75f55f7e390c9262c1a56176e2999d52ff80f638929a00968a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d460b48c08839503ddab97792c11be4c6b041984ac972e2936020fa2ebd8ce"
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

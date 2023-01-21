class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.5.0.tar.gz"
  sha256 "332c6e1e94b055f75952d8da87c19d10b39372618566d6bb605f159158945021"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d064beaa946c88767fec24f6b4b1c09988c76a0b31cc89b4bfea6073f44a642b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bb4cc6fdf44d4ce30bf30a0e615a66cf736174402106a8eb34282c757ec662f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d30eada9477582c1f5deeec67049faf7b0adcf2c9fe9ad42ec73fc49f0b613d8"
    sha256 cellar: :any_skip_relocation, ventura:        "be8a99a6630b908b19114a366c8978952f4f86fa786e4b0d885a4e12499a8cfe"
    sha256 cellar: :any_skip_relocation, monterey:       "969c02e5c1cc43ac28a9ad17e847e515f26bedd7235e42d0582449b25e04acb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f58cc2e5a4aae82a0f4c63c9eb74a157789c73292f8aeb57ee5ef816e78db985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c3003ddb04f7e3596acf20a563e1ec7ed6d127658d562ce5c1f872a4111867"
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

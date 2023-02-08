class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.2.tar.gz"
  sha256 "553cd44cdee3c6583b2b734bbb5373ff0bc5ad0f9e85b593e6b007b2971164bd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab90bc65e039995f63d8ca37b8ae6e69d1fe1509e1628000170a85b1d9359c0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b82de9c5083a2c5a87fcaef1ac46819c5377a1680f85a583d7893b4c3152a4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d144941bd81e381a53953b311a29067cf05c60ba9fa728da8466f29dd0a1b30"
    sha256 cellar: :any_skip_relocation, ventura:        "ddd6260c4c5864ea092985266731ee9aa1939bfc5fcd5bc88e4f657ef39cb92a"
    sha256 cellar: :any_skip_relocation, monterey:       "487941741fba44120abbc5725ce081fd412968353df64f42dd2a0809b875f73c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d8c567ecb5463b47b63a636265e7a3972e566f507ca2e65549cf0a9147f7d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e78c021c1b7482cd726fbf53db391bce828847732bce23694be5b359ceeec12"
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

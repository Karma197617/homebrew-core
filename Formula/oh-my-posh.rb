class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.1.2.tar.gz"
  sha256 "47ab9da1c0477daeac736b3186b722cc10457dc8789e0701fa6aff525e032f5d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55f0f8b8ce36a8d7c5be70831e7d249d5082a012b581baffe2defee951b6aff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfd0f71547a0bd27f07240b96117aade444956d69826c29912a729f9ff6e4505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ce0ae454d4ae9568606081e92e3a0890696c4afb4413da05ac57dcf4445c4b0"
    sha256 cellar: :any_skip_relocation, ventura:        "cd7a85efa1e168d0c22ce9815a41f18020595b8a63902efd3f07e883a1ba39b8"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab5c6406f7ac318c11fbaf86a5b25c75489ebccb60c8326ab5f1fe734b2278b"
    sha256 cellar: :any_skip_relocation, big_sur:        "97c25d25366e93c20c0280cfa28d9b450459680cd532731d8b853ded09e031db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2931d52e221bc4e63e2005b9724ac6328aa50113f73397afb22b680ccd3566e6"
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

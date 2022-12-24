class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.29.0.tar.gz"
  sha256 "de8c5a3a057facb3f8f2e03ce78acf5505066d7807ded5bde006de117238c534"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ded3e40dafe9eb81d508b8521ea335af21981d5667741d4d2a19ac26e98a2edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f088ee36b306d4b276e8b942aac7a50418e34ebe1317700c93b06acdbd009e92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f71b6fa5c294fdc587b42151c9c6f30b6f79c12c7572ab76215f6f9546a02e85"
    sha256 cellar: :any_skip_relocation, ventura:        "40c809758dd2388ae1e0b36ff0db5d88d1c307b847b738d8390162ed6877edfa"
    sha256 cellar: :any_skip_relocation, monterey:       "98c73ca7182a874cee2640653f289b54271bce0e00af2baff27d009aacd42289"
    sha256 cellar: :any_skip_relocation, big_sur:        "6edfa82573911c23ae4e22fb33cd2a468d9e86b619aaaa7e9adfce2f95d14a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a23c3f53ec9ce48fd2d91f42d15e8371d0f4c67c58eb54f10088b1a72479d1"
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

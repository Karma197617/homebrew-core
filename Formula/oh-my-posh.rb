class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.2.0.tar.gz"
  sha256 "e723d078397c22a5f053ea21777c47d73d582f21d4035177ff1a615d3ead53a1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9792d1b3ca21f987b94b0f2164e9881c492069df1aa350869909317f6d4f758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8989e8ec49c8050a605770670522e6805605cdfe7b3c3eac5b502509429a46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "985b8e42dc3a0962e6ea5ea04e6501239cdf79bb35107781a892f9576756f95e"
    sha256 cellar: :any_skip_relocation, ventura:        "f280a9bee2ba10812d0ed52bd9df45ef29a4156412aef72a33da25b7eccad21a"
    sha256 cellar: :any_skip_relocation, monterey:       "00f5577a2dddac7c4910b4f0c519464fdb5c6a1aefba5375cb4a89965fe1dc0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf61675467a821affd5e8cdad0f60e4356c8920af6ec918c96f140411edbb1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ead6f0b67267f60f847f1df2401a37d90df0e9086b026b4cc9371d696c2e72"
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

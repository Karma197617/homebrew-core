class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.1.tar.gz"
  sha256 "bb7b36e9271b5941e43159fbf6c5637c145827a6d5645ef3bb51697c610f41fa"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63e331080c9824733ef49dc43945a897ca7013aa46d9df54c7c9e54495c4de3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f27e3185cee46b7c8cb655253024613c3829f41df155e0cb529d4e9be8d962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd982fb8d924e5925be1d9aae69910bfb10dd04be0de156989e8eccf22b99a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "b1ffacb376576d33e787f85d5204402bfc3f19ec1374318ef0bf95d1de48dab2"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e6c684f222db0b101335c40408f035fd332c5e4d86b993594b3844d8ff30ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "98312231a070eeed20ef87e090e9677efa8c63b2d5b7545f07088d637ff3881e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f8c7479e5d0461f2e82185dc6cdc687995743777adaac1a7d916806fb1f4cc"
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

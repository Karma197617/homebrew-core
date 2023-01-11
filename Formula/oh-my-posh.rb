class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.40.0.tar.gz"
  sha256 "0e0fbc230409d571219a617753deae830bb7754edde29dd073440a8d94aad532"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6e33e899b5e73317da4628089fd943d2c813479457df8531eaae7b9b2fae8c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82e0c64d6910ea00fc3bd7d4f888487a1aaf9c775e26b783500aba4ce9361a2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdc9cdbca53175f5f6ef86aec35f19147a0988b607c457af964e7824f644facd"
    sha256 cellar: :any_skip_relocation, ventura:        "888851c76b7690dbbfb991b3ee900eee1d246561b92796c101500c24de2b563a"
    sha256 cellar: :any_skip_relocation, monterey:       "ec816821b0ed15a32a92dff88b78f5fcd36e4675d45efd353ad6c3b9d81b55a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d748e94b3f70098c6d385aa27b127070c3cf390e30efd46d020cfccdda360a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d1572a69f8e06cef9daec19d127935b08c19d5da60ade991a941cf8c5c75c38"
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

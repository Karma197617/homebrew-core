class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.9.2.tar.gz"
  sha256 "57c55425d6eb5fdd321ad41f3b962c2c3f4b14b044c643f350808e0e7c8a156d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a47363c573cfa856adc92923d5fde533f0420612e8b2adbb3796d27fb25bb71b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4a737bedc4960829c0de17df8c7a79eff6e0045abf903c684b534af62bb6e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a58a519fdd9a67d4d8a7cddccc955bd02882da24eb2a920a4543f160f095829e"
    sha256 cellar: :any_skip_relocation, ventura:        "fb56cde87cde3cf3becf1aefa61f67a45dab6d5611409278dd22e5561a518e11"
    sha256 cellar: :any_skip_relocation, monterey:       "4e2a8bbec1b520808f42b7e54c7d020ef2c620209cfc5e6aa65448fffea45f21"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d2ca568fd060c4b8f539d3ba6fb386f5ce00fbc1d71135f4d77ec27a5b92b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "854772af0238db9088a135680ee5fa14c8b83c25b56e77abec871158ee95efa1"
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

class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.1.1.tar.gz"
  sha256 "0e08cab9e6b79a855a8e2cfc1494195f076627a6e77893d0d6ccebbb78e0c4c0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af1bf91120346191f56da4cc2d7a9e4bc09b7baf52c5976ba9e2186ab46221ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe09f13e7a9b8deadd1a7424049c2295e53d8640e92228197830945defdb4892"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f94cfee2553425ad5c5b10a5fbf766bb793dd806e8bc9e74cbe5f9528550d4b6"
    sha256 cellar: :any_skip_relocation, ventura:        "e6b9386a5f5e9e8198bdf195d6bfa35e2627c6e81dcebd4011b16aa4f5c4c3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "8991028eb8ab48eb68eccdf5dd10fe9b237237a177f674a3da11baf18da52636"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4fe4f70b86b0b7a452e28be8f5eaaa630ec8ee403027f5867c88080ccd6480a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35fe8d3fcd02d5cb289f9ad7c814fa1d39d484877c8b7de345d072ebe7793bf5"
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

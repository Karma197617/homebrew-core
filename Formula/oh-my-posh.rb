class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.1.2.tar.gz"
  sha256 "dc34a609e886c39e5b16a6c9576b5f26a6293cfe64b97bb6d252dd46c1b9543c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0bbb2c469603a00103c62be6b2a920b1a13937c4678154ae05910f2670f5230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "947df2f50c61389f1d79f4ec92ede6016227cbb9440a094224a81a6599fcd1f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5826fad186ff97c0531b283ab03e613f329a44a03cfea316cce1c2203fd6a61f"
    sha256 cellar: :any_skip_relocation, ventura:        "c87cdb7007833ed29bd8be85cfb175fcc75d242abc25470a4ee834b52e950aa3"
    sha256 cellar: :any_skip_relocation, monterey:       "03a42397941f42ca7edf6fe4009a7b57c7ea94193805d5e5c9ffe46c06ee662a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a201e269cf4b2528fc389a407543e2ce87059046901a00fd9107373beced3e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1883c8a911530a4b869e2d956c72a3874e5fd22fe9043b359a27e933796415d4"
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

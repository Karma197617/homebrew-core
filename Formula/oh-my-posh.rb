class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.0.0.tar.gz"
  sha256 "5b470f0b1678ff51435c167baa689e8bbef7f17b81cda2e1e9834ad3893696d0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "892bc72b00b772c9cf4fca5de48828dd3b3f84e9cdf63c463b3b19ea0b56db79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d99109e3590962162ca3920d3757f1b93d639db3e5fb2c99a4b2f09835c2da8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4be84e61793d18ee7fbb73b267500a60ac756e6454749f57b498fc28b7b5e9c2"
    sha256 cellar: :any_skip_relocation, ventura:        "f192c6083db24d684ff91ff8bfd3ab6e96e689e901b25ee518f63e94613cfef9"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3f4fefc509a5d6196b9f131c393487cf4ac031c4017ad34b460f1935870b96"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d12295c691a2c2b6e6b8046560e03f4a1ce4d3b18f1ae34a15aaacd639419b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2353df9b3ea34fd59d9dde3d555085e7909d379a9d1b2f1da8db6f73a512f61"
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

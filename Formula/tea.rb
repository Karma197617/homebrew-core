class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.9.2.tar.gz"
  sha256 "edcd1e9af43c91c653b19ba2f58297b4815afd285657221282321ceb2930c537"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe269fde55927760636cf99b3d039fa4a63cb67eb00df089f791c7659ba5205"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e61aaa16503d35ae2d5efae7ee482d7b2f5086ed49fb3234a385415c43f6ed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51610feeb111b8f299d7badb970765746bfe337f2fff49735b7e2f3eb347b779"
    sha256 cellar: :any_skip_relocation, ventura:        "24cf5573187e565a997294d31ffc794bc36d9cf211430c4b971978d5bcaa7e7a"
    sha256 cellar: :any_skip_relocation, monterey:       "112dc527fa980db36b2232329ba77ee20aeaf5802c241d53bda3327418e01cda"
    sha256 cellar: :any_skip_relocation, big_sur:        "b52853ba566cc4d3dcd88a9ea5ef9e534f961dad787ad275002a99c919ddb26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06fd0c7f0aee84019f43ad784ba9bc390678503cb75e49510d92f971051fbbd0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    bash_completion.install "contrib/autocomplete.sh" => "tea"
    zsh_completion.install "contrib/autocomplete.zsh" => "_tea"

    system bin/"tea", "shellcompletion", "fish"

    if OS.mac?
      fish_completion.install "#{Dir.home}/Library/Application Support/fish/conf.d/tea_completion.fish" => "tea.fish"
    else
      fish_completion.install "#{Dir.home}/.config/fish/conf.d/tea_completion.fish" => "tea.fish"
    end
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/tea pulls", 1)
      No gitea login configured. To start using tea, first run
        tea login add
      and then run your command again.
    EOS
  end
end

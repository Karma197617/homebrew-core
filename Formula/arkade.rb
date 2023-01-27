class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.60",
      revision: "9c7df2b619a90f8e609bc959495bcdc65c3b9455"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c7adfb2795b18946d90aea33166dbda57cad10c2e5f14ad9b86992c461e5c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff5927d85d1065d7c6c9e38579c6d5378f4780522eb205d700ceb2a1ebf574f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7766f79958b134aa59baf1ed4b955810ab400030ab565da7b4950020ec1bae4"
    sha256 cellar: :any_skip_relocation, ventura:        "1a37908e6a3cdd1f813e231e86041d5d93a2b1a7c1e4eb6f70ac36d5f3696ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "fa8e8e70e696a33a18a1629f38c2f55e598bc720bbc3a457e928ce95b8ff0958"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9cd00097537133898497a45ec09ba55185e898122296b14b59e01a9876663e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00deea40f85b62b17a90876e256b5549617a8a8f39e29a353d7e8c8e392dca8a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end

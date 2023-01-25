class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.59",
      revision: "bdb3869d5cf87ccc0d1d2ec0c9ecffe113e31ce6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e6ba4cc5ae059f873bef043f6428ff699e1c394d19e6f3d0bdb6e7c07d90a6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d76a66db57ba13133e3fdeea5b965f52ceab167aae5e3b3949c12134f3c9188"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42a525e8785c5b6c0b7ccae548f23e861785271667ff5e52eb6809cd7e75d718"
    sha256 cellar: :any_skip_relocation, ventura:        "fc2ea6f18aaaa884d50d05605a676b8befc39756b682177443b21defce76cc2a"
    sha256 cellar: :any_skip_relocation, monterey:       "da341b4f13ae4d4d08f614ad1c4e191c3e66beab111c626d01f91fbb86e9240b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd4553a6180443f718295d64e65fdc922f4101f1faa3e5e3b948e2c8f50d934b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e717af90ddb40c58e2b8bbc8f6dc5743c8552c3a7d70e1218d72bda5d046a429"
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

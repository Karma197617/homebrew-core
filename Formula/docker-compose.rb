class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.14.2.tar.gz"
  sha256 "72f25596fdaf3bfbb685460c6003acd7ea904b95f12151f892bb199f985fa285"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb20e5eb08c04f7250af871db049efd0ef3a1616270ff4c9f6c3a0d35ba57f57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb20e5eb08c04f7250af871db049efd0ef3a1616270ff4c9f6c3a0d35ba57f57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb20e5eb08c04f7250af871db049efd0ef3a1616270ff4c9f6c3a0d35ba57f57"
    sha256 cellar: :any_skip_relocation, ventura:        "665a09161a6c440d06b343c9f75c9e0b3827aa5a1d71d598eb7e9d837c0fb635"
    sha256 cellar: :any_skip_relocation, monterey:       "665a09161a6c440d06b343c9f75c9e0b3827aa5a1d71d598eb7e9d837c0fb635"
    sha256 cellar: :any_skip_relocation, big_sur:        "665a09161a6c440d06b343c9f75c9e0b3827aa5a1d71d598eb7e9d837c0fb635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8209c3500a7010f50c90ddeb986a4c760b46455d4a25a7dff6946fadac7e56fd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  def caveats
    <<~EOS
      Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-compose ~/.docker/cli-plugins/docker-compose
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end

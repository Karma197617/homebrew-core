class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.0",
      revision: "e92dd87c3209361f29b692ab4b8f0f9248779297"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cca0f1578406ac707ad98082b42feb89aa447f549cebc7cad68efe758c414e09"
  end

  conflicts_with "docker",
    because: "docker already includes these completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end

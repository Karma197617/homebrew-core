class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23367",
      revision: "c8491913c3a318eba0e90aefca2ef25c04e12900"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34fedf639624760596d4a4914865fe23c73dc38ea9ad51884f5fc6d834444e3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82d8fabc2a66bbaad049a46cb9c16f0bcab491c4c9659c78ef92b1220dc37231"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29b3b361b820196887b873d70349d13d92858179441ad30b498e5c2e15d2f370"
    sha256 cellar: :any_skip_relocation, ventura:        "c3e922ac2828748d3fb199440b13da97d119cdb91c46590d349dc9053b5419fb"
    sha256 cellar: :any_skip_relocation, monterey:       "c6762932d12293e6820d3d807a0fd9478beb9c77abe97ca360876803d0fb7a3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "beab8d7748fa6e14587a6126bb467a8b67c135c2ef7e8d5884beb2205f1a8238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f161b433cf5b1c57f24634d866d8397763d425aefaa10f5b16769b3215cf8473"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end

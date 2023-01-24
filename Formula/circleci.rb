class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23241",
      revision: "35d81d42ec8031cc8d210d27569c9dc23f205205"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be76b95f4f78da1a6c1a1587d4774e4fb0a96391ef05b2a8cae2f5dc24e7f6a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fbcd39a0adb96f648102a26901929009f77fe470102ffddfa96b65276e29830"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e36b23e10639aa17f444b9230b944c0b95c2c11cc9087e273f54c6b9d95aed7"
    sha256 cellar: :any_skip_relocation, ventura:        "3ffba433779fed7d0ee39ec7a9e490d95681391a149655528bc9f9bf4c3ccd1a"
    sha256 cellar: :any_skip_relocation, monterey:       "597f77a07dbd99254eae886cf0a66fffb29c8a386039595920d388048a9ecfa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e193ea74b1c353facd87d3b37164720a74cd4246ff04ad3c7fafc1ad8596972e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a4342e103733b051d460a6cd08b4c3195a877a2d1325fe220e326eb8fe79c6"
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

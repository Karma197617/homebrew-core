class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.13.3",
      revision: "ab00f35f0f718ea87dfe077ae1b06286b4dfce7f"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea2afc025a8acc5a40bfae0a54c98c6ffa1020f11fbe3cdd7f3da18d75416570"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcaa926797e7d303e78dd133598e7bdd1c3ce2f6d63fb475a3080f33498411b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01a122c5b2ebab5b26b2c463ccc28778fd5eceb8a2f6c989fab84dd9d776ca5e"
    sha256 cellar: :any_skip_relocation, ventura:        "c39eeaba38aed6048386c2a95da0cc5eb262e127c8f5f1fb337690b5763edc6b"
    sha256 cellar: :any_skip_relocation, monterey:       "fbd35ec3dc2adea607f35e2beae2fbcb1c399a8c8d4c94d2216676fccf8e82dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7529e7387f7a9d75f615bffa6908060b7c464b633ea7e506253261ffd61b9da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672a20a2c8cf1823693737c63160861be53ec25a6a534dfce465b8b3dab71fe1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end

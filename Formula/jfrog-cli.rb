class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "97fbc580dfb0285b6e32945aee86d90fbf5b119294f16e4117ba377f1a7bbb1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6145bd3affef8e224dfc7143d169b8742b23f72ae16afcf549ee8361e2796f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4caafdf450ad9c502f106f611865fa1bd0d58cd9283f5ca4c3315b8d4790d76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa69e4fe131352713d7262bdfd674ef28beacf500746c62fe12229fb1a1ce40b"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7e9e3453b5cd9be300e920a02d3013e441d3f0a149d62d38a0187634e7a212"
    sha256 cellar: :any_skip_relocation, monterey:       "409a6c0145d9b549b4479c053c43f20a9fa644e3ae98781f2a6288682cde3f12"
    sha256 cellar: :any_skip_relocation, big_sur:        "6837c8b5193c715db4221cf9409a154241733bebf0eefb22c848b4a1f99580d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a15f983ee5c7c8d65e3cb80bf09029376f6aac4392eceaae23841d14c02d6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end

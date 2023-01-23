class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.61.4.tar.gz"
  sha256 "8e2f626975cada25e507d2bcddc1f1f73337ef005c95af2fe2a9ba01750fef65"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b608bb1bb586a493ee07f1a8ccdec1d2c7d078b2fd1050bdde60aa03c9cc8512"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec01dc62af54039736a448753f97e94a1b711a23ac8a70ce34291b1fe8d9b32b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba3a5c0c4a5fba1f570109e11c594406293e6a4a918336ebf7b19ca5e92b4f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "82cf8a68cc500f8e10fabb004820fd01c238160d8b3746092daef82e7f019b82"
    sha256 cellar: :any_skip_relocation, monterey:       "b81a9dac88f696781f2d4d4543d0e122901fbc74f97f50b0dd107f938d5960d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6511a9db063c52eb9eaab2cbe1a458951a9e71d21b3aeaa4873f91f804ee0567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea2fdd26142bac7f0d0a4a93d88c51513e9fd98f94a54192017059b388b501a"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end

class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6a211818dcf544967516255f6ddf5599dbfb23437226c8b4db306d9e492a2881"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "375c1e6b9dfbee2a4e0bd105cc713a0fe4f72f13b71834b02d69098a54ba838f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "375c1e6b9dfbee2a4e0bd105cc713a0fe4f72f13b71834b02d69098a54ba838f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "375c1e6b9dfbee2a4e0bd105cc713a0fe4f72f13b71834b02d69098a54ba838f"
    sha256 cellar: :any_skip_relocation, ventura:        "91a2bfe1595bbf1300b72bd7c81e25072c6ceffe357457df815c87e4a805f046"
    sha256 cellar: :any_skip_relocation, monterey:       "91a2bfe1595bbf1300b72bd7c81e25072c6ceffe357457df815c87e4a805f046"
    sha256 cellar: :any_skip_relocation, big_sur:        "91a2bfe1595bbf1300b72bd7c81e25072c6ceffe357457df815c87e4a805f046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72b02559723af7c5701ec7002a8650d9e97ebe68132d8c7a92136a2cdc5dc201"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    str_help = shell_output("#{bin}/okta-aws-cli --help")
    assert_match "Usage:", str_help
    assert_match "Flags:", str_help
    str_error = shell_output("#{bin}/okta-aws-cli -o example.org -c homebrew-test 2>&1", 1)
    assert_match 'Error: authorize received API response "404 Not Found"', str_error
  end
end

class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fa112b96c7cb11afc60624e0cdbd2f80157b09c7f0dbec1ec3ba1f92ea7b8f26"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af03f295b07c463feb8ebdd7a4cba0594916418dbf46761abf5c330181ffcb78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af03f295b07c463feb8ebdd7a4cba0594916418dbf46761abf5c330181ffcb78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af03f295b07c463feb8ebdd7a4cba0594916418dbf46761abf5c330181ffcb78"
    sha256 cellar: :any_skip_relocation, ventura:        "aa5c2bec588ec15249d88fa73969e51f854ea3601521eb3491162c081a04efc6"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5c2bec588ec15249d88fa73969e51f854ea3601521eb3491162c081a04efc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa5c2bec588ec15249d88fa73969e51f854ea3601521eb3491162c081a04efc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a58a7d9bf33a669cf41007e6c54236c179f53e4bece76cef4b18235440aa01e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_hcl = testpath/"test.hcl"
    test_hcl.write <<~HCL
      resource "my_resource_type" "test_resource" {
        input = "magic_test_value"
      }
    HCL

    test_json = {
      resource: {
        my_resource_type: {
          test_resource: [
            {
              input: "magic_test_value",
            },
          ],
        },
      },
    }.to_json

    assert_equal test_json, shell_output("#{bin}/hcl2json #{test_hcl}").gsub(/\s+/, "")
    assert_match "Failed to open brewtest", shell_output("#{bin}/hcl2json brewtest 2>&1", 1)
  end
end

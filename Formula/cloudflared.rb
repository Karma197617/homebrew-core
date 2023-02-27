class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.2.2.tar.gz"
  sha256 "b0abaff125d29c517894f6ea74dcc7044c92500670463595ba9ff4950a1d2fc2"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb97844bdc3edc7ed96cbdf1d1fc1355e045c3bebb275266bbabf77a873f3caf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcd537c9734e752786c676f238f4aa3f0a9941c7ac3f9ffbd950a62df0bd6b17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40d5b2d2dd8db389408c161ee601254e24e0786af0552812a4e1980725224808"
    sha256 cellar: :any_skip_relocation, ventura:        "f4dce8ca761d4b05af33638e4e4728295b95b8d4b993e5b86a2e0a1cee9c1087"
    sha256 cellar: :any_skip_relocation, monterey:       "cf28d662c52274d8e499465fe12de831bd7d4cc590b55a0e175d00cc55f61b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "09e451f83cd0c270b55e47edc4ce404a0681da060699a7a78013056094db1754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c6a1d7a07c3a5efa7be8ddb87cf3fb44638f2bb855197893c874d4f02620d1"
  end

  # https://github.com/cloudflare/cloudflared/issues/888
  depends_on "go@1.19" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end

class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.39.1",
      revision: "d40d4b4a04025e12a96d9e75534a9e40c988c568"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60d7054f466c7452b882dbe440493216821bf599f3157f6de1fea0c3fbc424fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e9c4ecc22d83ce37e803b530704b8ae0aae21fa911c776cfad4d3e0f9e960c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "232a8389314598bba9bb8dac81d4dcbaec56a5b1ecc97fd027b92c39a6e2f01d"
    sha256 cellar: :any_skip_relocation, ventura:        "db0af8a7930de5a3d97f0e3dffe04e9b7d801db7af4f572aea8fe208cb76d00d"
    sha256 cellar: :any_skip_relocation, monterey:       "4020ba0ba03562343f078374cc5f3e3537a1cbce1e14043d6ef8a0a61200e4ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a7527f7d851a6485841053d359a75208b56a362de540cb274d2709cc71e18b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab164dc880c92ceb6545657369d1a202db012384dc0d9fed2f3f0afe7d0a541"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end

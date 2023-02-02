class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.40.1",
      revision: "a681ef1703e792f06e70f2386dfe30038c071b10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8ed4be9bcc61ce1a9e33966c391ff290284ed8af3da5af8f4fb3bcc7ef7eb98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0a8a1ea97644085cd713c9fa9314aed2988ba1ee79c387e38b2dbfba147fe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a58ae615442c9fc2a3c1fc6707926a039b52acf664c3dde1e0f2c35f64d8e825"
    sha256 cellar: :any_skip_relocation, ventura:        "bc12eaf809aed4516929a679f4d1154436324d226242fd9ab89f09285c97e1bb"
    sha256 cellar: :any_skip_relocation, monterey:       "ae26e0d87437a2f8ddf87a5c06ab01973633c88ab2a0b53d0abfeac0d6323fb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3da983054e8e187f1fc6f1444d7f756425751d91a17333de681c26e094353c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16303af77bd5f2743dc86bf7683eaf236b98c827be909b1e961522cd52eced70"
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

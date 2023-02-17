class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/0.5.0.tar.gz"
  sha256 "37a045a9ae2721e64ee10dc4f789cb22aaea2b182e1a19a9853fadd65b218a25"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b9e1e398be4f399e983483d3effb9dc9d33c532386154c8cde7ef8829c14e66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c486a8f7a2cb1c8aa3fdead5285c7205d0f4ebdc0cd8dfc1767ce5274644396"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f78ff844cbd4934d7ae17e1b975fedf8f0152313e85dd0fd9f4a4ab980003443"
    sha256 cellar: :any_skip_relocation, ventura:        "e82dc03cd04c6767cd0fb63a532097d11677ffac5bb24695042930885966a397"
    sha256 cellar: :any_skip_relocation, monterey:       "f3ef78af3eb235875dfe8cdf97ca927c4278a3cfd11d0df07afc4772451b6964"
    sha256 cellar: :any_skip_relocation, big_sur:        "caf0736286ffc1bc5e9724a20366991f86fda37684dff848bf63edb7e3d009e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f55076492ead6f6f260b4e5a1a75dd3b66f727507fb875d2221f158c091c1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end

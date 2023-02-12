class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "0196b68c9acabb7a34ff9885b8da863e19ccea99cc278f4a8619f5b75befee7e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89e91df18f3c665761fb8b9345a3c874f85a6e004afde61be30359f67afe1afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5572e3cc39fc9b8dbd05281c7f4c450f09677440219019a54faff6fd3ef4ed92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cf12e0ee830f123408c8c03043ef3b5fe2622b7a554f74b4ab40f813c7b78ff"
    sha256 cellar: :any_skip_relocation, ventura:        "3e6b42f9f48d08b27e82a7db05fdef0bec6dac4cd2b1c2c3ce276a16c9f7a476"
    sha256 cellar: :any_skip_relocation, monterey:       "1048b4d9c02453cfe41c5c55b2af881ec9edb977d0b56e084a9d17660deafff2"
    sha256 cellar: :any_skip_relocation, big_sur:        "76636bd574bcafc694d3a3fc6dd04a90431289ede8025d4223871e9270186558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f544eafb7c5305111787320aa65ebe4cebb246641f1f81bedd41ba3e44d36923"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")

    http_port = free_port
    grpc_port = free_port

    dtm_pid = fork do
      ENV["HTTP_PORT"] = http_port.to_s
      ENV["GRPC_PORT"] = grpc_port.to_s
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    metrics_output = shell_output("curl -s localhost:#{http_port}/api/metrics")
    assert_match "# HELP dtm_server_info The information of this dtm server.", metrics_output

    all_json = JSON.parse(shell_output("curl -s localhost:#{http_port}/api/dtmsvr/all"))
    assert_equal 0, all_json["next_position"].length
    assert all_json["next_position"].instance_of? String
    assert_equal 0, all_json["transactions"].length
    assert all_json["transactions"].instance_of? Array
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end

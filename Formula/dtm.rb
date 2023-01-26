class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.10.tar.gz"
  sha256 "6124fc1c4dc57de0ffa5956fb8593735965a316217b02be59463fed150dc1f6d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f402a261a1adcd2e48af9fc604396cadcf7fdafaf3efcc9fdcb97a9f302fd216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27c27031ac6e92b054e0489073a81a7c14ecf4283b915ace8ae38d6afddf346d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9228d534316c1303c28835bd7bd07088ee1e40eb8ad310e1618948573485d75"
    sha256 cellar: :any_skip_relocation, ventura:        "42a504685f0cc8506c65b8f1ab8bc7e4c0f747f04c6d4f5bfc43bbe349d3db27"
    sha256 cellar: :any_skip_relocation, monterey:       "de489f1b2422ec398f6cff9239301406f5e251eabbaead9e5d596050ef7684c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "38ce1abaa3a722e8c6d1e4a5b44e90626a0eaf4a231b475725b024f5fd88c657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7b4ad05d9276f9d704a37c2b0cb7644e93e3b2ea18c00f1a477ced195e5dbfa"
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

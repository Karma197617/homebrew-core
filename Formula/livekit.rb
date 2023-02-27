class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "ab06bf5158e1315bf8c3e26fc0f92581eb93ff530bdf5aa9ad001a73963ffec6"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "325534091d006cc5a05eb390c62bf314f200e9b706527bdeae4cfaf435bb995d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "137821397d60511f74e6618bf701f5eedae2ea2fdcda81ff8028eca4de348e16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2956f0bb2bfaac98a0e4394a1a7a10b640809b51fa33dcb2d8fa877d7636836"
    sha256 cellar: :any_skip_relocation, ventura:        "989ada1f65dbacc67a61f28f77dddcd33771542c2b33248f415d6cf4d608605e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9fa9509da7b1344129e777229a7b061e3f6025c4820aadace335fa5f83d641f"
    sha256 cellar: :any_skip_relocation, big_sur:        "81e5a648fbcf15e575508fdad14aed3c5abf9c3edaeec28bfd1ea47758b08490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5cbd247f5bd38eebb177436281aae5647a926837b8b13741bab9724f646d51"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version", 1)
    assert_match "livekit-server version #{version}", output
  end
end

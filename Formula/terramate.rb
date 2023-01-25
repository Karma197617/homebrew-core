class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "1f20979eca05413465e2949faa3f491bd82aa7d74c3c264771925a83b5b7728e"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e38ff431aa05e3f7d82d18ddcfdce81f0c362b9c63366c152096fab2207f8607"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7ae4cb2ae71c94d2e03e6df8b4baad065b707bd23c8a9fc08004a9250cc2d27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f48c9e064212c78cc54e84faf34a36358fc645e5106291841d92e0d476b9a97"
    sha256 cellar: :any_skip_relocation, ventura:        "f104bbe3ad1a75a05b53ecb1ecccaa44c98551d68d86a968de8f690432b4e39e"
    sha256 cellar: :any_skip_relocation, monterey:       "304b143849a056adb99cd7c2abd3b8e71a5853a986dd85c9ebc184c6db94702a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a1ae29edfeac56d0b6e38b6794947f97d2dff14021df73477319c7bb8a73304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c35650babf9498cd73abd986aba2c5650ec2d1e45d592ec9349b98e91c34c99"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end

class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.210.tar.gz"
  sha256 "2c07a46b65283ccb68b7afa6485a3ec6846159bd9f885aaadf5f6829a628cdf8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9573eada5e180c66098ef5825f8e29751f8aa163410766cac6b7acfb9731836e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95aa84ae8bcf1bfc375ac4f9a6da1d5ebb9c87cda98c5a0978c5d1cf063b6811"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b16ef9f24d2e438dec6331a2e811bcbacb390c4afcf13096a9d02fa853c9de91"
    sha256 cellar: :any_skip_relocation, ventura:        "e306bc9ea466f1fc5cef672b162bc61ed7a0b9a45ff8bf0a9311e79a3ac7482a"
    sha256 cellar: :any_skip_relocation, monterey:       "b759c8abca82d5a638fd8777c8318aabb02fb94058f756ec3fccac12676ba0e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "531400a461c5fc856291367699584fa4c5712191f720f88de868c511d0aad61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed187f30d18162bf90a5e251d8d9074b7dace029b7bb7cd734367192ab87bf6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end

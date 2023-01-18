class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.197.tar.gz"
  sha256 "23cd6aa15c5f756ad2b60cb5c832b50dc59dd7b4f0a3c043ac1a4a3d3945cb90"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a597697b328d0aadbcd76060a687b477cc3d96287066fdfd46fd7056d0005cd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f87f8754fcdcd1fc84c6e66e3da5d78819e01dac079522eb69742daa0cab93fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46542b0e00faa8561705693c3e4468ab457bb4c8dfc77daa4c3b9434dbf089ae"
    sha256 cellar: :any_skip_relocation, ventura:        "0d4ed2ad7a2d4eb304d0679328ba3521ca19774a543eeb53fc8be8f88f8a27c1"
    sha256 cellar: :any_skip_relocation, monterey:       "97caf603eba113d1a9b9187c3997b9b3e6eab0156ed4a2685633ff6229f98716"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8355dfb4c5b797bf5a5d9af9b5ede0cdbc700a823cdf66bb59de6e62b0a9fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c115f1e54e4e1a07eaabb9d1a4d55e9736c94f0334676377f1264c24bad09d"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end

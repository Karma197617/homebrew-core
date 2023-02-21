class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.202.tar.gz"
  sha256 "b15d32f2f6b259d2683ad94fab8e27fff01c61a25ac3db564c0ea60bf8bbf0f4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c5be3d0ff1bb4e717b926c49971379272ecb144f54f039af952a0d8288a402f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc8fdab8a28005dba279123c8a25d932bf96c2c7bc2600431aeef265c574d39b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ad9a74a5f36f798e09933363e70d1e080a49b9d75b8a065b25ada911c338b6c"
    sha256 cellar: :any_skip_relocation, ventura:        "d2d94dcad59ca62b37a61fec444336b94b30044b2df509e4e4581e735b1c9595"
    sha256 cellar: :any_skip_relocation, monterey:       "1cee5bb250f8604e7114db93c45d31b8038cb4fca07e5c17d227155a0ab2bb3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e11eb4de3822f5872625616979e5b344a81ee0c6ae371b779aaf270858ac312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48a1ac3b46afaabc4d59851278a43b382e50407e3f2d3fe0a088f1086df2e923"
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

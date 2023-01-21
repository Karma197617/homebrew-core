class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.198.tar.gz"
  sha256 "11015dddb16740ca266e7c7b7c44ff0252a193576ba3a58f8d3fe75ab587f3d1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e684a97301d2c30cf6e28bf0e1a3c29f5af18131c11412e85355fcaf17a8a7eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95416cd6e3b2f7aae34c1c7d1baa8145fff530fe33f894efd49a1a0e3bc35c6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fb014888150534fc0ed2268f3579759264aabd5c6a594ad6d50c37731938b0a"
    sha256 cellar: :any_skip_relocation, ventura:        "d6b1df8e0fe1214a2f23947dc71565d46a2feb19828a9624324f2b5fc1599513"
    sha256 cellar: :any_skip_relocation, monterey:       "8bb3ca75763199d3c5cc6c2541f93bb9205c5d5e5ede21a677fa79c497a3fdf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1f7216ea9c4ce2b01ebf149c2529a368f755d1fcf66693fc8a697b1c39aaff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7822639eee650d8d4d163fbd6bc2821b06c8ab2d771040cff0b291b9dc768f"
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

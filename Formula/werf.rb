class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.199.tar.gz"
  sha256 "c45332e71c0c6924e630bfc5afddfbc7c81093fa6b612fd52d0505cc5593cfd5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eedd17dbd0e3308865def221d88979b9ac586d51e14308ea185775ac61514ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c694d83a4994e7932982725506bb948f0c2bbe5aaf1a5363ee8e9aa84b661d1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e762bb5a8309dbf635965c2c66d49d35a885b877d3dde605bcfa877b1f13db1"
    sha256 cellar: :any_skip_relocation, ventura:        "37c5fdb362797b488f332581a05aa9631f063dcefd24d01c943aee293469bcaf"
    sha256 cellar: :any_skip_relocation, monterey:       "05f76588457cde5a8c517ca77a597af94a7398582bbcfd6a93741d41408eeeed"
    sha256 cellar: :any_skip_relocation, big_sur:        "95984e0a5f2a9f758a67e95c80e5dc229803651660849e7a409a5970604b4938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fffb71b37aa94d8485c7b55f3280569e14595bea8cfb3fad5cab2100199821d"
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

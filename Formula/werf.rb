class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.204.tar.gz"
  sha256 "f0c8b9d674b7cef57f098a976075cb2b6f47eebef8e0d494015221f72fbf7078"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2a2b0a7c15c920906d0ce862e9a349cfaf2733a5d1f128fb7d7026e36cfeebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2de91997e04da696af6086c6026b9f43cf8cd99668485b1a0b83de510a9b9dab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11c2de084bdfd0f0f652fb662a40a6269095e131d3b6e3f8932ee1eb15368100"
    sha256 cellar: :any_skip_relocation, ventura:        "75d2fc6426c96dc95c2a310bcb5729fcc3e05d6a4716173237801c05f09b262a"
    sha256 cellar: :any_skip_relocation, monterey:       "5b72137f4b0ab889dd31f4dfca202688ab8ff4b6c37b8039402f976ce5f3f507"
    sha256 cellar: :any_skip_relocation, big_sur:        "199aa5dc2452de3176c623ef3243d75a99de795b19b06d5bdc04086115fc76af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2eacda14031590dcb0e2f35cf828d612558e3c72d0399443f694818aced033"
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

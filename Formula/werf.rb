class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.209.tar.gz"
  sha256 "5fdfdf369548c3ff15fd3260c7d272a3103b6db9568666137a63fb3090ab1c7c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16433766d7f288f35f91ad02b088ec1cc246d96770f60aaae766712ac1112a37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5651c8180ab98a6f505892e82ea15b889bc9fee1448bf31781263563f6c3360f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f74674a277e1486d358cd15102fdeabef847bbfda4b602f706e5ba21cc45278"
    sha256 cellar: :any_skip_relocation, ventura:        "60b2378dbd285798f80961bdc1d0a68636f4cc442229c59082397041aa59d9ab"
    sha256 cellar: :any_skip_relocation, monterey:       "13dc1a82755b1b1a5466c35f8b87d2e83df9fd2ddfe00475c8f2006c00ce5220"
    sha256 cellar: :any_skip_relocation, big_sur:        "5938014fbb9f0300f5958ec2ff30601e4ff1207ee5bd3d420006f8077c17d611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffe553870199db39019ba69938528e7ac771fc344385fe629cab7a31e5e842c6"
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

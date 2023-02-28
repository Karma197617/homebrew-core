class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-02-27T18-10-45Z",
      revision: "0ff931dc765d5d8fdddcdf7687fec1b0b194fca9"
  version "20230227181045"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b7857691d99c35055278e4643a51d12d8d308ecf51e1ae0681a81dfdd81fb65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41fda85bdc84e446e8b78fa85e15dbcecac920c876d480f3b5958e7c4839e91e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b12c35a86da88fe34083fcf245ebcda86f0b5843cdfc5956585cd925f41aa560"
    sha256 cellar: :any_skip_relocation, ventura:        "ed8a7bd85d50e3d94f914e2782583f63d1d3e8eff1d30d0d3675fbddf4b40298"
    sha256 cellar: :any_skip_relocation, monterey:       "6dcea24006edfca62d3a4dabcee1f6802af85cde4bbfb5fe2d19ad959aaff8d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "44ab8257b969c965e66648a22585c942f21ffe5d6dafb359333d1625c487b523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bcc607f5043052d97f9fedb560e23aa5b09edf246d4153ce87c85d5c94d6ebb"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end

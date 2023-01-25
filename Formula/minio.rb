class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-01-25T00-19-54Z",
      revision: "50d58e9b2dbbfbe2f3afa2c16ae701f9c1cf03ec"
  version "20230125001954"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bb4bfe833bbef4cc358947f699ef8fa8d49372b9e859dd13e833ab2123050cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac470fb5efc7da77584e13e2efcc71e204eef17d9764275954b2382c9a565e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81c416a13c34149c323bb849557e69684101f75c1624748c6692dc6999a3acfd"
    sha256 cellar: :any_skip_relocation, ventura:        "d5271ba660a5d5d236117df82845e390f85e2386447632063d595864c9fb811f"
    sha256 cellar: :any_skip_relocation, monterey:       "e943fb1106b18a7f3118e4aec1335908ca442a50bfcc1324fd446a88dc1aa4b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b02c4ee935d736c82a2772f123d7ae8ba01fab6b58c3919ccba117c0db293443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d468f9c41a8fc6ba9ee53e4c33916f9b8dbefdd694bff8e5c0eb103740f340"
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

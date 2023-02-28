class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-02-28T00-12-59Z",
      revision: "5fbe8c26bab5592f0bc521db00665f8670a0fb31"
  version "20230228001259"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9430f9b755fc437a8489d7b5fa43cbfe012b4dedad27bb593e9a989bd2bd2e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b5974402af462c2661c3ffeb58d5ed87cd2e5d71bcdb3859bd3fad20015b60c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd04f62b1e6c83a9a38d07e5fd54e5f6d73c511429e8f0110902b4a44dfdff5a"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f17ffc4c8972b6b7b15de77a88c0903addd744cef54fc4bc846c869e1198fa"
    sha256 cellar: :any_skip_relocation, monterey:       "064989657a71a33d6179ed8aa92a8be2e8132b36e58a1ef2a47792f6558f5b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6d81b384de40ba8cf8672dcd526f29093d6b02cc47fa08d72e5fd7405d52898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407fedecae27782ba0c53618f729bd4ec17d41a1faa430922faee80a036885a6"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end

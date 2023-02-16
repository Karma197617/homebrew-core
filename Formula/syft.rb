class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.72.0",
      revision: "2642a3616170ccbda9d8c8cb4f4a6b0fd5c63da9"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db9357a585ba601f8c1d102c87fdf9a5dcb6de1325e64ae680c90e3517bc54f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924b9a5e7f26b44e137cbc1cd19b1272011696a36500ace00df181b8233636ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "686ea41f644469c45f5e850eea7e725620c15b62d1fee76ff9a7697b6ad35bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "334bf5b8afa0316037a9936487d9ebcb0beb70994cb40478f2efa8dd9e58ac25"
    sha256 cellar: :any_skip_relocation, monterey:       "b51706dceb872fa2afafdd171885dc96b42d553d21a0ee2c6cc81cd354c7f1fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "5539b80e2f10b9408bceb1fe296905d7beacd61b4a98f8f9ae304317de74b39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9ead89fe55b1cac642cf4276531e58ec2235b7b8e2704f63b1817d8e1f3e8c0"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json" do
    url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

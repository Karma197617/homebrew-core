class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.71.0",
      revision: "88c81d33edc67b0b9636d0046417a9373ac8b74f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d13f05c5ad45e0721ad23546033c1a8f03bbc678fc15a96b680c68ff52474dda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883f0c0af99198ac670e96606d98faa12753a7abc2ef0d4e418bac726700b86c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ff69cb90a3138c468a661c0f4ea3baa62ec29efd741e42345efeede4544972a"
    sha256 cellar: :any_skip_relocation, ventura:        "a1a9cabb4c3778e4623ba750d94fec8babfc921edd82cd0988fd470fca4f6d5a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe6d5590fb5b3cbeff2e0878073b23886eb1d4b6e56106fae2dd2cf80586808e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1777b6753e45241d81837acf23c2e3b01dc617f075e3455198cbfe676da8cdc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ad2b03745c71523574fdfe6a46b5aaa1aedbe51f6964da355e214aec00f6dc"
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

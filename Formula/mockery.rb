class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.21.2.tar.gz"
  sha256 "1e718ee5955e7bc328eb8c0fe889a86970eef73dee80c3182ebceb039381ff1f"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ca01e2815b5cbfe186e507e91203e2cf2af7cb088ced4009621d7d310a77621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98952428e03f7362b595812915190200de4e82106bb4b362cb99106e7db36f25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82cb5200f449579536d377c683ab1ab159cb3c3e114c8596cdceafad0c361e1e"
    sha256 cellar: :any_skip_relocation, ventura:        "baf0ab0ed95fc6cdf85e4f0b8c6f2a0435191c2e4bc08be27169e0c23a7882ee"
    sha256 cellar: :any_skip_relocation, monterey:       "935cefba0293422bf48ca1875415819111118865d62358403b256089c787ff62"
    sha256 cellar: :any_skip_relocation, big_sur:        "48384ea7546279281df9013b1c585a2bdfb24edcb9d148ffbb0540aa5872accd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ada21ccfd58cff98df5bcc55b6aa1afa95e81bffeeffcbbc242e22e35112cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end

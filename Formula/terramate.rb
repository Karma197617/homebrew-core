class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "ddeb56579bd8cac2c207f6db84da221ce49d047362a4bbe01393112feda435c8"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "531651acb1b3aaafd7dc1d36f720c96b4b149c2bb22ab94c87cc55b9c44c4710"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bab762ef244eac1453b116367f382603265129c186907817e4014dde47f6640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0232d0df001961b3c5eb2730994eedde14cb15eafccae63ccd221ec77e6298f"
    sha256 cellar: :any_skip_relocation, ventura:        "b7e338289d01509b4cbb4c32460251bb58c78b5b9eac2d165281442d4849469e"
    sha256 cellar: :any_skip_relocation, monterey:       "d7c8fc297dd9082c4f140d77bb29fe7dc9dc289b290bd5f87696afce325c513f"
    sha256 cellar: :any_skip_relocation, big_sur:        "08b0d86f891be46ecc7978359cac1330a07c1dbb017ec842e86194503098862a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a2d091d16500bf95d184602000478cf548576b4a1faf385787bbe1a938431f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end

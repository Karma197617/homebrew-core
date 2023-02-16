class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v3.2.1",
      revision: "fed1e441b187504a5928e2999a6210b88279139c"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "612676b23ab2b5d6448b3a33e195a9029304d1c5783ec67986b55d17bf28b02c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "426a80dffa816ab8e633eb98844f188d0ba8fd669ed21009e136bb592ecab11f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20996fb53381c17ceb337e999463a3120950b01aa26b293e3649cc790e223bdd"
    sha256 cellar: :any_skip_relocation, ventura:        "783670862825e7ceb8b2bc37e8666c4f04b3bbd111e4da8936bab31bc4be94c9"
    sha256 cellar: :any_skip_relocation, monterey:       "e3693175d40979df3960ac7495c6840403fff0f72cbf6e1de045a82bbd6d2658"
    sha256 cellar: :any_skip_relocation, big_sur:        "a787fd2d9b1e7e43ff1ecd15a19bc6223c266670af407dbb21733bfad4e749d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3daeee17bb86b43a87b252f52d19690f3a2aeaa545a4b32f174da5ec09cacf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v3/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v3/pkg/version.GitCommit=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"regula", "completion")
  end

  test do
    (testpath/"infra/test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    assert_match "Found 10 problems", shell_output(bin/"regula run infra", 1)

    assert_match version.to_s, shell_output(bin/"regula version")
  end
end

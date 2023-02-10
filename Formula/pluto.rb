class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.13.2.tar.gz"
  sha256 "332708441ec4a04f8676eb8411e5a34fd5779a4a38f944b71e5e906e4e32567d"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4dec7132df04bb2810a85c74fdd38a526998b8931a30ae5f618da08927d379f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8bb52d6048d7b3ff942075242e1a2a7aaf902998d15a0b8df6be72e91b8d8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f945ca015d64774bf5c2375f4b98ce2b0f1b8978f484e333e4cf923b9e57d53b"
    sha256 cellar: :any_skip_relocation, ventura:        "ecaf26ef72bbdab50ccf2992fae509646318907aacbcd8dbcf33eb7d9ec69736"
    sha256 cellar: :any_skip_relocation, monterey:       "752653f016cc98d80c3d82dad7e92765707b0770deef45ae62d46da2ddf0039a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3f2e489517b2b8cdb00e6df030293a1e216e2b5e9969d0f1374c475c622febd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b533d6dbd7213d22f9934a286ee257c483a84123fe6ffe13f696a435a5a6f5a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end

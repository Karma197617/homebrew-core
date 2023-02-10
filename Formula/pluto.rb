class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.13.3.tar.gz"
  sha256 "c63f86ea3b309025372c844c0f3543732c52579fd94cda46c78513c311301c7d"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89453449ed79c8fd0044c6f21a1121098aaf059b6c618c97c28ade6ba79390bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b2e4a33fa82b47db0faceb6dafd7e04cbada31f8ae98d4c2e020a772d80d8c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f4cac0ec78978823339b630f216234881f7ccfdc34ad2732473bffaba3dfa2"
    sha256 cellar: :any_skip_relocation, ventura:        "c6b9c267e5174f84b676c51d72e82d7b516128f6cc1021011889d0abab6b16a7"
    sha256 cellar: :any_skip_relocation, monterey:       "d0cda3aa87ad9a5dd6b9a4341a7f72679237797945023649953e18a01e81eddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c610a8bfd64467fc3cf0912dd8ff2243d5673e264da10d17db6a9a490205b939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfd7afa375dcf135fdcdbecd6679baae7b909e4b9d76d6e6b16ed7e987129357"
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

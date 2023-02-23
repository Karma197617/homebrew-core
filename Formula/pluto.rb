class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.15.1.tar.gz"
  sha256 "a0c294558bfd05679f499cbe700c88ebe895856feeecf7eb9992033a316f2580"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d73bb56447041820824424c0f7cb9dd77edd861d75d596323205ac1e664e8aa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0b208f268be7b68cd6dbd1300a9dfe823d76abca61108e26c04791096e5930"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a1c21f75b937468884fe85b99ba06b4cfa923d8e5f15f1734c670a4f8964bf2"
    sha256 cellar: :any_skip_relocation, ventura:        "3f191a551c8709affb3db8862bfb730a294aff6842aa3b07f583d3bd6db96d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "f51076268908479b4c0ac256ad250f8ea6bd120ac121acfa4a498ee3d1b48ef5"
    sha256 cellar: :any_skip_relocation, big_sur:        "07adabb5cf54b33ed310953d2dd10e63738b11dc1041c00ac572043d00461bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8e3e1691d255d96153c4a274918b82b4561fdc48ec2a238dcbd92382352cae"
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

class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.33.tar.gz"
  sha256 "b080916070ff7c0ab51e5b31e7ce99105413dc693ec0e37fb48af6bc1d81931c"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03190cc75f65e11b375456ece3d05828acd04aade34667a0ddce93133caaee40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e5cc52823ac394de3ef5f7be5123abf061d6eb40cfa118dec5fe8ae878346c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cca3218380d7914409d58d8874ac6725c39c5775130e738e33892384241f0872"
    sha256 cellar: :any_skip_relocation, ventura:        "b4edb9b8688f4f537f1fe0a57c0f8978bea9558235d847bca81f529331dffc5c"
    sha256 cellar: :any_skip_relocation, monterey:       "9f8d234f4cee17aa7d15d6319cee177ccc75cf47aa42e22c4acd7800e4ed78e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "570e1d15aa28afaccace9523a61a8bd3741f722917a6af7e459e0a1c66c93678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a27388cecaf955ff05a5aeed905533d1c9d713fead1ddc216986fecc2c508a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end

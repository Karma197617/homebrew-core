class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.31.0.tar.gz"
  sha256 "7d59f3a1a57f76ae675b59d57a1f4048e974f5cc02d3492460a21f5c7737bdcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ecafc7dd37b366acf36b2cf28e165749bc5a6c7c8262150e419a527bffbaa93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d8b4b3a0c4674c1387f44c71a54978a9fc0ea6d2695cbbf1fea3c41bbcda37c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3f5d0fd5372709734804a1d36d4c052b07b46de3e4bf7b57a3b65b0082f5898"
    sha256 cellar: :any_skip_relocation, ventura:        "c359d2cd68c228d80174d6abbc36897f530d87622ab3d14381b7714182f50ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "85f7ccfb8adc30c88be2f5ab5f414fb28aceb4745974e17080cf7923aac24f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1728b870b871e555b11ade159dc2eb5bb69a175c00a5ba34da1746b01a1fb624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5416ab6e5ed106a56f1a703928993f90bfc4f7fc0b84946b82a0a8875de184c2"
  end

  depends_on "go" => :build

  # patch to work with go1.20, remove in next release
  # patch ref, https://github.com/thanos-io/thanos/commit/8da34a1
  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end

__END__
diff --git a/go.mod b/go.mod
index 753af22944b10318963c5cc46ab58ee15f247232..dc0a2da25dc6e72483f3559fd4f84d8007b35b60 100644
--- a/go.mod
+++ b/go.mod
@@ -126,7 +126,7 @@ require (
 	golang.org/x/exp v0.0.0-20230124195608-d38c7dcee874
 )

-require go4.org/unsafe/assume-no-moving-gc v0.0.0-20220617031537-928513b29760 // indirect
+require go4.org/unsafe/assume-no-moving-gc v0.0.0-20230209150437-ee73d164e760 // indirect

 require (
 	cloud.google.com/go/compute/metadata v0.2.3 // indirect
diff --git a/go.sum b/go.sum
index 2a5b129368ee171768f3d96bc216dcb5401a871d..6f46b376add38ed06207db90d6f72e0f7f404fc0 100644
--- a/go.sum
+++ b/go.sum
@@ -1024,8 +1024,9 @@ go.uber.org/zap v1.10.0/go.mod h1:vwi/ZaCAaUcBkycHslxD9B2zi4UTXhF60s6SWpuDF0Q=
 go.uber.org/zap v1.13.0/go.mod h1:zwrFLgMcdUuIBviXEYEH1YKNaOBnKXsx2IPda5bBwHM=
 go4.org/intern v0.0.0-20220617035311-6925f38cc365 h1:t9hFvR102YlOqU0fQn1wgwhNvSbHGBbbJxX9JKfU3l0=
 go4.org/intern v0.0.0-20220617035311-6925f38cc365/go.mod h1:WXRv3p7T6gzt0CcJm43AAKdKVZmcQbwwC7EwquU5BZU=
-go4.org/unsafe/assume-no-moving-gc v0.0.0-20220617031537-928513b29760 h1:FyBZqvoA/jbNzuAWLQE2kG820zMAkcilx6BMjGbL/E4=
 go4.org/unsafe/assume-no-moving-gc v0.0.0-20220617031537-928513b29760/go.mod h1:FftLjUGFEDu5k8lt0ddY+HcrH/qU/0qk+H8j9/nTl3E=
+go4.org/unsafe/assume-no-moving-gc v0.0.0-20230209150437-ee73d164e760 h1:gH0IO5GDYAcawu+ThKrvAofVTgJjYaoOZ5rrC4pS2Xw=
+go4.org/unsafe/assume-no-moving-gc v0.0.0-20230209150437-ee73d164e760/go.mod h1:FftLjUGFEDu5k8lt0ddY+HcrH/qU/0qk+H8j9/nTl3E=
 golang.org/x/crypto v0.0.0-20180904163835-0709b304e793/go.mod h1:6SG95UA2DQfeDnfUPMdvaQW0Q7yPrPDi9nlGo2tz2b4=
 golang.org/x/crypto v0.0.0-20181029021203-45a5f77698d3/go.mod h1:6SG95UA2DQfeDnfUPMdvaQW0Q7yPrPDi9nlGo2tz2b4=
 golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w=

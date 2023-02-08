class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "a09eef843cfc8301706718165dac499fac546b5cc7dc170f7b2dfa2ab0f25c07"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fd0d3bdd99ca003f8da79989061555a32f3ad9621114eb22f951235fd183851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9539d5d1d21cb16b56146f39739533a8f93d228f425eb082ab482f8ed46de124"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d47114c3770ab7ebb40b120fcbff2d3d747ad960cc83fe65045335a2c21df30"
    sha256 cellar: :any_skip_relocation, ventura:        "7c8df466fa495f62d76f0ee5a1b3d2d23a3791ae274e0e753d574c8343e734cb"
    sha256 cellar: :any_skip_relocation, monterey:       "bf85a989f24fde342d0d54f624426d9afd5d3ef8f4aa5253b1af508279228d47"
    sha256 cellar: :any_skip_relocation, big_sur:        "38dc75d114198b26f6dbeac761fadbf54a02de53ddc705f6c462e361f2c6ebac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82ad9f3801bae678a4e652e8fd7be999bac9b504a536aa299f075de6127ea665"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system "#{bin}/kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~EOS
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    EOS
    (testpath/"policy-settings.json").write <<~EOS
      {
        "denied_labels": [
          "owner"
        ]
      }
    EOS

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end

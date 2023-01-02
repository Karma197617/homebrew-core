class Buildah < Formula
  desc "Tool that facilitates building OCI images"
  homepage "https://buildah.io/"
  url "https://github.com/containers/buildah/archive/refs/tags/v1.27.3.tar.gz"
  sha256 "e87205ea30cf174530a9c5be9cecbf103fabfa7dcc058ce4a48a6bfb9e7151c3"
  license "Apache-2.0"
  head "https://github.com/containers/buildah.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w"
    ldflags << "-linkmode external -extldflags \"-static -lm\"" if OS.linux?
    tags = "netgo osusergo exclude_graphdriver_btrfs exclude_graphdriver_devicemapper seccomp apparmor selinux"

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/buildah"
  end

  test do
    system bin/"buildah", "manifest", "create", "localhost/list"

    expected = <<~EOS
      {
          "schemaVersion": 2,
          "mediaType": "application/vnd.docker.distribution.manifest.list.v2+json",
          "manifests": null
      }
    EOS
    assert_equal expected, shell_output("#{bin}/buildah manifest inspect localhost/list")

    system bin/"buildah", "from", "--name", "brewtest", "scratch"
    output = shell_output("#{bin}/buildah inspect brewtest")
    assert_match "\"Container\": \"brewtest\"", output

    assert_match version.to_s, shell_output("#{bin}/buildah version")
  end
end

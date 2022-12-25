class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.64.0",
      revision: "e1e489a2849c8432781a7cb58b257fa935efa1cf"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"
  end

  test do
    output = shell_output("#{bin}/syft attest busybox 2>&1", 1)
    assert_match "Available formats: [syft-json spdx-json cyclonedx-json]", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

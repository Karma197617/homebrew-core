class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "57e87637f86f7260c8619525c470e2379b6e7cf7a51bfa1b2342b1f29d306777"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "303ab12ec457c1331d73de44f4cdcce54cf02d1edbbc83568cb0def9188e6168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "303ab12ec457c1331d73de44f4cdcce54cf02d1edbbc83568cb0def9188e6168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e08896cbccdd311432d36177f1de1477bcad98d2f87038f6dfe5ad17b1479ccd"
    sha256 cellar: :any_skip_relocation, ventura:        "a9d689bcd8793c1e040aa024e1d1edf269a1235935a337d4b3a820af9b5e588f"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d689bcd8793c1e040aa024e1d1edf269a1235935a337d4b3a820af9b5e588f"
    sha256 cellar: :any_skip_relocation, big_sur:        "24c4538360804e86ad7f5363b4737e26ea5071a5d9c985f81a4d525d23088fc7"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "go" => [:build, :test]
  depends_on :macos

  # patch to use bazel 6.0.0, upstream PR, https://github.com/bazelbuild/bazel-watcher/pull/575
  patch :DATA

  def install
    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "//cmd/ibazel:ibazel"
    bin.install "bazel-bin/cmd/ibazel/ibazel_/ibazel"
  end

  test do
    # Test building a sample Go program
    (testpath/"WORKSPACE").write <<~EOS
      load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

      http_archive(
        name = "io_bazel_rules_go",
        sha256 = "56d8c5a5c91e1af73eca71a6fab2ced959b67c86d12ba37feedb0a2dfea441a6",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.37.0/rules_go-v0.37.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.37.0/rules_go-v0.37.0.zip",
        ],
      )

      load("@io_bazel_rules_go//go:deps.bzl", "go_host_sdk", "go_rules_dependencies")

      go_rules_dependencies()

      go_host_sdk(name = "go_sdk")
    EOS

    (testpath/"test.go").write <<~EOS
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    EOS

    (testpath/"BUILD").write <<~EOS
      load("@io_bazel_rules_go//go:def.bzl", "go_binary")

      go_binary(
        name = "bazel-test",
        srcs = glob(["*.go"])
      )
    EOS

    pid = fork { exec("ibazel", "build", "//:bazel-test") }
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end

__END__
diff --git a/.bazelversion b/.bazelversion
index 8a30e8f..09b254e 100644
--- a/.bazelversion
+++ b/.bazelversion
@@ -1 +1 @@
-5.4.0
+6.0.0

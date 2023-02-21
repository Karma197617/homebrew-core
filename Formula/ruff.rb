class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.250.tar.gz"
  sha256 "cb15e71efd68e2ec0b388f143dc2c46d9e25296e2c29e7af664060a635436385"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e75293e5b455e44ec409e37cd8140084b4086a21b9554a3d5b61f8d558268347"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7859682ee79e64dbd1505cfa9977effb9f534034c93f5f1aec194a16b65d6ebc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11bc91e08942d8733c765066b08e28f04a30b0cedc29790364051e3fbe834154"
    sha256 cellar: :any_skip_relocation, ventura:        "7600b2713101fd3631c97a50e0c5d176a6c215e3bb86b8cfa9a4553b3082b34e"
    sha256 cellar: :any_skip_relocation, monterey:       "30b3827c52839e271ee67be6c21cf8b7ed034586e8d9ffd7ccf59a3b97066e4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd6054242b815532cfe2d04e504b3de6032fdf16c5f03bc4088a240e616c79b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db3bee6e631f7a1b0ba78943bce5285eb9c85be189b7497890f12dc4bb3a2e4e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end

class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.204.tar.gz"
  sha256 "515782f8b16f391e1dce3f36d1660301ef449a58510508a4c5eae942f4c8ce46"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0303cd7eb0cb0fd09ee2a063bc68895c5f5d66bcac2194d077e0f30b3d24dde8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b9dc7cce021fe2b778a35e32c6530e07d6eff93c5112825b578f53ee3269a22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77c4c81938e6fbcc77ebac57048a0b9789e0125101ae3b818b002d8b427d4eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "0f5d31a3b6e78903423436422b009927eac19cd5a0d549ca7a3179fa0e8d13a0"
    sha256 cellar: :any_skip_relocation, monterey:       "ea322cc093851f29330c4a4f51dc22587bd2ac309204f03d5c84a85b1af8e10f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c28bac06227baa40a89e37f3831809d526e43df5a435c344b45ba3edabd84154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6adc46e2fd151d51099402d5de437e6744905c7e6ef14e0550b14071c5f73b2a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end

class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.201.tar.gz"
  sha256 "6564ea15b3921893daed8e082eff377562b0836b72620ec76fae9c7f10d5e645"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d6635388dd4669f288ddfda39614aecc843c49bcb6168f266e0b940d4872b39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a47cda3f758eb462cd131d6de72f4e2bb8bd20e405e08e8b9099f5bb783a0be0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b99ccba966daad2dad33e191c7f984f2eac2d26c60c281823d7000641da9d65"
    sha256 cellar: :any_skip_relocation, ventura:        "2dbe9ca31a720c88d2d7bc2b2c2831a5793568dd8ec1dba07c40e7cd2546cd43"
    sha256 cellar: :any_skip_relocation, monterey:       "c142c227ed5f30b281e7a2884d80b81643942fad160f04bc8dd1014b7c7ee390"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b70b2e570461f566fa1bd1d2d245fca689f48ec0cd127635ecc6ddac2de782f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e76118ddc66b5eecd5c0c8551bb0f9a7d11b9cb9eaf0a708949705ac74998e28"
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

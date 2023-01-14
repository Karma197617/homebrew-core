class Gokey < Formula
  desc "Simple vaultless password manager in Go"
  homepage "https://github.com/cloudflare/gokey"
  url "https://github.com/cloudflare/gokey/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "31144a7906682acf25279c5c0958aff2273c24f83da0d9ad27962fbd9c3d7d5b"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/gokey.git", branch: "main"

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gokey"
    system "go-md2man", "-in=gokey.1.md", "-out=gokey.1"
    man1.install "gokey.1"
  end

  test do
    output = shell_output("#{bin}/gokey -p super-secret-master-password -r example.com -l 32")
    assert_equal "&Aay/aoUlTa[u0b6LAm3l'UuE.$xDq-x", output
  end
end

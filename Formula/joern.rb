class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1514.tar.gz"
  sha256 "3c738ad52d02eeb43c4920498b8c363e1cbd6b86f87115a6766b49dcc30090af"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e54c1f9364a84c97de95018bb60141b639088e69dc43962dca8c9c94f57f119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a1dd0c8a7a3d4d0b1941b8a178ba9ab5d740c7c7b93437ea7db07f135f3c51d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57987f044ccdf7f55f5be4e2d573a9c08a1152eb8a31dbde309295e81ca0dbbe"
    sha256 cellar: :any_skip_relocation, ventura:        "984e6ff715669250e866a73277e2e961cb1796e65d6a6e028444c16330de855c"
    sha256 cellar: :any_skip_relocation, monterey:       "09bf8a60df93376f11aa992d07a0a3c064a0db679ca3e52153eb7c8c4c88602e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f712e3bffc8f3fb7bab026815f58ae4e14b8e808753420ca0ff043f02b22f393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad2c9534b0f60db2f5d9bff55c5581ca556bedbb9ee469b7625d54a1955cf2a"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    libexec.install "joern-cli/target/universal/stage/.installation_root"
    libexec.install Dir["joern-cli/target/universal/stage/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV.append_path "PATH", Formula["openjdk"].opt_bin

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    EOS

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_predicate testpath/"cpg.bin", :exist?
  end
end

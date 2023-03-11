class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.3.2.tar.gz"
  sha256 "95b3694f4906f737447a787e2d367ae74cf97f27f74150312bcfb1381badb3cf"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/gfold")
  end

  test do
    mkdir "test" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      (Pathname.pwd/"README").write "Testing"
      system "git", "add", "README"
      system "git", "commit", "-m", "init"
    end

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}/gfold #{testpath} 2>&1")

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end

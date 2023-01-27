class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/0.9.47.tar.gz"
  sha256 "22851f906ce4039d43ee5fc754425dd0918905e4b98b36cd2f720fe94b85c6b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90d12f573e1075a3f09d482b9b47844a2b0530d70dad6331d9f01103e3c67e4d"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"new.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS test (id text);
    EOS
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end

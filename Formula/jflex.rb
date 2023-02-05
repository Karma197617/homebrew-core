class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java"
  homepage "https://jflex.de/"
  url "https://github.com/jflex-de/jflex/releases/download/v1.9.0/jflex-1.9.0.tar.gz"
  sha256 "4fd77f6bde675c3fc2892051819c7b86358679072a858fbd39471d1289ac51f3"
  license "BSD-3-Clause"

  livecheck do
    url "https://jflex.de/download.html"
    regex(/href=.*?jflex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "81555ae7265b0427f2aaa6df7ee70e4a292630f1ac70151f61c3fb6e9af7203d"
  end

  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    libexec.install "lib/jflex-full-#{version}.jar" => "jflex-#{version}.jar"
    bin.write_jar_script libexec/"jflex-#{version}.jar", "jflex"
  end

  test do
    system bin/"jflex", "-d", testpath, pkgshare/"examples/cup-java/src/main/jflex/java.flex"
    assert_match "public static void", (testpath/"Scanner.java").read
  end
end

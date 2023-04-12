class Stringsext < Formula
  desc "Find multi-byte-encoded strings in binary data"
  homepage "https://gitlab.com/getreu/stringsext"
  url "https://gitlab.com/getreu/stringsext/-/archive/v2.3.4/stringsext-v2.3.4.tar.bz2"
  sha256 "0b7cccc5fe9afe30f900bf13763b0d7b2fe52fb2ba59d245ab8499c1164d1fea"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://gitlab.com/getreu/stringsext.git", branch: "master"

  depends_on "rust" => :build

  resource "homebrew-testdata" do
    url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/stringsext -tx -e UTF-8 -- #{bin}/stringsext")
    assert_match "stringsext", output

    assert_match "UTF-8", shell_output("#{bin}/stringsext --list-encodings")
    assert_match version.to_s, shell_output("#{bin}/stringsext --version")
  end
end

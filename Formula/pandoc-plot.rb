class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.6.1/pandoc-plot-1.6.1.tar.gz"
  sha256 "2352545aaaf87dfd289a2afdcf83502000a2e6b3f3541ea94391f2c656593e0b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "972831e855ae3a5511a8d71f4aa75b913162d45f54255675239619960b7738ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38d866e2ee9813dd18f6681478267e16951826d9e60daeb36ff289ca7678dde2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2406ab81f3ff0bed3610c32bbd66d7bfda22d26e4edbf55e0c65b71005dac776"
    sha256 cellar: :any_skip_relocation, ventura:        "92d6837ec529211ec4ea0970cb45357a49610fec03d1e15a758325a296eb6341"
    sha256 cellar: :any_skip_relocation, monterey:       "33a17ccc45ad2c1705f82d90acc0af474258bee499d891d8e85fd060da17a9f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a629c3ef928decc07cc002d70ceb0328b479ae8574581481f0bbc02d9c22dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3068c4fdac6704defb02e970c896dd679afd88cb10d1a28a8d6906d7981f9435"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test
  depends_on "pandoc"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    input_markdown_1 = <<~EOS
      # pandoc-plot demo

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    input_markdown_2 = <<~EOS
      # repeat the same thing

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    output_html_1 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_1)
    output_html_2 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_2)
    filename = output_html_1.match(%r{(plots/[\da-z]+\.png)}i)

    expected_html_2 = <<~EOS
      <h1 id="repeat-the-same-thing">repeat the same thing</h1>
      <figure>
      <img src="#{filename}" />
      </figure>
    EOS

    assert_equal expected_html_2, output_html_2
  end
end

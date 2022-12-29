class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/b0/2a/b61699d8a1eb4adc23647e44ac4c94ccc4f5c9ddb477e3eb54a48342e666/python-lsp-server-1.7.0.tar.gz"
  sha256 "401ce78ea2e98cadd02d94962eb32c92879caabc8055b9a2f36d7ef44acc5435"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22e80e963fe17745bfcb9a975b173283537c0be0dae2c64803e862a062a66fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be623c09688e712b095a5dd48d2785f6fdde27f1dbb4268226233033ff3608a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4db452c719d04afd093cb64f776bef0fd76987422b4111554e31c3fc1ec92238"
    sha256 cellar: :any_skip_relocation, ventura:        "faa9420f301b6cd3ef686163b138973f7ea3ef8a4fb30b02bf38a7abfc9f33dc"
    sha256 cellar: :any_skip_relocation, monterey:       "8b63d3caac9372e49cae574a289222ab4919669bc09ae83e8bb4a98cd1e17b13"
    sha256 cellar: :any_skip_relocation, big_sur:        "28d28aace6138499d16809656bb282f2e467ca0f2aaa561de542f2ee4bb1f065"
    sha256 cellar: :any_skip_relocation, catalina:       "98e208b76802d77b63a9a2aa5e9c5883f639d45be559c4f4880a36a052c70add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ba66f2c44bd11458288f3b7aed801e4395ea05b005b670cb5e23de304437da"
  end

  depends_on "python@3.11"

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/e9/68/cac92c4f3f837fbeba17e8dfcdb7658fac6a1d56c007ed0d407087f1127e/docstring-to-markdown-0.11.tar.gz"
    sha256 "5b1da2c89d9d0d09b955dec0ee111284ceadd302a938a03ed93f66e09134f9b5"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/45/48/466d672c53fcb93d64a2817e3a0306214103e3baba109821c88e1150c100/ujson-5.6.0.tar.gz"
    sha256 "f881e2d8a022e9285aa2eab6ba8674358dbcb2b57fa68618d88d62937ac3ff04"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/pylsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end

class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/59/c5/fdb678be01f90450cb3c785eba8fbdd80361156c31da96137eb5c31f9a66/python-lsp-server-1.7.1.tar.gz"
  sha256 "67473bb301f35434b5fa8b21fc5ed5fac27dc8a8446ccec8bae456af52a0aef6"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e99c004916d69ad1dae001275a8cdb84671d0f0e4af583f68554a151646cb8c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f7f2729f90dd47dbf0b338236a949a59066e6f7b55dffd022235432e9c7c8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ad46c7facf45dbdc5108429e12ececd665265dacf7dacc33a67a0387d4e5a0a"
    sha256 cellar: :any_skip_relocation, ventura:        "ad6eef9791426f3f428df25ab857be117f19cb8554dab6056301ec8ab37e7338"
    sha256 cellar: :any_skip_relocation, monterey:       "46e82ade8ca863b620613d4733badad99d24616dc58fe678aab32b84a9cd07e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "410356386eb9e2ff95fc1b271eb5b3f7c2542c9719ed4d023c7317f011a4bba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8e30b896b862eba43b59402887d0e825735e3c0ea22506873d396d7bacf155"
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
    url "https://files.pythonhosted.org/packages/43/1a/b0a027144aa5c8f4ea654f4afdd634578b450807bb70b9f8bad00d6f6d3c/ujson-5.7.0.tar.gz"
    sha256 "e788e5d5dcae8f6118ac9b45d0b891a0d55f7ac480eddcb7f07263f2bcf37b23"
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

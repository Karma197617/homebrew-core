class Litani < Formula
  include Language::Python::Virtualenv

  desc "Metabuild system"
  homepage "https://awslabs.github.io/aws-build-accumulator/"
  url "https://github.com/awslabs/aws-build-accumulator.git",
      tag:      "1.28.0",
      revision: "00e2dda4e8ce2c6fb11e3904861e986af228099e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "345510ac0f6a7246d8a1afafa5d4bf013c3a6df31719e7bac940e811796648ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b731d24d17fa9019814a66c59795e6a3045f53ece5ca841b7a675b23e331c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15ff461fea3eb008929ad2dd4ea59f7e465551d1e392ff47df810cad80a35e12"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce58a07493f813a922520af02cf195a37b4f4eb66ef084d655201ccac20e1a7"
    sha256 cellar: :any_skip_relocation, monterey:       "25814ed866dcfd89ca11d9a09b98d28f2abfb6121419cf0a6dc5f9b89c6d97d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "37e505d935452f93ee7c7ca7b56f70577bb98b494cf9b5d8973bab63a3808022"
    sha256 cellar: :any_skip_relocation, catalina:       "aca7bba81b938d4ee5301ed030e4f7d98975970850edda0faa64aa2301ba46b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f6c8b083732e2a18c1870ee990ca348372c87c53cc0dd2ef0ba4cdda43e2432"
  end

  depends_on "coreutils" => :build
  depends_on "mandoc" => :build
  depends_on "scdoc" => :build

  depends_on "gnuplot"
  depends_on "graphviz"
  depends_on "ninja"
  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  def install
    ENV.prepend_path "PATH", libexec/"vendor/bin"
    venv = virtualenv_create(libexec/"vendor", "python3.10")
    venv.pip_install resources

    libexec.install Dir["*"] - ["test", "examples"]
    (bin/"litani").write_env_script libexec/"litani", PATH: "\"#{libexec}/vendor/bin:${PATH}\""

    cd libexec/"doc" do
      system libexec/"vendor/bin/python3", "configure"
      system "ninja", "--verbose"
    end
    man1.install libexec.glob("doc/out/man/*.1")
    man5.install libexec.glob("doc/out/man/*.5")
    man7.install libexec.glob("doc/out/man/*.7")
    doc.install libexec/"doc/out/html/index.html"
    rm_rf libexec/"doc"
  end

  test do
    system bin/"litani", "init", "--project-name", "test-installation"
    system bin/"litani", "add-job",
           "--command", "/usr/bin/true",
           "--pipeline-name", "test-installation",
           "--ci-stage", "test"
    system bin/"litani", "run-build"
  end
end

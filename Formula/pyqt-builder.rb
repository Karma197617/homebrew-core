class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/21/6c/685981114cb350f2f8e4a0827aa7f60f142e15816aa48f3204e5a1e2578c/PyQt-builder-1.14.1.tar.gz"
  sha256 "83bc3e300aff8b41405804b6a9c2913389ab59c48ad9f0cb8584a6ef73bca502"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be08ab36285909a7513b5e25d70cc9c515ac4a3dbb6487b21c38084aa1250765"
  end

  depends_on "python@3.11"
  depends_on "sip"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end

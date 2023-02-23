class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/13/e9/ddaf9ddda47baf30908f2e1b7ad8dc914d12a6f5975bc61243ef87c851f0/djhtml-3.0.1.tar.gz"
  sha256 "076c2f35040a63dcc1333169d670c66a26769e8dbd9a74abf8405b0195db602c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d261a7f001c87893562f72ddb22dc0b0b8fe027b614f5381c2410d4dd2caba06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c948dbf3eeae136d1d232ac771848c3190ad11bdecfe1f5ff5492ab7c8c8e1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7568b406e84e3145f78bbdbccbf9e6e3d58e1954c7c6c7c2cf6949dafbd666"
    sha256 cellar: :any_skip_relocation, ventura:        "a99e37f47ef90205e33cf2655c6c1ce10b61c706267bcd4e8dea117d44c79a71"
    sha256 cellar: :any_skip_relocation, monterey:       "3f32152ec32da8519c122f2c15a24f62e0a4e1e0020cd26391b3fdb055e61ece"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba9e7a83c7e8ecbd175db8645b018d050d1a617017bc111e01da99710e4070a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182d4bcac67bf39c4d99bd3c269cbf35cbf2a4d7a8ac1441ebdd6388f286ba92"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.html"
    test_file.write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end

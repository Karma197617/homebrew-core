class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/7f/1e/7ec69d54762bc2d41e85d461548e8a35011c3626173f8472f05411b79a3f/SCons-4.5.1.tar.gz"
  sha256 "9daeabe4d87ba2bd4ea15410765fc1ed2d931b723e4dc730a487a3911b9a1738"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e420b52485379506b897d341b8833daa97caeda873f4609f3dff491a5e46095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632a8be58de3d7c2e3c218ef7ede5a8dd1ea63f0e1213e4a92afbdcbd87cf0e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01a3913680e2d5442f55f8198d0b84a11911674407814530143f23906ede47bb"
    sha256 cellar: :any_skip_relocation, ventura:        "b786a0f61d3597564d1ca185299898116bc8918f97f0c699eecf5bdf8d381b3a"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb1b863b61337d8393acb3776f8432cb1303e6286784611ced049f2e68bbc14"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f20ae0b87247b76de637c9fce703a9092f4f492c4568ad6e5545c272d9f3eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31cf379929e0bd95c8b0e72c22c120e786e110b3166eb8831d0f2fb7cb0a0699"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end

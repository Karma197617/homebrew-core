class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "ced67e1cf1f97e168cdf271851a4d0b6d382ab7936e7bcbb39aaa87239c324b6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "05e505a4b1f096f7fb43ef54108f02e70245267f2a98622fac536e759ceafdc6"
    sha256 cellar: :any,                 arm64_monterey: "85dadcd30747d1545d423e5382be022f08b4cbe64d4792e51ac8be2b2a6bfe65"
    sha256 cellar: :any,                 arm64_big_sur:  "74c3a9b9996b6f33a0dac17c3fc00448427849f05d3b3af96e7c90be3ffb28b3"
    sha256 cellar: :any,                 ventura:        "2eff3282b96c376e89b839a03583528e215d211eda31cfb3830c938a8c9d1333"
    sha256 cellar: :any,                 monterey:       "6c0e377f96b59173b241a959d09ffbf1a18b2d65108488e670f6cd950e6d4c7c"
    sha256 cellar: :any,                 big_sur:        "818ed82d4d092f8b868a5dc330566d4d2bdca3692177d99d1e36ce0f3e8e5ffe"
    sha256 cellar: :any,                 catalina:       "fb7b87345a559aca821f60d053990a4cc5015ce949b4530daf2a3b662db44577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb6e9a517f01141547e5d84053dc90cbe8fcdbb8837cff0cb3adf213300a5ef"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-typing-extensions"
  depends_on "pytorch"

  on_macos do
    depends_on "libomp"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    jpeg = Formula["jpeg-turbo"]
    inreplace "setup.py",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = find_library(\"jpeglib\", vision_include)",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = (True, False, \"#{jpeg.include}\", \"#{jpeg.lib}\")"

    inreplace "pyproject.toml",
      'requires = ["setuptools", "torch", "wheel"]',
      'requires = ["setuptools", "wheel"]'

    virtualenv_install_with_resources using: "python@3.11"

    pkgshare.install "examples"
  end

  test do
    # test that C++ libraries are available
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <torch/script.h>
      #include <torch/torch.h>
      #include <torchvision/vision.h>

      int main() {
        auto& ops = torch::jit::getAllOperatorsFor(torch::jit::Symbol::fromQualString("torchvision::nms"));
        assert(ops.size() == 1);
      }
    EOS
    pytorch = Formula["pytorch"]
    openmp_flags = if OS.mac?
      libomp = Formula["libomp"]
      %W[
        -Xpreprocessor -fopenmp
        -I#{libomp.opt_include}
        -L#{libomp.opt_lib} -lomp
      ]
    else
      %w[-fopenmp]
    end
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", *openmp_flags,
                    "-I#{pytorch.opt_include}",
                    "-I#{pytorch.opt_include}/torch/csrc/api/include",
                    "-L#{pytorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"

    system "./test"

    # test that the `torchvision` Python module is available
    cp test_fixtures("test.png"), "test.png"
    system libexec/"bin/python", "-c", <<~EOS
      import torch
      import torchvision
      t = torchvision.io.read_image("test.png")
      assert isinstance(t, torch.Tensor)
    EOS
  end
end

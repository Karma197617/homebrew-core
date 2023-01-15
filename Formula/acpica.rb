class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  # https://acpica.org/sites/acpica/files/acpica-unix-20221022.tar.gz is not available
  # upstream issue report, https://github.com/acpica/acpica/issues/823
  url "https://github.com/acpica/acpica/archive/refs/tags/R10_20_22.tar.gz"
  version "20221022"
  sha256 "1aa17eb1779cd171110074ce271a65c06046eacbba7be7ce5ee71df1b31c3b86"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8c97744dcd6f6b1be41c6b13a07b02c373f83bf1aa7d8852d96a2935a5c5330"
    sha256 cellar: :any_skip_relocation, ventura:       "36c5768c90757e49b87d58cb6068d1745a557c0741fc27c32df08fdd0254a949"
    sha256 cellar: :any_skip_relocation, monterey:      "0ada9f5afbb835d2ab0cf55ba23e07c286373ec6ed1b6fb46859cf510cfff49a"
    sha256 cellar: :any_skip_relocation, big_sur:       "27433e94ad72edf41984cfe6a665afa21f6f5ce997c3fdedf33c68eb864d785e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a339b361429ed66f9316dda49339bf70848c94d6038b22daf6585ee0123e10"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end

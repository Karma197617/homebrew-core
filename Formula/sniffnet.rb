class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c957a372b324aa8349820458202d291f64831b90aeae5b73d822e74e7739876d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork do
      # sniffet is a GUI application
      exec bin/"sniffnet"
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

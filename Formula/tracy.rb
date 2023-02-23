class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.9.tar.gz"
  sha256 "93a91544e3d88f3bc4c405bad3dbc916ba951cdaadd5fcec1139af6fa56e6bfc"
  license "BSD-3-Clause"

  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "tbb"

  on_linux do
    depends_on "dbus"
  end

  fails_with gcc: "5" # C++17

  def install
    %w[capture csvexport import-chrome update].each do |f|
      system "make", "-C", "#{f}/build/unix", "release"
      bin.install "#{f}/build/unix/#{f}-release" => "tracy-#{f}"
    end

    system "make", "-C", "profiler/build/unix", "release"
    bin.install "profiler/build/unix/Tracy-release" => "tracy"
    system "make", "-C", "library/unix", "release"
    lib.install "library/unix/libtracy-release.so" => "libtracy.so"

    %w[client common tracy].each do |f|
      (include/"Tracy/#{f}").install Dir["public/#{f}/*.{h,hpp}"]
    end
  end

  test do
    port = free_port
    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")

    pid = fork do
      exec "#{bin}/tracy", "-p", port.to_s
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

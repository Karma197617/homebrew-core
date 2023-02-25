class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3340.tar.gz"
  sha256 "7ad705be72b38346bf0a9494cc987d5d121d70864e85f32fc985e8111ca3bcdb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9bbf8eb56085c8c6a6d00f319b10c33d3bc2bf6845116efc39110bec2a99f49d"
    sha256 cellar: :any,                 arm64_monterey: "3aab0b7ccb826954a6618ae568ad9289d9d9f1df4e9e31d7be15c53ec42cf5a3"
    sha256 cellar: :any,                 arm64_big_sur:  "ee0942331a84a821cead5a1da74e42b37d60f5c139270a96bf02e15e9fd3b44e"
    sha256 cellar: :any,                 ventura:        "523ba02c89981bd4a9831dae09faf281ed8473c14aa6bd2fb84efafcd8971428"
    sha256 cellar: :any,                 monterey:       "4ab68bfeab1d9d25ece8067093c3453df7a9d348f656176f0f065502c29ccefe"
    sha256 cellar: :any,                 big_sur:        "220d72b8563cdf6758fb39952d97c91974358f57d67989ae04a51e506ae24369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b5e4e6e49a1d10176d12be37b33792af541c95a6a0cab644a7e92b9eb067e3"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

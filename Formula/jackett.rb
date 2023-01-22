class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2687.tar.gz"
  sha256 "d0c1b55f7eea783a9d7d358a1dc5257f1693a417b24452b0a29a6053651c2244"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e09f74e91d478e278b891836cd0c379fa4ffecc89cb135269d4cb2183b9b28aa"
    sha256 cellar: :any,                 arm64_monterey: "433317d3702da4bfea4e1460f3f1d66750a97bad768dec0d54f8ea168e524b80"
    sha256 cellar: :any,                 arm64_big_sur:  "083f4346c531df560277114ce639531fbd6f7225ba0520d40e6b3ceb26d342d0"
    sha256 cellar: :any,                 ventura:        "71f8a81464f61ef4b081a08d8b466548136aeb0b7031922fc1793c450bc6bee9"
    sha256 cellar: :any,                 monterey:       "82e4dbf431afcfe8441db19784533adf10944762c0982bbde5e7050ce779c626"
    sha256 cellar: :any,                 big_sur:        "d52683a984ba9c5a081db18ee7971ba53dc6008e67d6ebfbebcb7cb78bbb02d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1ef9d071937bc5227baf2ac826dbc01a2a867f674374dcdcb501d6e78cbc39a"
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

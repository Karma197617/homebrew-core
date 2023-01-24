class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2691.tar.gz"
  sha256 "7c1b0454af972a43f045cb1045806715f77624ee5a7576de25ec82487a9ad072"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0d1103edc30da1cc975735d0ebea02d63b3d73bd3625e2924bd888ce6d10a71a"
    sha256 cellar: :any,                 arm64_monterey: "7c3bc2057fec4e7e21511aef8aab483ddc5ff8116074160ddbf01b5d591bef29"
    sha256 cellar: :any,                 arm64_big_sur:  "acec528ec6683efb8796f878fc0e91cbc33f315288b86b4bc87495c69cad14b4"
    sha256 cellar: :any,                 ventura:        "45aa6588a74a1f682635c2adf9d2678d0ffdf0035ef8781473bcda2c5cd33f04"
    sha256 cellar: :any,                 monterey:       "d9b97c16487769a438e9db4ef6fc0cbe17bac648b93af79614a2035ed2e54b27"
    sha256 cellar: :any,                 big_sur:        "08b6831f49483893a5a54c684b687b6b16bc20141951a316a2712558cde73e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc84dbdb9a70676eb1b0709aac7cb777d6d0655797fc2ce871c43f04db929df2"
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

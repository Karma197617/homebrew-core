class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3269.tar.gz"
  sha256 "09ddc2cf62af8377e8f38726699327c0a81b62c3a9b31f08cab274788c02a471"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "67e680254b0a0de7fd4de755058d3435fc943593623fbc011f5fd31b0109f32d"
    sha256 cellar: :any,                 arm64_monterey: "d0277ee60c277db16b8d0df995d4f5349c3e3e806f902abddabae1b0c2ca24c1"
    sha256 cellar: :any,                 arm64_big_sur:  "469005aea4f089938affc1ba11a11fd51260cbaf6bb77acb47557389ce093553"
    sha256 cellar: :any,                 ventura:        "3e7d3e5aca879d850f1ff0509a48a3a12949909ba7216f2a4bf0a4c73e55ac86"
    sha256 cellar: :any,                 monterey:       "27891a200ea69e79c7e13362f73d87fc9dfaa7e6140352d58eab2a2b82a31e46"
    sha256 cellar: :any,                 big_sur:        "10530fc7f51921d1e5cdfe082d76ee9cf22e50c3f6c9290606ab50203cb8ee6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b15f891b24688ce0f2348eabf48f072468c3fcb4efef440e73c8129cd67bdab"
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

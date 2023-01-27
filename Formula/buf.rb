class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "bed6990123dc9e419a1d8b2e3fa4e7cc45162f8583a839f0a92d1fddd41fe4fe"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31a7e021e03dd10e5887b00b4c28b383a8450a494bdf85dec80ad2b18a1a76eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abfe0a618c0de8f12e35b86353befccff353ab1226623eba2c80da8d9d6486e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "766b0138fcbaef0d007c4704ab82c0e866faf21f2c92ca3f529a083d106cbec0"
    sha256 cellar: :any_skip_relocation, ventura:        "77ab66e33bf2208f0796f7adf9d7b9a43e373140a4eae175aefe5e44da0f6bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "df60eb274850c7089600bf291b8aba7af41ed67e0eea3c8b9ddce53f732d34ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "92b21cc1328ce146e94bf518f70c3c80360fd92bb2b009feda0dd3fb3edce861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b62ac5930c9b84bb11703f30992ffda3967cda02bde567a1b0440350ef1070"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath/"buf.yaml").write <<~EOS
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - DEFAULT
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    EOS

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end

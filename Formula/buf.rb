class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "76c1c33fc0e9b64374fe319283d0180233a0992f2d09d3e7864e1f4112e9f43d"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5632fa150f76393b44ab8b06a067b3c31d2e96398ec4c310fa221a445b03c9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a4562c81122711a5f1f345707688db7c84591f88fa64e03ce8f3f38e5bc5e4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8afc49a736029255da9bbee148c2a70ce6309fa449b0f7440bf554c87924152c"
    sha256 cellar: :any_skip_relocation, ventura:        "c461cd7d3bd9ef6a93a580d75224b66268769ad47a5d87a5616c35caa3928ebe"
    sha256 cellar: :any_skip_relocation, monterey:       "094ca310e27106c981b77789783432e838b1d4de88f825b9f45787adedbfdca6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d20d8254869e4b6257eb74e446d59da80f6f181129f9e6feb1ecefbbca30b0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dca33069ca30fc4212929210db95c40874a5c23d9de009af93085377431aeeb"
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

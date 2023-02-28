class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "afdf204db262b6b4ce848df727f974c64c90e8034faac86ce7eb1a3ca36f863b"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f75cd6e0759b5e380fe03dd3d2d711921d0c9c200680b536be511850cb53a7d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "366f47de384c623ca449160e6c906052cd9be0284c5faa0d3d9139c3256fc284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f2c28eff5224d573545c905842b523a65348f02aeacb64d04e9c05ccfdf47ef"
    sha256 cellar: :any_skip_relocation, ventura:        "42e980704b1a215bbaaf7e8fc1211317774fc1b52038eb7dda7fcfea9716835f"
    sha256 cellar: :any_skip_relocation, monterey:       "bb44711fbc20b7c358e4c74142e3043d4a67362bce515d113680519b2b38bbe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "98740119d96115499c657e7756ffebb6b495fe0db11dd99616e73a93499fbf1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d9695d0941ffb836ca00f6faa5225b0a8490f5426f8aaeaa30190af417bc01"
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

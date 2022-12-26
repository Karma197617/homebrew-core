class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  stable do
    url "https://github.com/apollographql/rover/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "5132d1e1f4f5eb3c6e8b2254e7c75c638d35023992869185704e3ead2c99e2ff"

    # Fix build for Rust 1.66.0
    # Upstream commit ref, https://github.com/apollographql/rover/commit/f41e0894824663f62caf8fab6d10a6904449ec39
    # remove in next release
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22c6d424681c36f59cfe9587c21217ce407195a4166264033079eda86a0909a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68af46f927616d0d0941ade763d91cbe29efbc22b48f7821bd0de73d700893e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb65eec58656f668c8ed7464503b6557e0dd14bdf031bced4094f0e4252ae802"
    sha256 cellar: :any_skip_relocation, ventura:        "18e9d9a70e83d20a17571e8de7316f1582814d1caca0af41ff765e7e087c258d"
    sha256 cellar: :any_skip_relocation, monterey:       "33552815f7328ae64ad5219942211da72054d505e3b4dc28d73814a3f5a16daa"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4f7b3f9530e7d3a4e8d82f8835c1e136c78f11850d9980bb56d99d0f17a0cf2"
    sha256 cellar: :any_skip_relocation, catalina:       "e9fea88f64256c9c5674376ad70030348844d944c1e2a456677d3485ddede5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f743d47b1435b86eddd55b270a8146e8e93459aa251ebca6479e992d2b170659"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end

__END__
diff --git a/crates/rover-client/src/operations/graph/check/types.rs b/crates/rover-client/src/operations/graph/check/types.rs
index 842db8e..9074c32 100644
--- a/crates/rover-client/src/operations/graph/check/types.rs
+++ b/crates/rover-client/src/operations/graph/check/types.rs
@@ -22,7 +22,7 @@ impl From<CheckSchemaAsyncInput> for MutationVariables {
             graph_id: input.graph_ref.name,
             name: input.graph_ref.variant,
             input: MutationInput {
-                graph_ref: graph_ref.to_string(),
+                graph_ref: Some(graph_ref.to_string()),
                 proposed_schema_document: Some(input.proposed_schema),
                 git_context: input.git_context.into(),
                 config: input.config.into(),
diff --git a/crates/rover-client/src/operations/subgraph/check/types.rs b/crates/rover-client/src/operations/subgraph/check/types.rs
index 6a76692..cb06d72 100644
--- a/crates/rover-client/src/operations/subgraph/check/types.rs
+++ b/crates/rover-client/src/operations/subgraph/check/types.rs
@@ -23,7 +23,7 @@ impl From<SubgraphCheckAsyncInput> for MutationVariables {
             graph_id: input.graph_ref.name,
             name: input.graph_ref.variant,
             input: MutationInput {
-                graph_ref: graph_ref.to_string(),
+                graph_ref: Some(graph_ref.to_string()),
                 proposed_schema: input.proposed_schema,
                 git_context: input.git_context.into(),
                 config: input.config.into(),

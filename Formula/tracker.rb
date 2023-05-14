class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gnome.pages.gitlab.gnome.org/tracker/"
  url "https://download.gnome.org/sources/tracker/3.5/tracker-3.5.2.tar.xz"
  sha256 "e93d40bc76103a0a24693818cdab2b34e76c64e260b3e762784faeec4ba4a8b3"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  # Tracker doesn't follow GNOME's "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/tracker[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e342d63c43edfa31a3b8a50cb911b6997ab397f13284d1000df7ed9907fc195a"
    sha256 arm64_monterey: "37836c628dbe2454bf45f25cff7ca2d04b0bbc898fb2b2816fce0b8d10e10b9e"
    sha256 arm64_big_sur:  "70da64159075343b79ac5b79d2b08813cd4433aff0a9fd4e6160b9ab027009ad"
    sha256 ventura:        "83418c8ceec2f3f6e44401b968f1f56666c1c29d460674a9a13e05eab0660a4b"
    sha256 monterey:       "96b41d7fbcbf5666283e6253264b2400f97528fd4d712deb3eb1d5225e05aa52"
    sha256 big_sur:        "9dff729210dd10853993448f7fb5373af65b5fa5aae3b8b3a4d974fc445965da"
    sha256 x86_64_linux:   "0fc8435e75ae39d0d617349f6ab4aaa24fe98fc7b65bd4090e4d9ee7f87a8433"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "vala" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libxml2"

  resource "gvdb" do
    url "https://gitlab.gnome.org/GNOME/gvdb.git",
        revision: "0854af0fdb6d527a8d1999835ac2c5059976c210"
  end

  # patch to use vendored gvdb
  # upstream PR ref, https://gitlab.gnome.org/GNOME/tracker/-/merge_requests/597
  patch :DATA

  def install
    (buildpath/"subprojects/gvdb").install resource("gvdb")

    args = %w[
      -Dman=false
      -Ddocs=false
      -Dsystemd_user_services=false
      -Dtests=false
      -Dsoup=soup3
    ]

    ENV["DESTDIR"] = "/"
    system "meson", "setup", ".", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libtracker-sparql/tracker-sparql.h>

      gint main(gint argc, gchar *argv[]) {
        g_autoptr(GError) error = NULL;
        g_autoptr(GFile) ontology;
        g_autoptr(TrackerSparqlConnection) connection;
        g_autoptr(TrackerSparqlCursor) cursor;
        int i = 0;

        ontology = tracker_sparql_get_ontology_nepomuk();
        connection = tracker_sparql_connection_new(0, NULL, ontology, NULL, &error);

        if (error) {
          g_critical("Error: %s", error->message);
          return 1;
        }

        cursor = tracker_sparql_connection_query(connection, "SELECT ?r { ?r a rdfs:Resource }", NULL, &error);

        if (error) {
          g_critical("Couldn't query: %s", error->message);
          return 1;
        }

        while (tracker_sparql_cursor_next(cursor, NULL, &error)) {
          if (error) {
            g_critical("Couldn't get next: %s", error->message);
            return 1;
          }
          if (i++ < 5) {
            if (i == 1) {
              g_print("Printing first 5 results:");
            }

            g_print("%s", tracker_sparql_cursor_get_string(cursor, 0, NULL));
          }
        }

        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs tracker-sparql-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index 7b22cb1..e5087d9 100644
--- a/meson.build
+++ b/meson.build
@@ -55,7 +55,14 @@ libxml2 = dependency('libxml-2.0', version: '> 2.6')
 sqlite = dependency('sqlite3', version: '>' + sqlite_required)
 dbus = dependency('dbus-1')

-gvdb_dep = dependency('gvdb')
+# Try to find the dependency in the system
+gvdb_dep = dependency('gvdb', required: false)
+
+# Use subproject as a fallback if the dependency is not found
+if not gvdb_dep.found()
+  gvdb_proj = subproject('gvdb')
+  gvdb_dep = gvdb_proj.get_variable('gvdb_dep')
+endif

 soup = get_option('soup')
 if soup.contains('soup2') or soup.contains('auto')

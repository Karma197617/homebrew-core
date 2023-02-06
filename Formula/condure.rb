class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.9.2.tar.gz"
  sha256 "c95a7587997af82ab6f3bbf92cfb983b58d7c304133f3be1d0787e31d16ea065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20b86fc90702c0ba4d7901e0aabd9b8b1d8ae0c624b1073b21c4ee69e8dc266b"
    sha256 cellar: :any,                 arm64_monterey: "2c7d522d45ed317a29493fd5ee4affd1bdc049782bc530a8e4db0372d43f9699"
    sha256 cellar: :any,                 arm64_big_sur:  "c17e42e8bd5f5a4606508b4146408519dc59505603c738ecd237621ee5ed16cc"
    sha256 cellar: :any,                 ventura:        "2354488c20d837d9cea3171be3523fe5b9aed448df03caca02475ae0bdd93c0e"
    sha256 cellar: :any,                 monterey:       "4efc1699868ca262b816aa0ba41b0afa9364d94bfe89a569387551fb423c69c6"
    sha256 cellar: :any,                 big_sur:        "e9333c61272698e6d98da02d5781d01d1964afadecc760b8f6915a3874931132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b26716530584e8a48a5820228f6d430a06fcb1c8cb5191a8583d72dc100ec3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.11" => :test
  depends_on "openssl@1.1"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/cf/89/9dbc5bc589a06e94d493b551177a0ebbe70f08b5ebdd49dddf212df869ff/pyzmq-25.0.0.tar.gz"
    sha256 "f330a1a2c7f89fd4b0aa4dcb7bf50243bf1c8da9a2f1efc31daf57a2046b31f2"
  end

  resource "tnetstring3" do
    url "https://files.pythonhosted.org/packages/d9/fd/737a371f539842f6fcece47bb6b941700c9f924e8543cd35c4f3a2e7cc6c/tnetstring3-0.3.1.tar.gz"
    sha256 "5acab57cce3693d119265a8ac019a9bcdc52a9cacb3ba37b5b3a1746a1c14d56"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ipcfile = testpath/"client"
    runfile = testpath/"test.py"

    venv = virtualenv_create(testpath/"vendor", "python3.11")
    venv.pip_install resource("pyzmq")
    venv.pip_install resource("tnetstring3")

    runfile.write(<<~EOS,
      import threading
      from urllib.request import urlopen
      import tnetstring
      import zmq
      def server_worker(c):
        ctx = zmq.Context()
        sock = ctx.socket(zmq.REP)
        sock.connect('ipc://#{ipcfile}')
        c.acquire()
        c.notify()
        c.release()
        while True:
          m_raw = sock.recv()
          req = tnetstring.loads(m_raw[1:])
          resp = {}
          resp[b'id'] = req[b'id']
          resp[b'code'] = 200
          resp[b'reason'] = b'OK'
          resp[b'headers'] = [[b'Content-Type', b'text/plain']]
          resp[b'body'] = b'test response\\n'
          sock.send(b'T' + tnetstring.dumps(resp))
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      with urlopen('http://localhost:10000/test') as f:
        body = f.read()
        assert(body == b'test response\\n')
    EOS
                 )

    pid = fork do
      exec "#{bin}/condure", "--listen", "10000,req", "--zclient-req", "ipc://#{ipcfile}"
    end

    begin
      system testpath/"vendor/bin/python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

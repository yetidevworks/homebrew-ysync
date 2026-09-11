class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.4/ysync-v0.2.4-aarch64-apple-darwin.tar.gz"
      sha256 "4155fea5f9b9c9d6fd8ecf597fde5394e2f8b5bd6f09408d228685cd4d034bea"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.4/ysync-v0.2.4-x86_64-apple-darwin.tar.gz"
      sha256 "6e9d855d5a2d7e4a126cbc0bf92036552742e6993b68646545f1ee381076b85a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.4/ysync-v0.2.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b54d4ca171b89c718e18b8d0759608f3c8261507d27c89bc87f1f0cc2a70c3c9"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.4/ysync-v0.2.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0503b616ed6293f61b35f3ca934c76fa0e0398609a9dae480a4ddef4140cb91c"
    end
  end

  def install
    bin.install "ysync"
    doc.install "README.md", "CHANGELOG.md"
  end

  service do
    run [opt_bin/"ysync", "serve"]
    keep_alive true
    log_path var/"log/ysync.log"
    error_log_path var/"log/ysync.log"
  end

  def caveats
    <<~EOS
      Initialize and configure ysync before starting a service:
        ysync init
        ysync folder add projects ~/Projects

      Use either `brew services start ysync` or ysync's own service commands
      to manage a single daemon. This installation does not start syncing.
      Linux release binaries require glibc 2.35 or newer.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ysync --version")
    system bin/"ysync", "--home", testpath/"state", "init", "--name", "brew-test", "--listen", "127.0.0.1:0"
    assert_path_exists testpath/"state/identity.json"
    assert_path_exists testpath/"state/index.sqlite"
  end
end

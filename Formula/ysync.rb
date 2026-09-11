class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.0/ysync-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "8f113b1c06c719fcbbcf682754ed79e6714a69f225533e2f55da27a46af7fcca"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.0/ysync-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "f19d346dfa98a43c79feeb83f58756e88760e28280ff076b63e553176aa64cfa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.0/ysync-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7f1e8b833bf85ea172166fe961ac1fca2d7a5509544189208e937e0fded4d2c4"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.0/ysync-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "52a93926815104be6ce55808b570018365b60318e631131079b4df5adba54d20"
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

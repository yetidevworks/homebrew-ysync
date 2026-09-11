class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.1/ysync-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "3e6930d3eaaa0be7cef6acec1333e8a0759eb4bf4db462ab6ce994ef9d855241"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.1/ysync-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "9d94ad3b42300a8c1ba7577ecc894dcc541e146654794758c343f6bacaf6b655"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.1/ysync-v0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "05881d89566a958ee63550b363808ff7128395f9e28b529b4c686ebd2f31f5af"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.1/ysync-v0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3719a1e9167f15c70fb5b16c922876610769cc0cbb0c06f74f8751f1a2c688ec"
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

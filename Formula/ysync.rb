class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.3/ysync-v0.3.3-aarch64-apple-darwin.tar.gz"
      sha256 "9b0ff9276dbcedbfbd69d37e13bd71fb43fe82ce57af8bf73dde714fc43fc08d"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.3/ysync-v0.3.3-x86_64-apple-darwin.tar.gz"
      sha256 "9a947ca6d7c064bcda1adb0afd2f4b63d145cf8a4fc57eee36fb85508919322a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.3/ysync-v0.3.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "39ffc3ba42c08add84f921163ce69ae5fedd51608d52c09492d65ad6af5f1a0d"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.3/ysync-v0.3.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8705179a2e26bf571996f6c074727e8b2ea88b766c5008f4e855a09c61e0f4c7"
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

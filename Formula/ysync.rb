class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.3/ysync-v0.2.3-aarch64-apple-darwin.tar.gz"
      sha256 "0de48b4ea8e71775a3dfbdbe9e3b3bffc4cc0d6dadeada21f34c564854d67aea"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.3/ysync-v0.2.3-x86_64-apple-darwin.tar.gz"
      sha256 "96a5cbc2af0e11821f85b21cbc3d5ef0f455b0b5a3952f551bd5052e87e0c326"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.3/ysync-v0.2.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ebe62da690b168654cc30e15f00ab21b173900bebeb1c10c69136f9f2da9ae6e"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.3/ysync-v0.2.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cfb4a298d277eb74e583bce70ca625dc2df6023c903a25f702f4fdca7eba9ebb"
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

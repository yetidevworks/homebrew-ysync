class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.2/ysync-v0.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "137b1b3d0af3d031bbd1cc356fd524533ff150c130beda1dc843a4b54c9d4082"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.2/ysync-v0.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "d0bca99d867cb0373def7f4ad5fccaa8fc51a642db8765e440737860337d0bc9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.2/ysync-v0.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1c22080174281ef38d5bd80ed229b2f005165c1d3a499c90502525c9c76d269e"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.2/ysync-v0.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bd444d26f050b52d3b0f9e4b351755def112e1fb4bcab3c6368184ede79a72ea"
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

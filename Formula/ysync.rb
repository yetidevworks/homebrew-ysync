class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.0/ysync-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "0172014a72b9b9fbb6330158bf27cbe6503556e0ba0e64edf66c1b59e9848221"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.0/ysync-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "316cdfb936e8230e09c9bf15eebb28105b22c91c8b3ff1de27d84e6f342f515e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.0/ysync-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87357619f5d38efd3882e04dc9f0a1ed032d5f3cb92ea1339950f06ca35816a6"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.0/ysync-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f05fd56c8edc446e1edf64513e08c47d3296d124eefbfea3fa36b32ad64c44dd"
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

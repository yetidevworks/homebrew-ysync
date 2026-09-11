class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.5/ysync-v0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "4e015a033337551f2456c79ef74574359d24e1148b78acdb58e7c26c9f2d40c2"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.5/ysync-v0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "1270d2ae1154fb0af4abbf734c03fae27263a556d454c94af2943485be129ab5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.5/ysync-v0.2.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "287a56ca6499f0bd34178bd237e4841a1faa1f09f7f59b3a4247234be4b7088a"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.5/ysync-v0.2.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "06fd2dfd8c410f4bacd54b9ff0ab9ce4a05b2462eda3ed23bd1f4af7ae18c168"
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

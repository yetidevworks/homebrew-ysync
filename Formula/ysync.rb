class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.1/ysync-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "f140fd07d35dd6e61a30033764744dd06e16cc3fffbc6047cbd0d201160bd9f4"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.1/ysync-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "5db1a3a94ce80c7ec7e7cf30d6e13ff3b9bcdecb8cd9ed290868af88598b52be"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.1/ysync-v0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d11ce6f17c68bce99a3d666ccca4374ab93cd0a04c39eb97ca799c9fd133c08c"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.4.1/ysync-v0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38f4207487a33ce3ef8daed01ce97ed7089c6658ca6581fee16f1c159684d834"
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

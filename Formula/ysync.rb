class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.2/ysync-v0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "de9c8bfb42b3d2ee1f8620749f858313c531ef7c60f245040b4f8050bfb08462"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.2/ysync-v0.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "74e510606670781e75cc5d9d2788cf2f67ede393e255d24194cb7f75e6a8052c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.2/ysync-v0.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d291a9f14ad372775f69da4e654e76088a2bc058aabcac25f3116d326905bca1"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.3.2/ysync-v0.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "be1ccacebacd5880efea7dbecb6ec3dd190cbf4203ef2575028dca6020a10b04"
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

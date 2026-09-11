class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.0/ysync-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "84e631e80feffe1345d3fa3538c081f89eaa3a0de44216ed2cf4d3611fbabf1f"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.0/ysync-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "320ffcff53c369ee549c88429580752d367abfd91acfac5c38a1c25f45468a12"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.0/ysync-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b33fddf6e02addda639b0eb4ed3d5b67d7d24d32d49b3d0a09d6969a4eef4a34"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.0/ysync-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "00eebaba18559ad1f11127b5849f0289c5fa0d7db0b4ae9343efb2af2249e95c"
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
    assert_predicate testpath/"state/identity.json", :exist?
    assert_predicate testpath/"state/index.sqlite", :exist?
  end
end

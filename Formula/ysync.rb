class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.6/ysync-v0.2.6-aarch64-apple-darwin.tar.gz"
      sha256 "e61d259e67fc1d689a455fe43ac525ef13d4094a274646aaa5c8ab845df12e91"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.6/ysync-v0.2.6-x86_64-apple-darwin.tar.gz"
      sha256 "337b0dbd4622fa1876c67e3a7d8f141aff829d4b179820417d40d70030611e42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.6/ysync-v0.2.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a8e7d17d1f4f2f971fbed2a8764e4d1a17e92cc4dcdc2fabbefa4f3fafca26f0"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.6/ysync-v0.2.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a6e074be78f363ed0fa3ca721e5418d254971b4e07d4403cd2674a3e91419ee2"
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

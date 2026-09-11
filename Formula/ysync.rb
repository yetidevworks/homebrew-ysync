class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.2/ysync-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "f611757215c66d5622a7b571f7149a036b32977c610e3e6a232b7cb4af8ae60f"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.2/ysync-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "2415da96caf53e06a5df22be9c67f61f5a9245dec37d4203203cef0bbc5c918c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.2/ysync-v0.2.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ca5808849cb9384bedb54d5d4152c55ff8c434a19aaa65890103b9fa7b133077"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.2.2/ysync-v0.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0ae4d668d1111f5c0ed3b4f80ff0810545984cffd8de894585559e19d1deed4"
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

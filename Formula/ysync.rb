class Ysync < Formula
  desc "Direct encrypted file synchronization for macOS and Linux"
  homepage "https://github.com/yetidevworks/ysync"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.1/ysync-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "d0ca048146db4fded882048db602716b3f1ae626b84fb1127025b60742c9a0c2"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.1/ysync-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "941fe4e639814228a1f11877bc99c7892931f80a178da75e8956753847ee6b93"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.1/ysync-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ea53196fe432c5233dcf75f5c0ad033cd5fb73a8ec4028f2417bc7f2c9aac2c9"
    end
    on_intel do
      url "https://github.com/yetidevworks/ysync/releases/download/v0.1.1/ysync-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "de4dd09187942fe537d2a8da75984807837f5780339a17a4670f6e9b37d305fe"
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

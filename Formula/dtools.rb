class Dtools < Formula
  desc "Collection of command-line tools for managing personal machines"
  homepage "https://github.com/drusellers/dtools"
  url "https://github.com/drusellers/dtools/releases/download/v2026.10.20.102433-e42dc12/dtools-v2026.10.20.102433-e42dc12.tar.gz"
  version "2026.10.20.102433-e42dc12"
  sha256 "356f00b41829c6e883aac4fd9d1cb254638676aa676c055e0bbd3dfa3e97dcd3"
  license "Apache-2.0"
  head "https://github.com/drusellers/dtools.git", branch: "main"

  depends_on "node"

  def install
    bin.install "bin/dnet"
    libexec.install "libexec/dnet", "libexec/dask", "libexec/dmail", "libexec/djobs"
    doc.install "README.md", "AGENTS.md", "LICENSE"
    pkgshare.install "examples"

    # Use the declared dependency even when another Node comes first on PATH.
    (bin/"dask").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dask/ask.mjs" "$@"
    SH
    (bin/"dask").chmod 0755

    (bin/"dmail").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dmail/mail.mjs" "$@"
    SH
    (bin/"dmail").chmod 0755

    (bin/"djobs").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/djobs/jobs.mjs" "$@"
    SH
    (bin/"djobs").chmod 0755
  end

  test do
    assert_match "dnet (dtools)", shell_output("#{bin}/dnet --version")
    assert_path_exists libexec/"dnet/netcheck"
    assert_match "dask", shell_output("#{bin}/dask --help")
    assert_path_exists libexec/"dask/index.html"
    assert_path_exists libexec/"dask/app.js"
    assert_path_exists libexec/"dask/style.css"
    assert_match "dmail login", shell_output("#{bin}/dmail --help")
    assert_path_exists libexec/"dmail/mail.mjs"
    assert_match "djobs ignore PREFIX", shell_output("#{bin}/djobs --help")
    assert_path_exists libexec/"djobs/schedules.mjs"

    # `ignore` only writes the selected config file; it never calls launchctl.
    if OS.mac?
      config = testpath/"djobs/config.json"
      shell_output("#{bin}/djobs ignore com.example. --config #{config}")
      assert_equal ["com.example."], JSON.parse(config.read)["excludePrefixes"]
    end

    (testpath/"questions.json").write <<~JSON
      {
        "questions": [{
          "id": "test",
          "prompt": "Does the installed server start?",
          "options": [{ "id": "yes", "label": "Yes" }]
        }]
      }
    JSON
    output = shell_output("#{bin}/dask ask #{testpath}/questions.json --no-open --timeout 1")
    assert_equal({ "status" => "cancelled", "reason" => "timeout" }, JSON.parse(output))
  end
end

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

---

# CI Workflow với Vibe

Mục tiêu

- Tự động lint, test, validate deploy metadata khi có thay đổi.
- Đo hiệu năng khi generate manifest và validate deploy: thời gian, exit code, error_count.
- Lưu log/artifact tại `VideWorkflowLogs/` để phân tích.

Kiến trúc tổng quan

- Trigger: `push` và `pull_request` vào nhánh chính (ví dụ `main`, `develop`).
- Jobs chính:
  1. Setup: Checkout, Node, cài `sf` CLI, xác thực org (JWT/OAuth).
  2. Lint & Unit test: LWC Jest, Apex test (nếu có).
  3. Metadata Ops:
     - Generate manifest (tùy chọn).
     - Validate deploy (check-only) bằng `sf` CLI.
  4. Observability: đo thời gian, ghi exit code, thống kê lỗi, upload artifact.

Chuẩn bị secrets (GitHub)

- `SF_USERNAME`: Username org target.
- `SF_JWT_KEY`: Private key (base64) cho JWT.
- `SF_CONSUMER_KEY`: Connected App Consumer Key.
- (Tùy chọn) `NPM_TOKEN`: nếu cần.

Nguyên tắc

- Luôn dùng `sf` CLI (không dùng sfdx).
- Dùng tham số `--json` để parse ổn định.
- Không dừng job trước khi upload artifact; fail ở bước cuối nếu cần.

Thư mục và file liên quan

- `manifest/package.xml`: danh sách metadata.
- `VideWorkflowLogs/`: chứa raw output và metrics JSON mỗi run.
- `scripts/`:
  - `measure_bash.sh`: đo trên runner Linux/macOS.
  - `measure_ps.ps1`: đo trên runner Windows (PowerShell).

Định dạng metrics
Ví dụ `VideWorkflowLogs/metrics_validate_deploy.json`
{
"metric": "validate_deploy",
"duration_ms": 12873,
"exit_code": 0,
"error_count": 0,
"timestamp": "2025-10-30T06:15:00Z"
}

Thực hành tốt

- Tách job `validate_deploy` cho PR, và job `deploy` thật cho `main`.
- Bọc từng lệnh cần đo trong hàm đo thời gian.
- Parse JSON từ `sf` để đếm lỗi cụ thể, không chỉ dựa vào chuỗi "error".
- Lưu artifact bằng `actions/upload-artifact`.

Cách mở rộng

- Tổng hợp rolling mean qua nhiều run bằng một workflow nightly, đọc artifact/logs và tính trung bình 7/30 ngày.
- Đẩy metrics sang dashboard (GitHub Pages/Datadog/Grafana) nếu cần.

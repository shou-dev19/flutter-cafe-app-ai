# Flutter Cafe App - Portfolio

## 1. Project Overview

This is a sample cafe application developed to showcase my skills in front-end development with Flutter and building a serverless architecture on AWS.

- **Application URL:** [https://d2nh2abk1vdbtw.cloudfront.net](https://d2nh2abk1vdbtw.cloudfront.net)
- **GitHub Repository:** [https://github.com/shou-dev19/flutter-cafe-app-ai](https://github.com/shou-dev19/flutter-cafe-app-ai)

### Key Features
- View a list of cafe menu items.
- Filter menu items by category (e.g., Coffee, Tea, Food).
- Add/remove items to/from a shopping cart.
- View the total price in the cart.

## 2. Technical Stack

- **Front-End:** Flutter (Web)
- **Cloud Provider:** AWS
  - **Hosting:** Amazon S3
  - **CDN & SSL/TLS:** Amazon CloudFront
  - **CI/CD Permissions:** AWS IAM (OIDC integration with GitHub Actions)
- **Infrastructure Provisioning:** AWS CLI, Gemini CLI
- **CI/CD:** GitHub Actions
- **Testing:**
  - **Unit/Widget Tests:** Flutter Test
  - **End-to-End (E2E) Tests:** Cypress

## 3. System Architecture

The application is hosted on a serverless architecture on AWS, designed for scalability, performance, and cost-efficiency.

![AWS Architecture](./AWS_ARCHITECTURE.md)

### CI/CD Pipeline

The deployment process is fully automated using GitHub Actions.

1.  **Trigger:** A `push` to the `main` branch triggers the workflow.
2.  **Build:** The Flutter web application is built.
3.  **Deploy:** The built static files are synced to an S3 bucket.
4.  **Cache Invalidation:** The CloudFront cache is invalidated to ensure users get the latest version.

This automated pipeline allows for rapid and reliable deployments.

## 4. Key Achievements & Skills Demonstrated

### Serverless Web Hosting on AWS
- Successfully built and configured a scalable hosting environment using **Amazon S3** for static file storage and **Amazon CloudFront** as a CDN.
- Implemented HTTPS for secure communication using the default CloudFront certificate.
- Configured CloudFront to use a default root object (`index.html`), improving the user experience.

### Fully Automated CI/CD Pipeline
- Created a GitHub Actions workflow to automate the entire process from building the Flutter app to deploying it on AWS.
- This demonstrates an understanding of modern DevOps practices and the ability to create efficient development cycles.

### Secure and Modern Authentication for CI/CD
- Leveraged **OpenID Connect (OIDC)** to allow GitHub Actions to securely assume an **IAM Role** in AWS.
- This approach avoids storing long-lived AWS access keys as GitHub secrets, significantly enhancing security.

### Semi-Automated Infrastructure Setup with CLI Tools
- Utilized the **AWS CLI** and **Gemini CLI** to semi-automate the creation of AWS resources (S3, IAM Roles, etc.).
- This approach demonstrates the ability to efficiently manage and provision cloud infrastructure through code, which is a key aspect of Infrastructure as Code (IaC) principles.

### Comprehensive Testing Strategy
- Implemented **unit and widget tests** in Flutter to ensure individual components function correctly.
- Introduced **E2E tests with Cypress** to verify critical user flows (e.g., adding items to the cart, filtering the menu) from an end-user perspective, ensuring high quality for the entire application.

---

# Flutter Cafe App - ポートフォリオ

## 1. プロジェクト概要

このアプリケーションは、Flutterによるフロントエンド開発と、AWS上でのサーバーレスアーキテクチャ構築のスキルを証明するために作成したサンプルカフェアプリです。

- **アプリケーションURL:** [https://d2nh2abk1vdbtw.cloudfront.net](https://d2nh2abk1vdbtw.cloudfront.net)
- **GitHubリポジトリ:** [https://github.com/shou-dev19/flutter-cafe-app-ai](https://github.com/shou-dev19/flutter-cafe-app-ai)

### 主な機能
- カフェのメニュー一覧の表示
- カテゴリ（例: コーヒー, 紅茶, フード）によるメニューの絞り込み
- ショッピングカートへの商品の追加・削除
- カート内の合計金額の表示

## 2. 技術スタック

- **フロントエンド:** Flutter (Web)
- **クラウド:** AWS
  - **ホスティング:** Amazon S3
  - **CDN & SSL/TLS:** Amazon CloudFront
  - **CI/CD権限:** AWS IAM (GitHub ActionsとのOIDC連携)
- **インフラ構築:** AWS CLI, Gemini CLI
- **CI/CD:** GitHub Actions
- **テスト:**
  - **ユニット/ウィジェットテスト:** Flutter Test
  - **E2E（エンドツーエンド）テスト:** Cypress

## 3. システムアーキテクチャ

このアプリケーションは、スケーラビリティ、パフォーマンス、コスト効率を重視して設計されたAWSのサーバーレスアーキテクチャ上でホスティングされています。

![AWS Architecture](./AWS_ARCHITECTURE.md)

### CI/CDパイプライン

デプロイプロセスはGitHub Actionsによって完全に自動化されています。

1.  **トリガー:** `main`ブランチへの`push`がワークフローを起動します。
2.  **ビルド:** Flutter Webアプリケーションがビルドされます。
3.  **デプロイ:** ビルドされた静的ファイルがS3バケットに同期されます。
4.  **キャッシュ無効化:** CloudFrontのキャッシュが無効化され、ユーザーが最新のバージョンを確実に受け取れるようにします。

この自動化されたパイプラインにより、迅速で信頼性の高いデプロイが可能です。

## 4. アピールポイントと証明できるスキル

### AWSによるサーバーレスWebホスティング
- 静的ファイルストレージとして**Amazon S3**、CDNとして**Amazon CloudFront**を利用し、スケーラブルなホスティング環境を構築・設定しました。
- CloudFrontのデフォルト証明書を利用して、安全な通信のためのHTTPSを実装しました。
- デフォルトルートオブジェクト（`index.html`）を設定することで、ユーザー体験を向上させました。

### CI/CDパイプラインの完全自動化
- FlutterアプリのビルドからAWSへのデプロイまで、プロセス全体を自動化するGitHub Actionsワークフローを作成しました。
- これにより、最新のDevOpsプラクティスへの理解と、効率的な開発サイクルを構築する能力を証明できます。

### CI/CDのためのセキュアでモダンな認証
- **OpenID Connect (OIDC)** を活用し、GitHub ActionsがAWSの**IAMロール**を安全に引き受けることを許可しました。
- このアプローチにより、有効期間の長いAWSアクセスキーをGitHub Secretsとして保存する必要がなくなり、セキュリティが大幅に向上します。

### CLIツールによるインフラ構築の半自動化
- **AWS CLI**と**Gemini CLI**を活用し、AWSリソース（S3, IAMロールなど）の作成を半自動化しました。
- このアプローチは、コードを通じてクラウドインフラを効率的に管理・プロビジョニングする能力、すなわちInfrastructure as Code (IaC) の基本原則を実践していることを示します。

### 包括的なテスト戦略
- Flutterの**ユニットテスト**と**ウィジェットテスト**を実装し、個々のコンポーネントが正しく機能することを確認しました。
- **CypressによるE2Eテスト**を導入し、エンドユーザー視点での重要なフロー（例: カートへの商品追加、メニューの絞り込み）を検証することで、アプリケーション全体の高い品質を確保しました。

